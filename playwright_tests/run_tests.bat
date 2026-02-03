@echo off
REM Quick Start Script for Playwright Login Tests (Windows)
REM =========================================================

echo ==========================================
echo Playwright Login Test Suite - Quick Start
echo ==========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH
    pause
    exit /b 1
)

echo Python found:
python --version
echo.

REM Check if virtual environment exists
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    echo Virtual environment created
    echo.
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat
echo Virtual environment activated
echo.

REM Install dependencies
echo Installing dependencies...
pip install --quiet --upgrade pip
pip install --quiet -r requirements.txt
echo Dependencies installed
echo.

REM Install Playwright browsers
echo Installing Playwright browsers...
playwright install chromium
echo Playwright browsers installed
echo.

REM Check if application is running
echo Checking if application is running at http://localhost:8080...
curl -s --head --request GET http://localhost:8080 | findstr /C:"200 OK" /C:"302 Found" >nul
if %errorlevel% equ 0 (
    echo Application is running
    echo.
) else (
    echo Warning: Application may not be running at http://localhost:8080
    echo   Please start your application before running the tests
    echo.
    pause
)

REM Ask which test to run
echo Which test would you like to run?
echo 1) Standalone Login Test (login_test.py)
echo 2) Pytest Login Test (test_login_pytest.py)
echo 3) Both tests
echo 4) Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto run_standalone
if "%choice%"=="2" goto run_pytest
if "%choice%"=="3" goto run_both
if "%choice%"=="4" goto exit_script
goto invalid_choice

:run_standalone
echo.
echo Running standalone login test...
echo ==========================================
python login_test.py
goto completion

:run_pytest
echo.
echo Running pytest login test...
echo ==========================================
pytest test_login_pytest.py -v
goto completion

:run_both
echo.
echo Running standalone login test...
echo ==========================================
python login_test.py
echo.
echo Running pytest login test...
echo ==========================================
pytest test_login_pytest.py -v
goto completion

:invalid_choice
echo.
echo Invalid choice. Exiting...
pause
exit /b 1

:completion
echo.
echo ==========================================
echo Test execution completed!
echo ==========================================
echo.
echo Check test_results.log for detailed output
echo Screenshots are saved in the current directory
echo.
pause

:exit_script
echo Exiting...
exit /b 0
