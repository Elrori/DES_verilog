# -*- coding:utf-8 -*-
#
# Name  :FPGA based DES design,python上位机,下位机IC：CY7C68013A
# Origin:190415
# Author:helrori
#
import usb.core 
import usb.util
import sys
import time
from   pyDes import des, PAD_NORMAL,ECB
import binascii
import numpy as np
pkg_1 = 1 #该值最大值由FPGA 内FIFO大小决定 fifo_size/512 详见usb.v内说明
def des_encrypt(k,s):
    """
    DES 加密
    :param s: 原始字符串
    :return: 加密后字符串，16进制
    """
    secret_key = k
    iv = secret_key
    k = des(secret_key, ECB, iv, pad=None, padmode=PAD_NORMAL )
    en = k.encrypt(s, padmode=PAD_NORMAL )
    return (en)
 
 
def des_descrypt(k,s):
    """
    DES 解密
    :param s: 加密后的字符串，16进制
    :return:  解密后的字符串
    """
    secret_key = k
    iv = k
    k = des(secret_key, ECB, iv, pad=None, padmode=PAD_NORMAL )
    de = k.decrypt(s, padmode=PAD_NORMAL )
    return  (de)

def fpga_des(dev=None,encrypt=True,debug_mesg=True,key=bytearray(b'\x13\x34\x57\x79\x9B\xBC\xDF\xF1'),text=''):
    """
    FPGA DES 加密或解密
    :param dev:
    :param encrypt:
    :param debug_mesg:
    :param key:
    :param text:原文余8为0，且必须 < 65535*fifo_size字节;
    :return: recvdata
    """
    global pkg_1
    fifo_size=pkg_1*512 #FPGA FIFO字节大小

    n=1+len(text)//fifo_size    # 下发包数量;text < 65535*fifo_size
    uu=len(text)%fifo_size      # 余
    pkg_0 = n.to_bytes(2, byteorder = 'big')
    pkg_1_ = pkg_1.to_bytes(2, byteorder = 'big')
    if(encrypt == True):
        if(key[7]&1!=1):
            key[7]=key[7]+1
    else:
        if(key[7]&1==1):
            key[7]=key[7]-1
    
    #REGW
    dev.write(0x02,b'REGW0000',100)# 'REGW0000'字节数不足512，实际下发仍是512字节
    data = dev.read(0x86,512)
    if(debug_mesg==True):
        print ('send: REGW0000 recv: '+''.join(c for c in map(chr,data[0:8])))
    dev.write(0x02,key,100)
    #REGW_END
    recvdata =np.zeros(len(text),dtype='uint8')
    microdata=np.zeros(fifo_size,dtype='uint8')
    
    #text=np.append(text,[0]*(fifo_size-uu))# text增加到fifo_size的整数倍
    for i in range(fifo_size-uu):
        text+=b'\x00'
    #LOPD
    dev.write(0x02,b'LOPD'+pkg_1_+pkg_0,100)
    buff0=dev.read(0x86,512)
    for j in range(n):
        if(j==(n-1)):
            ed=j*fifo_size+uu
        else:
            ed=(j+1)*fifo_size
        if(j*fifo_size != ed):
            dev.write(0x02,text[j*fifo_size:(j+1)*fifo_size],100)

            microdata = np.array(dev.read(0x86,fifo_size))
            recvdata[j*fifo_size:ed] = microdata[0:ed-j*fifo_size].copy()
    #LOPD_END
    return recvdata
def fpga_encrypt(dev,key,ifilename,ofilename):
    global pkg_1
    fifo_size=pkg_1*512 #FPGA FIFO字节大小
    #加密补零
    flie=open(ifilename, 'rb+')
    databytes = flie.read()
    u=len(databytes)%8
    padding=8-u
    for i in range(padding):
        databytes+=b'\x00' # zeros padding ANSI X.923
    if(len(databytes) >= 65535*fifo_size):#
        print('file too big:',len(databytes))
        recvdata =np.zeros(len(databytes),dtype='uint8')
        n=1+len(databytes)//(65535*fifo_size-8)
        u=len(databytes)%(65535*fifo_size-8)
        for i in range(n):
            if(i==(n-1)):
                ed=i*(65535*fifo_size-8)+u
            else:
                ed=(i+1)*(65535*fifo_size-8)
            if(ed != i*(65535*fifo_size-8)):
                buff=fpga_des(dev,True,True,key,databytes[i*(65535*fifo_size-8):ed])
                recvdata[i*(65535*fifo_size-8):ed]=buff[0:ed-i*(65535*fifo_size-8)].copy()
    else:
        recvdata=fpga_des(dev,True,False,key,databytes)
    #加密文件保存
    file_o= open(ofilename, 'w')
    recvdata=np.append(recvdata,np.array(padding,dtype='uint8'))# paddding信息同时保存到.des文件
    recvdata.tofile(file_o)
    file_o.close()
    flie.close()
    return len(databytes)
    
