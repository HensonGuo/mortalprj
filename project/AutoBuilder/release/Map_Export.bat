@echo off

::call setPath.bat

::����otherRes����========================================

cd /d %WORKBASE%
set revision_from=0
for /f "delims=" %%i in (%WORKBASE%lastOtherResRevision.txt) do (
	set revision_from=%%i
)
echo ��һ��otherRes���µİ汾�� %revision_from%

cd /d %working_dir%otherRes\
svn update
:��ȡ��ǰĿ¼����߰汾
svn info --xml>%WORKBASE%info.xml

for /f "tokens=* delims=:" %%j in ('findstr "revision=" %WORKBASE%info.xml') do (
	set g=%%j
) 
set revision_to=%g:~13,-2%

if "%revision_from%"=="%revision_to%" (echo otherRes�汾��һ�£��������) else (
	svn diff --summarize -r %revision_from%:%revision_to% > %WORKBASE%c.txt
	setlocal EnableDelayedExpansion
	findstr "^[MA]" %WORKBASE%c.txt>%WORKBASE%d.txt
	endlocal

	setlocal EnableDelayedExpansion
	for /f "tokens=2 delims= "  %%i in (%WORKBASE%d.txt) do (
		echo %%i
		set k=%%i
		set "k=!k:%ReplacePath%=!"
		for /f  %%a in ("%product_dir%!k!") do (
			:���Ŀ¼Ŀ¼�����ڣ�����Ŀ¼
			if not exist %%~dpa md %%~dpa
			:���ļ�������ƷĿ¼(�жϲ���Ŀ¼�ſ�)
			cd /d %WORKBASE%
			(2>nul cd %working_dir%!k!) || copy %working_dir%!k! %%~dpa

		)	
	)
	endlocal
	echo %revision_to%> %WORKBASE%lastOtherResRevision.txt
	cd /d %WORKBASE%
	del %WORKBASE%c.txt
	del %WORKBASE%d.txt
)
::pause