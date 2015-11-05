@echo off
mkdir %1
copy %~dp0\Patches\JumpStart.txt %1 || (
    echo Failed to copy JumpStart.txt 
    exit /b 1
    )
copy %~dp0\INSTALL.txt %1 || (
    echo Failed to copy INSTALL.txt 
    exit /b 1
    )
copy %~dp0\README.txt %1 || (
    echo Failed to copy README.txt
    exit /b 1
    )
copy %~dp0\CHANGELOG.txt %1 || (
    echo Failed to copy CHANGELOG.txt
    exit /b 1
    )
copy D:\UDK\UDKGame\CookedPC\JumpStart.u %1 || (
    echo Failed to copy JumpStart.u
    exit /b 1
    )
copy %~dp0\DefaultJumpStart.ini %1 || (
    echo Failed to copy DefaultJumpStart.ini
    exit /b 1
    )

echo "I hope you remembered to cook the package!"