def fpga_descrypt(dev,key,ifilename,ofilename):
    global pkg_1
    fifo_size=pkg_1*512 #FPGA FIFO字节大小
    #解密
    flie=open(ifilename, 'rb+')
    databytes = flie.read()
    if((len(databytes)-1) >= 65535*fifo_size):#
        print('file too big:',len(databytes)-1)
        recvdata =np.zeros(len(databytes)-1,dtype='uint8')
        n=1+(len(databytes)-1)//(65535*fifo_size-8)
        u=(len(databytes)-1)%(65535*fifo_size-8)
        for i in range(n):
            if(i==(n-1)):
                ed=i*(65535*fifo_size-8)+u
            else:
                ed=(i+1)*(65535*fifo_size-8)
            if(ed != i*(65535*fifo_size-8)):
                buff=fpga_des(dev,False,True,key,databytes[i*(65535*fifo_size-8):ed])
                recvdata[i*(65535*fifo_size-8):ed]=buff[0:ed-i*(65535*fifo_size-8)].copy()
    else:
        recvdata=fpga_des(dev,False,False,key,databytes[0:-1])# 去掉paddding
        
    padding=databytes[-1]                                 # 得到.des文件的paddding信息
    #解密文件保存
    file_o= open(ofilename, 'w')  
    recvdata[0:-(padding)].tofile(file_o)# 去掉paddding保存
    file_o.close()
    flie.close()
    return len(databytes)-1
    
def main():
    dev = usb.core.find(idVendor=0x04b4, idProduct=0x1003)
    #print(dev)
    if dev is None:
        raise ValueError('Device not found')
    dev.set_configuration()
    print('Device found VID 0x04b4,PID 0x1003')

    key = bytearray(b'\x13\x34\x57\x79\x9B\xBC\xDF\xF1')
    text0 = b'\x01\x23\x45\x67\x89\xAB\xCD\xEF'
    text1 = b'\x85\xE8\x13\x54\x0F\x0A\xB4\x05'
    print('------------------------python pyDes 加密解密结果--------------------------')
    print("key      :  "+ ' '.join(c for c in map(hex,key)))
    print("text0    :  "+ ' '.join(c for c in map(hex,text0)))
    print("text1    :  "+ ' '.join(c for c in map(hex,text1)))

    a=des_encrypt(key,text0)
    b=des_encrypt(key,text1)
    print('en(text0): ',' '.join(c for c in map(hex,a)),'\nen(text1): ',' '.join(c for c in map(hex,b)))
    a=des_descrypt(key,text0)
    b=des_descrypt(key,text1)
    print('de(text0): ',' '.join(c for c in map(hex,a)),'\nde(text1): ',' '.join(c for c in map(hex,b)))

    print('------------------------FPGA USB DES 加密解密结果--------------------------')
    print("key      :  "+ ' '.join(c for c in map(hex,key)))
    print("text0    :  "+ ' '.join(c for c in map(hex,text0)))
    print("text1    :  "+ ' '.join(c for c in map(hex,text1)))
    a=fpga_des(dev,True,False,key,text0)
    b=fpga_des(dev,True,False,key,text1)
    print('en(text0): ',' '.join(c for c in map(hex,a)),'\nen(text1): ',' '.join(c for c in map(hex,b)))
    a=fpga_des(dev,False,False,key,text0)
    b=fpga_des(dev,False,False,key,text1)
    print('de(text0): ',' '.join(c for c in map(hex,a)),'\nde(text1): ',' '.join(c for c in map(hex,b)))

    
    print('--------------------------------------------------------------------------')

    print('--------------------------FPGA USB DES 加密解密文件测试-------------------')
    encrypt=input('请选择加密或解密 0:加密; 1:解密 ')

    k=input('请输入8字节密钥(直接回车使用默认密钥):\n')

    ifilename=input('输入文件名:\n')


    if(k==''):
        k=key
        print('key: '+' '.join(c for c in map(hex,k)))
    else:
        if(len(k)==8):
            k=k.encode()
            k=bytearray(k)
            print('key: ',k)
        else:
            print('key not valuable')
            exit(0)
    if(ifilename==''):
        print('file name empty')
        exit(0)
    else:
        print('file name: ',ifilename)
        
    if(encrypt=='0'):
        ofilename=ifilename+'.des'
        print('output file name: ',ofilename)
        start = time.time()
        file_size=fpga_encrypt(dev,k,ifilename,ofilename)
        end   = time.time()
    elif(encrypt=='1'):
        ofilename=ifilename[0:-4]
        if(ifilename[-4:] != '.des'):
            print('not des file')
            exit(0)
        print('output file name: ',ofilename)
        start = time.time()
        file_size=fpga_descrypt(dev,k,ifilename,ofilename)
        end   = time.time()
    else:
        print('???')
        exit(0)
    

    
    print("time consuming :%.3f seconds" % (end - start))
    #print("实际速度  :%.3f MB per second" % (file_size/(end - start)/1024/1024))
    print('--------------------------------------------------------------------------')
if __name__ == "__main__":
    main()
