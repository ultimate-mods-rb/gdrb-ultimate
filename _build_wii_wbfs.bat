"%~dp0dependencies/wit/wit" extract "%~dp0\iso" "%~dp0\_build\wii"
del "%~dp0\_build\wii\sys\main.dol"
del "%~dp0\_build\wii\setup.txt"
copy "%~dp0\dependencies\patch\main.dol" "%~dp0\_build\wii\sys"
copy "%~dp0\dependencies\patch\setup.txt" "%~dp0\_build\wii"

copy "%~dp0\_build\wii_rebuild_files\main_wii.hdr" "%~dp0\_build\wii\files\gen"
del  "%~dp0\_build\wii\files\gen\main_wii_10.ark"
"%~dp0dependencies/arkhelper" patchcreator -a "%~dp0\_ark" -o "%~dp0\_build\wii\files\gen" "%~dp0\_build\wii\files\gen\main_wii.hdr"
move "%~dp0\_build\wii\files\gen\gen\main_wii.hdr" "%~dp0\_build\wii\files\gen"
move "%~dp0\_build\wii\files\gen\gen\main_wii_10.ark" "%~dp0\_build\wii\files\gen"
rmdir "%~dp0\_build\wii\files\gen\gen"

del "%~dp0\iso\GDRB Ultimate.wbfs"
"%~dp0dependencies/wit/wit" copy "%~dp0\_build\wii" "%~dp0\iso\GDRB Ultimate.wbfs"

GDRB ultimate should've successfully built. copy the wbfs to your console to play. enjoy :)

pause