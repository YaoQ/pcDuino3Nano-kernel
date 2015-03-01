setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p2 rootwait sunxi_ve_mem_reserve=0 sunxi_g2d_mem_reserve=0 sunxi_no_mali_mem_reserve sunxi_fb_mem_reserve=16 hdmi.audio=EDID:0 disp.screen0_output_mode=EDID:1280x720p60 panic=10 consoleblank=0
fatload mmc 0 0x43000000 linksprite-pcduino3-nano.bin
fatload mmc 0 0x48000000 vmlinuz-3.4.106-pcduino3-nano
bootz 0x48000000
