@echo off

call setPath.bat

:处理assets部分========================================
set revision_from=0

for /f "delims=" %%i in (%WORKBASE%lastAssetsRevision.txt) do (
	set revision_from=%%i
)

echo 上一次assets更新的版本是 %revision_from%

:对版本进行比较，生成有修改的文件列表
cd /d %working_dir%assets\
svn update
svn status --verbose > %working_dir%tools\version.txt

:获取当前目录的最高版本

svn info --xml>%WORKBASE%info.xml

for /f "tokens=* delims=:" %%j in ('findstr "revision=" %WORKBASE%info.xml') do (
	set g=0
	set g=%%j
)
set revision_to=%g:~13,-2%

if "%revision_from%"=="%revision_to%" (echo assets版本号一致，无需更新) else (
		
	svn diff --summarize -r %revision_from%:%revision_to% > %WORKBASE%a.txt
	
	::过滤出修改或者添加的文件列表（删除的不处理）
	findstr "^[MA].*\.[^f][^l][^a]$" %WORKBASE%a.txt> %WORKBASE%b.txt
	
	::局部变量要延迟处理的时候 变量的 %i% 要变成 !i! 
	setlocal EnableDelayedExpansion	
	for /f "tokens=2 delims= "  %%i in (%WORKBASE%b.txt) do (
		set k=%%i
		set "k=!k:%ReplacePath%=!"
		echo %product_dir%!k!
		for /f  %%a in ("%product_dir%!k!") do (
			:如果目录目录不存在，生成目录
			if not exist %%~dpa md %%~dpa
			:把文件拷到产品目录(判断不是目录才拷)
			cd /d %WORKBASE%
			(2>nul cd %working_dir%!k!) || (copy %working_dir%!k! %%~dpa)
		)
	)
	endlocal
	cd /d %WORKBASE%
	echo %revision_to%> %WORKBASE%lastAssetsRevision.txt
	del %WORKBASE%a.txt
	del %WORKBASE%b.txt
)
::处理otherRes部分========================================
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


cd /d %WORKBASE%



cd /d %working_dir%data
del data
del assets.vas
svn update

cd /d C:\Program Files\versionBuilder\
versionBuilder.exe  %working_dir%data  %working_dir%tools\version.txt assets/
copy %working_dir%data\data %product_dir%data\
cd /d %WORKBASE%