::Script by Shadow256
call tools\storage\functions\ini_scripts.bat
Setlocal enabledelayedexpansion
set this_script_full_path=%~0
set associed_language_script=%language_path%\!this_script_full_path:%script_base_path%=!
set associed_language_script=%script_base_path%%associed_language_script%
IF NOT EXIST "%associed_language_script%" (
	set associed_language_script=languages\FR_fr\!this_script_full_path:%script_base_path%=!
	set associed_language_script=%script_base_path%!associed_language_script!
	echo The associated language file cannot be found, please run the updater to download it. French will be set as default.
	pause
)
IF NOT EXIST "%associed_language_script%" (
	echo Language error. Please use the update manager to update the script. This script will now close.
	pause
	endlocal
	goto:eof
)
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
call "%associed_language_script%" "display_title"
cd languages
for /d %%p in ("*") do (
	IF EXIST "%%p\script_general_config.bat" (
	del /q "%%p\script_general_config.bat" >nul 2>&1
)
cd ..
IF EXIST templogs\*.* rmdir /s /q templogs
IF EXIST "%project_name%.bat.lng" del /q "%project_name%.bat.lng"
IF EXIST "%project_name%.bat.theme" del /q "%project_name%.bat.theme"
IF EXIST "%project_name%.log" del /q "%project_name%.log"
IF EXIST "tools\profiles\*.*" rmmdir /s /q "tools\profiles"
call "%associed_language_script%" "success"
pause
endlocal