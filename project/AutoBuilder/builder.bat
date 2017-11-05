@echo off

echo [%Time%] ±‡“ÎPreloader
"C:\Program Files\Adobe\Adobe Flash Builder 4\sdks\4.1.0\bin\mxmlc" %ASFile_PATH%Preloader.as -output %OutPut%/Preloader.swf -load-config %LoadConfig% -link-report=%Report%\Preloader.xml
echo [%Time%] Preloader.swf   [OK]

echo [%Time%] ±‡“ÎMainGame
"C:\Program Files\Adobe\Adobe Flash Builder 4\sdks\4.1.0\bin\mxmlc" %ASFile_PATH%MainGame.as -output %OutPut%/MainGame.swf  -load-config %LoadConfig% -link-report=%Report%\MainGame.xml
echo [%Time%] MainGame.swf   [OK]

echo [%Time%] ±‡“ÎModuleRegister
"C:\Program Files\Adobe\Adobe Flash Builder 4\sdks\4.1.0\bin\mxmlc" %ASFile_PATH%modules/register/ModuleRegister.as -output %OutPut%/modules/register/ModuleRegister.swf  -load-config %LoadConfig% -load-externs=%Report%\MainGame.xml
echo [%Time%] ModuleRegister.swf   [OK]
