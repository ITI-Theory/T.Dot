@echo off
REM HAL.cmd - runs the bash HAL through Git Bash, so `HAL` works from cmd and
REM PowerShell on Windows. One implementation only: the bash scripts in this
REM folder (T.Dot/DESIGN.md). The old cmd version is kept as HAL.bat.OBSOLETE.
setlocal
set "GITBASH=%ProgramFiles%\Git\bin\bash.exe"
if not exist "%GITBASH%" (
  echo [HAL] Git Bash not found at "%GITBASH%". Install Git for Windows first.
  exit /b 1
)
REM After `HAL init` the dispatcher in ~/.local/bin picks the highest layer
REM (HAL1, HAL0); before that, go straight to HAL0 so `HAL init` can run.
if exist "%USERPROFILE%\.local\bin\HAL" (
  "%GITBASH%" "%USERPROFILE%\.local\bin\HAL" %*
) else (
  "%GITBASH%" "%~dp0HAL0" %*
)
exit /b %ERRORLEVEL%
