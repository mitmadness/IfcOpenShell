@echo off
setlocal EnableDelayedExpansion

set argC=0
for %%x in (%*) do Set /A argC+=1

if not %argC% EQU 0 (
	if "%1"=="--help" ( goto :Helper)
	if "%1"=="-a" (
		set async= 1
		)
	)

if not defined async (set options= %*)
if defined async (
	:: all arguments except first
	for /f "tokens=1,* delims= " %%a in ("%*") do set options=%%b
	)

for %%f in (".\results\*.dae") do call :Delete "%%f"
for %%g in (".\results\*.tmp") do call :Delete "%%g"
for %%h in (".\testfiles\*.ifc") do call :RunConvert "%%h"
if defined async call cecho.cmd 0 15 "The conversions are running. Write quit to interrupt the tests."
if defined async set /p stop=...
if defined async (
	if "%stop%"=="quit" (
		taskkill /F -im IfcConvert.exe
		)
	)
goto End

:Delete
set message=%1" deleted"
call cecho.cmd 0 13 %message%
del %1
EXIT /B 0

:Helper
call cecho.cmd 0 13 "This script is used to test IfcConvert.exe on a range of ifc files in one shot"
call cecho.cmd 0 13 "The results will be written int the results folder"
call cecho.cmd 0 13 "By default the convertions are performed one by one"
echo.
echo Usage : test.bat [options] [IfcConvert.exe options]
echo.
echo Command line options :
echo.    -a                                    Use asynchronous tests. Run all the conversions at the same time.
echo.                                          Should not be used with a large scale of files.


goto End

:RunConvert
set info="--- Converting "%1" ---"
call cecho.cmd 0 11 %info%

if defined async (start /b cmd /c run.bat %1 %options% > NUL)
if not defined async (call run.bat %1 %options%)



:End
