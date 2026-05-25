@echo off
setlocal enabledelayedexpansion

net use * /delete /y >nul 2>&1
timeout /t 3 /nobreak >nul

:: 映射 J:
net use J: \\192.168.88.49\Download /persistent:yes >nul 2>&1
timeout /t 1 >nul

:: 映射 O: + 重试机制
set retry=0
:retryO
net use O: \\192.168.88.48\mnt\disk /persistent:yes >nul 2>&1

if exist O:\ (
    echo O: 挂载成功
    goto :end
) else (
    set /a retry+=1
    if %retry% lss 3 (
        echo O: 挂载失败，第 %retry% 次重试...
        timeout /t 3 /nobreak >nul
        goto :retryO
    ) else (
        echo O: 多次重试后仍失败
    )
)

:end
endlocal
