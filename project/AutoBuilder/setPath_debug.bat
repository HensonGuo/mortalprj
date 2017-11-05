echo ========Set Path=========
@echo off


::编译的模块目录
set ASFile_PATH=../mortalGame/src/

::总目录
set Web_Path=%FRMMO%

::生成库连接XML(用于优化模块)
set Report=%Web_Path%\release\report

::输出SWF目录
set OutPut=%Web_Path%

::配置文件路径
set LoadConfig=flex_config_debug.xml