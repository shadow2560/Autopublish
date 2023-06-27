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
:define_action_choice
call "%associed_language_script%" "display_title"
set action_choice=
cls
call "%associed_language_script%" "display_menu"
IF "%action_choice%"=="1" goto:save_config
IF "%action_choice%"=="2" goto:restaure_config
IF "%action_choice%"=="3" goto:restaure_default
IF "%action_choice%"=="4" goto:default_auto_update
goto:end_script
:save_config
set action_choice=
echo.
cls
call TOOLS\Storage\save_configs.bat
@echo off
goto:define_action_choice
:restaure_config
set action_choice=
echo.
cls
call TOOLS\Storage\restore_configs.bat
@echo off
goto:define_action_choice
:restaure_default
set action_choice=
echo.
cls
call TOOLS\Storage\restore_default.bat
@echo off
goto:define_action_choice
:default_auto_update
setlocal
echo.
IF NOT EXIST "templogs\*.*" mkdir templogs
tools\gnuwin32\bin\grep.exe -n "set auto_update=" <"%language_path%\script_general_config.bat" >templogs\tempvar.txt
set /p temp_auto_update_line=<templogs\tempvar.txt
IF NOT "%temp_auto_update_line%"=="" (
	echo %temp_auto_update_line%| "tools\gnuwin32\bin\cut.exe" -d : -f 1 >templogs\tempvar.txt
	set /p auto_update_file_param_line=<templogs\tempvar.txt
	echo %temp_auto_update_line%|"tools\gnuwin32\bin\cut.exe" -d = -f 2 >templogs\tempvar.txt
	set /p ini_auto_update=<templogs\tempvar.txt
)
"tools\gnuwin32\bin\sed.exe" %auto_update_file_param_line%d "%language_path%\script_general_config.bat">"%language_path%\script_general_config2.bat"
del /q "%language_path%\script_general_config.bat"
ren "%language_path%\script_general_config2.bat" "script_general_config.bat"
rmdir /s /q templogs
endlocal
call "%associed_language_script%" "auto_update_reset_success"
pause
goto:define_action_choice
:end_script
endlocal