@echo off

::call setPath.bat

::����assets����========================================

cd /d %WORKBASE%
for /f "delims=" %%i in (%WORKBASE%lastAssetsRevision.txt) do (
	set revision_from=%%i
)

echo ��һ��assets���µİ汾�� %revision_from%

:�԰汾���бȽϣ��������޸ĵ��ļ��б�
cd /d %working_dir%assets\
svn update
svn status --verbose > %working_dir%tools\version.txt

:��ȡ��ǰĿ¼����߰汾

svn info --xml>%WORKBASE%info.xml

for /f "tokens=* delims=:" %%j in ('findstr "revision=" %WORKBASE%info.xml') do (
	set g=0
	set g=%%j
)
set revision_to=%g:~13,-2%

if "%revision_from%"=="%revision_to%" (echo assets�汾��һ�£��������) else (
		
	svn diff --summarize -r %revision_from%:%revision_to% > %WORKBASE%a.txt

	::�ֲ�����Ҫ�ӳٴ����ʱ�� ������ %i% Ҫ��� !i! 
	setlocal EnableDelayedExpansion	
	::���˳��޸Ļ�����ӵ��ļ��б�ɾ���Ĳ�����
	findstr "^[MA].*\.[^f][^l][^a]$" %WORKBASE%a.txt> %WORKBASE%b.txt
	
	for /f "tokens=2 delims= "  %%i in (%WORKBASE%b.txt) do (
		set k=%%i
		set "k=!k:%ReplacePath%=!"
		echo %product_dir%!k!
		for /f  %%a in ("%product_dir%!k!") do (
			:���Ŀ¼Ŀ¼�����ڣ�����Ŀ¼
			if not exist %%~dpa md %%~dpa
			:���ļ�������ƷĿ¼(�жϲ���Ŀ¼�ſ�)
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