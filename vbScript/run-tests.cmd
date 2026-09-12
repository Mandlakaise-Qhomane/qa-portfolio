@echo off
cd /d "%~dp0"
cscript //nologo tests\TestRunner.vbs
exit /b %ERRORLEVEL%
