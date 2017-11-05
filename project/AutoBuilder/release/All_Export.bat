@echo off
call setPath.bat

cd /d %WORKBASE%
call Assets_Export.bat

cd /d %WORKBASE%
call Map_Export.bat

cd /d %WORKBASE%
call Data_Export.bat

pause