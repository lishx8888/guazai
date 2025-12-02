@echo off
net use * /delete /y >nul 2>&1
timeout /t 5>nul
net use O: \\192.168.110.48\mnt\disk /persistent:yes >nul 2>&1