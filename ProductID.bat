@echo off

 call :isAdmin

 if %errorlevel% == 0 (
    goto :run
 ) else (
    echo Requesting administrative privileges...
    goto :UACPrompt
 )

 exit /b

 :isAdmin
    fsutil dirty query %systemdrive% >nul
 exit /b

 :run
@echo off
color 2
title ProductID

:A
cls
Setlocal EnableDelayedExpansion
set _RNDLength=12
set _Alphanumeric=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
set _Str=%_Alphanumeric%987654321

:_LenLoop
if not "%_Str:~18%"=="" set _Str=%_Str:~9%& set /A _Len+=9& goto :_LenLoop
set _tmp=%_Str:~9,1%
set /A _Len=_Len+_tmp
set _count=0
set _RndAlphaNum=

:_loop
set /a _count+=1
set _RND=%Random%
set /A _RND=_RND%%%_Len%
set _RndAlphaNum=!_RndAlphaNum!!_Alphanumeric:~%_RND%,1!
if !_count! lss %_RNDLength% goto _loop
echo.
echo ===================================
echo ProductID is: !_RndAlphaNum!
echo ===================================
echo.
@echo off
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductId /f >Nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductId /d !_RndAlphaNum! >Nul
reg delete "HKLM\SOFTWARE\Microsoft\Internet Explorer\Registration" /v ProductId /f >Nul
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Registration" /v ProductId /d !_RndAlphaNum! >Nul
pause
 exit /b

 :UACPrompt
   echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
   echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

   "%temp%\getadmin.vbs"
   del "%temp%\getadmin.vbs"
  exit /B`