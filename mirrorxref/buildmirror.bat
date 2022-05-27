echo off
title Running mirror.db build ...
pushd
setlocal

if exist c:\SmugMirror\Documents\XrefDb\use-j-beta.txt goto UseBeta00

if not exist C:\j64\j903\addons\data\sqlite\lib\libjsqlite3.dll goto Exception00
if exist c:\j64\j903\bin\jconsole.exe set jexe=c:\j64\j903\bin\jconsole -js 
goto RunScript00

:UseBeta00
echo using current Beta J 9.04
if not exist C:\j64\j904\addons\data\sqlite\lib\libjsqlite3.dll goto Exception00
if exist c:\j64\j904\bin\jconsole.exe set jexe=c:\j64\j904\bin\jconsole -js 
goto RunScript00

:RunScript00
if "%jexe%" == "" goto Exception01

rem set MirrorXref J script
set jscr="0!:0<'c:/SmugMirror/Documents/XrefDb/MirrorXref.ijs'"

rem backup and build mirror.db
%jexe% %jscr% "BuildMirror 1" "exit 0"

rem copy mirror.db to distribution directory
if not exist C:\SmugMirror\Documents\XrefDb\mirror.db goto Exception05
echo distributing mirror.db
copy /Y mirror.db c:\Users\baker\jupyter_notebooks\dbs

title mirror.db build complete!
goto TheEnd

:Exception00
echo ERROR: SQLite J addon binary not found
title mirror.db build abended!
goto TheEnd

:Exception01
echo ERROR: jconsole.exe not found
title mirror.db build abended!
goto TheEnd

:Exception05
echo ERROR: mirror.db not found
title mirror.db build abended!
goto TheEnd

:TheEnd
endlocal
popd
pause