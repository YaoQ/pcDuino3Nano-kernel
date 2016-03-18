# pcDuino3Nano-kernel

pcDuino3 Nano sunnxi kernel build script and auxiliary files

Manual Kernel Build Process
---------------------------
```
cd ./staging  
mkdir -p ./output/boot  

git clone https://github.com/dan-and/linux-sunxi.git  
git clone https://github.com/digitalhack/pcDuino3Nano-kernel.git  
unzip -o ./pcDuino3Nano-kernel/firmware.zip -d ./linux-sunxi/  

cd linux-sunxi
```
### Patch allwinner gmac driver for pcDuino3 Nano  
```
patch --batch -N -p1 < ../pcDuino3Nano-kernel/linksprite_pcduino3_nano_gmac.patch  
make CROSS_COMPILE=arm-linux-gnueabihf- clean  
cp ../pcDuino3Nano-kernel/linksprite_pcduino3_nano_defconfig .config  
```

### **Optional step** if you want to change the configuration  
```
make -j2 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig    
```

### Compile the kernel
```
make -j2 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- all zImage modules_prepare  
```

### Patch the buildtar script to include zImage as vmlinuz in the tar file  
```
patch --batch -N -p1 < ../pcDuino3Nano-kernel/zImage_buildtar.patch  

make -j1 targz-pkg LOCALVERSION="-pcduino3-nano" ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-    
```

### Uncomment the lines below if you want to update fex and script files
```
fex2bin ../pcDuino3Nano-kernel/Linksprite_pcDuino3_Nano.fex ../pcDuino3Nano-kernel/linksprite-pcduino3-nano.bin  
mkimage -C none -A arm -T script -d ../pcDuino3Nano-kernel/boot.cmd ../pcDuino3Nano-kernel/boot.scr >> /dev/null  
```

### Move the boot files to staging  
```
cp ../pcDuino3Nano-kernel/boot.scr ../output/boot  
cp ../pcDuino3Nano-kernel/linksprite-pcduino3-nano.bin ../output/boot  
cp *pcduino3-nano.tar.gz ../output/boot  
```

If you wish to update your kernel continue below. I you are building a complete sdcard continue on to digitalhack/pcDuino3Nano-rootfs

### Update the sdcard with new kernel  
```
cd ../output  
mkdir bootfs  
mkdir rootfs  
```

> bootfscard="/dev/sdb1"    
> rootfscard="/dev/sdb2"    

```
mount ${bootfscard} ./bootfs  
tar zxvf ./boot/linux-3.4.106-pcduino3-nano.tar.gz --wildcards --strip-components=1 -C ./bootfs/ boot/System.map*   boot/config* boot/vmlinuz*  
umount ${bootfscard}  

mount ${rootfscard} ./rootfs  
tar zxvf ./boot/linux-3.4.106-pcduino3-nano.tar.gz -C ./rootfs/ lib  
umount ${rootfscard}  
```
