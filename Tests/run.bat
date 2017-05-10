@echo off

set ifc=%1
set dae=%ifc:~0,-5%.dae
set dae=%dae:testfiles=results%

shift
set "args="
:parse
if "%~1" neq "" (
  set args=%args% %1
  shift
  goto :parse
)
if defined args set args=%args:~1%

IfcConvert %args% %ifc% %dae%
if %errorlevel% EQU 0 (
	call cecho 0 10 %ifc%" convertion succeed" >&2
	)
if not %errorlevel% EQU 0 (
	call cecho 0 12 %ifc%" convertion failed" >&2
	)
EXIT /B %errorlevel%