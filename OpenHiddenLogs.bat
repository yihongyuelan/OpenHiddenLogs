@echo off
echo ============= Open Hidden Logs =============
echo =============   version 0.2  =============
echo =============     20150605   =============
echo =============      SEVEN     =============

REM Update:
REM 1. Rename the script to OpenHiddenLogs.bat.
REM 2. Adaptation of user mode device.
REM 3. Add the instructions and steps.

REM Instructions:
REM This script is used to enable some hide logs in Android Platforms.
REM Android property system provides an approach to enable isLoggable(String tag, int level).
REM You'll find some code in Android as below:
REM private static final String TAG = "Telecom";
REM public static final boolean DEBUG = android.util.Log.isLoggable(TAG, android.util.Log.DEBUG);
REM if (DEBUG) {
REM    android.util.Log.d(TAG, getPrefix(obj) + str1 + str2);
REM }
REM If you want to enable the Log.d(), you need to type "adb shell setprop log.tag.Telecom V"
REM in your console, and kill the process of com.android.server.telecom, then Log.d() is enabled.
REM But if you reboot your device, the Log.d() is disabled, so we write the TAG to property system
REM to enable Log.d() forever. If you have any questions, please feel free to let me know.
REM Email: yihongyuelan@gmail.com

REM Steps:
REM 1. Get your device root permission.
REM 2. Running the OpenHideLogs.bat;


echo.
set NOROOTSTR=adbd cannot run as root
set ROOTSTR=adbd is already running as root
set BUILDTYPE=user

for /f "delims=" %%a in ('adb shell getprop ro.build.type') do set "build_type=%%a"
echo Your device is %build_type% Mode
echo.

:ISENABLED
for /f "delims=" %%c in ('adb shell getprop log.tag.InCall') do set "check=%%c"
if "%check%" == "V" (
	echo Hidden Logs has been enabled!
	pause
	exit
) else (
	echo Hidden Logs hasn't been enabled! 
)

echo.
for /f "delims=" %%b in ('adb root') do set "str=%%b"
REM echo %str%
set EXISTS_FLAG=false
echo %str%|find "%ROOTSTR%">nul&&set EXISTS_FLAG=true
if "%EXISTS_FLAG%"=="true" (
	echo Checking ROOT permission PASS
	ping -n 5 127.0.0.1 >nul
	adb remount
	if "%build_type%" == "%BUILDTYPE%" (
		adb shell "echo log.tag.InCall=V 					>> /system/build.prop"
		adb shell "echo log.tag.Telephony=V 				>> /system/build.prop"
		adb shell "echo log.tag.Telecom=V 					>> /system/build.prop"
		adb shell "echo log.tag.TelecomFramework=V 			>> /system/build.prop"
		adb shell "echo log.tag.Mms=V 						>> /system/build.prop"
		adb shell "echo log.tag.MessageTemplateProvider=V 	>> /system/build.prop"
		adb shell "echo log.tag.CarrierText=V			 	>> /system/build.prop"
	) else (
		adb push local.prop /data/
		adb shell chmod 644 /data/local.prop
		adb shell chown system:system /data/local.prop
	)
	adb reboot
	adb wait-for-device
	goto :ISENABLED
) else (
	echo Checking ROOT permission FAIL
	echo Please get the root privileges for adbd and try again
	pause
	exit
)


