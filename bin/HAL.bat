@echo off
setlocal

REM HAL.bat — T-level command router (Windows)
REM Lives in T.Dot\bin\. Bootstrap: git clone ITI-Theory/T.Dot, then run bin\HAL.bat init

REM Derive paths from this file's location
REM %~dp0 = T.Dot\bin\
REM %~dp0.. = T.Dot\
REM %~dp0..\.. = ITI-Theory\
REM %~dp0..\..\.. = parent of ITI-Theory (e.g. prj\git\)

set "TDOT_ROOT=%~dp0.."
set "ITI=%~dp0..\.."
set "ME_REPO=%~dp0..\..\..\Me"

if "%~1"=="" goto :help

set "CMD=%~1"
shift

if /I "%CMD%"=="prime"  goto :prime
if /I "%CMD%"=="sync"   goto :sync
if /I "%CMD%"=="init"   goto :init
if /I "%CMD%"=="help"   goto :help

echo [HAL] Unknown command: %CMD%
echo [HAL] Run "HAL help" to list commands.
exit /b 1

:prime
REM Output full AI context block — pipe to clipboard: HAL.bat prime | clip
set "PACK1=%~1"
set "PACK2=%~2"
set "PACK3=%~3"

echo ================================================================
echo === HAL prime
echo ================================================================
echo.
echo --- MODE ---
echo AUTOPILOT - propose actions as a numbered checklist, then wait.
echo User vocabulary: 'next'/'y' = next step; 'go all'/'A' = whole list;
echo 'stop'/'n' = abort. Full policy in master instructions below.
echo.
echo --- MASTER INSTRUCTIONS (T/.github/copilot-instructions.md) ---
if exist "%ITI%\T\.github\copilot-instructions.md" (
  type "%ITI%\T\.github\copilot-instructions.md"
) else (
  echo [HAL] WARNING: T master instructions not found
)
echo.
echo --- U INSTRUCTIONS (U/.github/copilot-instructions.md) ---
if exist "%ITI%\U\.github\copilot-instructions.md" (
  type "%ITI%\U\.github\copilot-instructions.md"
) else (
  echo [HAL] WARNING: U instructions not found
)
echo.
echo --- FIELD-NOTES (last 40 lines) ---
if exist "%ITI%\U\paper\FIELD-NOTES.md" (
  powershell -NoProfile -Command "Get-Content '%ITI%\U\paper\FIELD-NOTES.md' | Select-Object -Last 40"
) else (
  echo [HAL] WARNING: FIELD-NOTES.md not found
)
echo.
echo --- GIT STATUS ---
echo === U ===
git -C "%ITI%\U" status -sb 2>nul || echo [HAL] U repo not found
echo === T.Ops ===
git -C "%ITI%\T.Ops" status -sb 2>nul || echo [HAL] T.Ops repo not found
echo === Me ===
git -C "%ME_REPO%" status -sb 2>nul || echo [HAL] Me repo not found

REM --- Packs ---
if "%PACK1%"=="" goto :prime_end
call :pack_%PACK1% 2>nul || echo [HAL] Unknown pack: %PACK1%
if "%PACK2%"=="" goto :prime_end
call :pack_%PACK2% 2>nul || echo [HAL] Unknown pack: %PACK2%
if "%PACK3%"=="" goto :prime_end
call :pack_%PACK3% 2>nul || echo [HAL] Unknown pack: %PACK3%

:prime_end
echo.
echo ================================================================
echo === END HAL prime — paste above into any AI session ===
echo ================================================================
exit /b 0

:pack_papers
echo.
echo --- PACK: papers - U paper source files ---
powershell -NoProfile -Command ^
  "Get-ChildItem '%ITI%\U\paper\soma' -Recurse -Filter '*.md' -Depth 2 | Where-Object { -not $_.PSIsContainer } | Sort-Object FullName | ForEach-Object { Write-Output ('### FILE: ' + $_.FullName + ' ###'); Get-Content $_.FullName }"
exit /b 0

:pack_lean
echo.
echo --- PACK: lean - U/paper/proofs Lean 4 source files ---
powershell -NoProfile -Command ^
  "Get-ChildItem '%ITI%\U\paper\proofs\*.lean' -Recurse | Sort-Object FullName | ForEach-Object { Write-Output ('### FILE: ' + $_.FullName + ' ###'); Get-Content $_.FullName }"
exit /b 0

:pack_process
echo.
echo --- PACK: process - U/PROCESS.md ---
if exist "%ITI%\U\PROCESS.md" (
  type "%ITI%\U\PROCESS.md"
) else (
  echo [HAL] WARNING: PROCESS.md not found
)
exit /b 0

:pack_issues
echo.
echo --- PACK: issues - open GitHub issues ---
where gh >nul 2>nul || (echo [HAL] WARNING: gh CLI not found & exit /b 0)
echo === ITI-Theory/T.Ops ===
gh issue list --repo ITI-Theory/T.Ops --state open --limit 50 2>nul || echo [no issues]
echo === ITI-Theory/U ===
gh issue list --repo ITI-Theory/U --state open --limit 50 2>nul || echo [no issues]
echo === ITI-Theory/U.Ops ===
gh issue list --repo ITI-Theory/U.Ops --state open --limit 50 2>nul || echo [no issues]
exit /b 0

:init
echo [HAL] init — adding T.Dot\bin to user PATH
setx PATH "%PATH%;%TDOT_ROOT%\bin" >nul 2>&1 && (
  echo [HAL] init complete — restart your shell for PATH to take effect
) || (
  echo [HAL] init: could not set PATH via setx. Add manually: %TDOT_ROOT%\bin
)
exit /b 0

:sync
echo ================================================================
echo === HAL sync
echo ================================================================
for %%R in (T T.Ops T.Dot) do (
  echo === %%R ===
  git -C "%ITI%\%%R" pull --ff-only && echo [ok] || echo [WARNING: pull failed - run: git -C %ITI%\%%R pull]
)
for %%R in (U U.Dot U.Ops) do (
  if exist "%ITI%\%%R\.git" (
    echo === %%R ===
    git -C "%ITI%\%%R" pull --ff-only && echo [ok] || echo [WARNING: pull failed - run: git -C %ITI%\%%R pull]
  )
)
if exist "%ME_REPO%\.git" (
  echo === Me ===
  git -C "%ME_REPO%" pull --ff-only && echo [ok] || echo [WARNING: pull failed]
)
exit /b 0

:help
echo HAL Level Zero
echo.
echo Usage:
echo   HAL prime [pack ...]  Output AI context block (pipe: HAL prime ^| clip)
echo                         Packs: papers  lean  process  issues
echo                         Combine: HAL prime papers lean
echo   HAL sync              Pull --ff-only on all known repos
echo   HAL init              Add T.Dot\bin to user PATH
echo   HAL help              Show this help
exit /b 0
