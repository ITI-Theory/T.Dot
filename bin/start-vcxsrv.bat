@echo off
:: Start VcXsrv in fullscreen mode with clipboard + access control disabled.
:: DISPLAY target: default gateway IP (set by HAL1 do_boot) :0.0
:: Run this BEFORE calling "HAL boot" from Debian WSL2.
start "" "C:\Program Files\VcXsrv\vcxsrv.exe" :0 -fullscreen -clipboard -wgl -ac
