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
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs
call "%associed_language_script%" "display_title"
:define_filename
set filename=
call "%associed_language_script%" "filename_choice"
IF "%filename%"=="" (
	call "%associed_language_script%" "filename_empty_error"
	goto:define_filename
) else (
	set filename=%filename:"=%
)
call tools\Storage\functions\strlen.bat nb "%filename%"
set i=0
:check_chars_filename
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\) do (
		IF "!filename:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "filename_char_error"
			goto:define_filename
		)
	)
	set /a i+=1
	goto:check_chars_filename
)
call "%associed_language_script%" "output_folder_choice"
set /p filepath=<templogs\tempvar.txt
IF NOT "%filepath%"=="" set filepath=%filepath%\
IF NOT "%filepath%"=="" set filepath=%filepath:\\=\%
echo.
call "%associed_language_script%" "save_begin"
IF NOT EXIST KEY_SAVES mkdir KEY_SAVES
IF EXIST "%project_name%.bat.lng" copy /v "%project_name%.bat.lng" "KEY_SAVES\%project_name%.bat.lng" >nul 2>&1
IF EXIST "%project_name%.bat.theme" copy /v "%project_name%.bat.theme" "KEY_SAVES\%project_name%.bat.theme" >nul 2>&1
IF NOT EXIST KEY_SAVES\languages mkdir KEY_SAVES\languages
cd languages
for /d %%p in ("*") do (
	IF EXIST "%%p\script_general_config.bat" (
		IF NOT EXIST "..\KEY_SAVES\languages\%%p" mkdir "..\KEY_SAVES\languages\%%p"
		copy /v "%%p\script_general_config.bat" "..\KEY_SAVES\languages\%%p\script_general_config.bat" >nul 2>&1
	)
)
cd ..
IF NOT EXIST KEY_SAVES\tools mkdir KEY_SAVES\tools
IF NOT EXIST "KEY_SAVES\tools\profiles" mkdir "KEY_SAVES\tools\profiles"
IF NOT EXIST "KEY_SAVES\tools\profiles\ftp" mkdir "KEY_SAVES\tools\profiles\ftp"
copy /V "tools\profiles\ftp\*.bat" "KEY_SAVES\tools\profiles\ftp\" >nul 2>&1
IF NOT EXIST "KEY_SAVES\tools\profiles\github" mkdir "KEY_SAVES\tools\profiles\github"
copy /V "tools\profiles\github\*.bat" "KEY_SAVES\tools\profiles\github\" >nul 2>&1
cd KEY_SAVES
IF NOT "%filepath%"=="" (
	..\tools\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "%filepath%%filename%".ushs  -r >nul 2>&1
	IF !errorlevel! NEQ 0 (
		del /q "%filepath%%filename%.ushs" >nul
		call "%associed_language_script%" "save_create_error"
		cd ..
		goto:end_script
	)
) else (
	..\tools\7zip\7za.exe a -y -tzip -sdel -sccUTF-8 "..\%filename%".ushs  -r >nul 2>&1
	IF !errorlevel! NEQ 0 (
		del /q "..\%filename%.ushs" >nul
		call "%associed_language_script%" "save_create_error"
		cd ..
		goto:end_script
	)
)
cd ..
call "%associed_language_script%" "save_end"
:end_script
rmdir /s /q KEY_SAVES
rmdir /s /q templogs
pause 
endlocal