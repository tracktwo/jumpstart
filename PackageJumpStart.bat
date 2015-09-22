mkdir %1
copy %~dp0\Patches\JumpStart.txt %1
copy %~dp0\INSTALL.txt %1
copy %~dp0\README.txt %1
copy %~dp0\CHANGELOG.txt %1
copy D:\UDK_Sound\UDKGame\CookedPC\JumpStart.u %1
copy %~dp0\DefaultJumpStart.ini %1
echo "I hope you remembered to cook the package!"
