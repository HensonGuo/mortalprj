echo ========Set Path=========
@echo off

::编译的模块目录
set ASFile_PATH=../mortalGame/src/

::总目录
set Web_Path=D:\xampp\htdocs\product\f2_flash\frmmo

::生成库连接XML(用于优化模块)
set Report=%Web_Path%\report

::输出SWF目录
set OutPut=%Web_Path%

::配置文件路径
set LoadConfig=flex_config_release.xml

::=================================================

::网站源目录
set working_dir=D:\xampp\htdocs\frmmo\
::发布目录
set product_dir=%Web_Path%\
set WORKBASE=%cd%\
::多余的路径 需要替换掉
set ReplacePath=flash\frmmo\