#!/bin/bash
# Quick Start Script for Playwright Login Tests
# ===============================================

set -e

echo "=========================================="
echo "Playwright Login Test Suite - Quick Start"
echo "=========================================="
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed or not in PATH"
    exit 1
fi

echo "✓ Python 3 found: $(python3 --version)"
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "✓ Virtual environment created"
    echo ""
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo "✓ Virtual environment activated"
echo ""

# Install dependencies
echo "Installing dependencies..."
pip install -q --upgrade pip
pip install -q -r requirements.txt
echo "✓ Dependencies installed"
echo ""

# Install Playwright browsers
echo "Installing Playwright browsers..."
playwright install chromium --quiet
echo "✓ Playwright browsers installed"
echo ""

# Check if application is running
echo "Checking if application is running at http://localhost:8080..."
if curl -s --head --request GET http://localhost:8080 | grep "200 OK\|302 Found" > /dev/null; then
    echo "✓ Application is running"
    echo ""
else
    echo "⚠ Warning: Application may not be running at http://localhost:8080"
    echo "  Please start your application before running the tests"
    echo ""
    read -p "Press Enter to continue anyway, or Ctrl+C to exit..."
    echo ""
fi

# Ask which test to run
echo "Which test would you like to run?"
echo "1) Standalone Login Test (login_test.py)"
echo "2) Pytest Login Test (test_login_pytest.py)"
echo "3) Both tests"
echo "4) Exit"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "Running standalone login test..."
        echo "=========================================="
        python login_test.py
        ;;
    2)
        echo ""
        echo "Running pytest login test..."
        echo "=========================================="
        pytest test_login_pytest.py -v
        ;;
    3)
        echo ""
        echo "Running standalone login test..."
        echo "=========================================="
        python login_test.py
        echo ""
        echo "Running pytest login test..."
        echo "=========================================="
        pytest test_login_pytest.py -v
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "Test execution completed!"
echo "=========================================="
echo ""
echo "Check test_results.log for detailed output"
echo "Screenshots are saved in the current directory"
echo ""

# Deactivate virtual environment
deactivate
