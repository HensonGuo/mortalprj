@echo off
::call setPath.bat

cd /d %working_dir%data
::del data
::del assets.vas
::svn update

::cd /d C:\Program Files\versionBuilder\
::versionBuilder.exe  %working_dir%data  %working_dir%tools\version.txt assets/
copy %working_dir%data\data %product_dir%data\
