@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Always run from the repository folder where this file lives.
cd /d "%~dp0"

REM Optional commit message: deploy.bat "your message"
if "%~1"=="" (
  set "MSG=chore: update site %date% %time%"
) else (
  set "MSG=%*"
)

echo [1/4] Checking for local changes...
git status --porcelain > "%temp%\deploy_changes.txt"
for %%A in ("%temp%\deploy_changes.txt") do set SIZE=%%~zA
if "!SIZE!"=="0" (
  del "%temp%\deploy_changes.txt" >nul 2>&1
  echo No changes to deploy.
  goto :end
)
del "%temp%\deploy_changes.txt" >nul 2>&1

echo [2/4] Staging changes...
git add -A
if errorlevel 1 goto :fail

echo [3/4] Creating commit...
git commit -m "%MSG%"
if errorlevel 1 goto :fail

echo [4/4] Pushing to GitHub...
git push
if errorlevel 1 goto :fail

echo.
echo Deploy completed successfully.
goto :end

:fail
echo.
echo Deploy failed. Please review the error above.
exit /b 1

:end
endlocal
