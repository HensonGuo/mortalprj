@echo off

::call setPath.bat

::处理otherRes部分========================================

cd /d %WORKBASE%
set revision_from=0
for /f "delims=" %%i in (%WORKBASE%lastOtherResRevision.txt) do (
	set revision_from=%%i
)
echo 上一次otherRes更新的版本是 %revision_from%

cd /d %working_dir%otherRes\
svn update
:获取当前目录的最高版本
svn info --xml>%WORKBASE%info.xml

for /f "tokens=* delims=:" %%j in ('findstr "revision=" %WORKBASE%info.xml') do (
	set g=%%j
) 
set revision_to=%g:~13,-2%

if "%revision_from%"=="%revision_to%" (echo otherRes版本号一致，无需更新) else (
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
			:如果目录目录不存在，生成目录
			if not exist %%~dpa md %%~dpa
			:把文件拷到产品目录(判断不是目录才拷)
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