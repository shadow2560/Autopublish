::Script by Shadow256
IF EXIST "tools\storage\functions\ini_scripts.bat" (
	call tools\storage\functions\ini_scripts.bat
) else (
	@echo off
	chcp 65001 >nul
)
IF EXIST "%~0.version" (
	set /p this_script_version=<"%~0.version"
) else (
	set this_script_version=1.00.00
)
Setlocal enabledelayedexpansion
set base_script_path="%~dp0\..\.."
::set folders_url_project_base=https://github.com/shadow2560/Autopublish/trunk
::set files_url_project_base=https://raw.githubusercontent.com/shadow2560/Autopublish/master
set folders_url_project_base=ftp://158.178.198.95/Autopublish/
set files_url_project_base=ftp://158.178.198.95/Autopublish
set what_to_update=%~1
IF NOT EXIST "tools\gnuwin32\bin\wget.exe" (
	"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
	IF !errorlevel! NEQ 0 (
		echo Dependancy error, you have to connect to internet, script will close.
		pause
		exit
	) else (
		echo %~1>"continue_update.txt"
		echo Updating Gnuwin32 dependancies...
		mkdir tools\Gnuwin32\bin >nul 2>&1
		"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "tools\Gnuwin32\bin" -o "wget.exe" "%files_url_project_base%/tools\Gnuwin32\bin\wget.exe"
	)
)
IF NOT EXIST "tools\aria2\aria2c.exe" (
	"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
	IF !errorlevel! NEQ 0 (
		echo Dependancy error, you have to connect to internet, script will close.
		pause
		exit
	) else (
		echo %~1>"continue_update.txt"
		echo Updating Aria2 dependancies...
		"tools\gnuwin32\bin\wget.exe" -q -np -nH -r --level=0 --cut-dirs=1 -t 3 --user="anonymous" --password="" -P "." %folders_url_project_base%/tools/aria2
	)
)
IF NOT EXIST "tools\gnuwin32\bin\wc.exe" (
	"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
	IF !errorlevel! NEQ 0 (
		echo Dependancy error, you have to connect to internet, script will close.
		pause
		exit
	) else (
		echo %~1>"continue_update.txt"
		echo Updating Gnuwin32 dependancies...
		"tools\gnuwin32\bin\wget.exe" -q -np -nH -r --level=0 --cut-dirs=1 -t 3 --user="anonymous" --password="" -P "templogs" %folders_url_project_base%/tools/gnuwin32
		move templogs\gnuwin32 tools >nul 2>&1
	)
)
IF NOT EXIST "languages\FR_fr" (
	echo %~1>"continue_update.txt"
	echo Initializing french language...
	set temp_language_path=languages\FR_fr
	call :initialize_language
)
IF "%temp_language_path%"=="" (
	IF EXIST "languages\FR_fr\language_general_config.bat" call "languages\FR_fr\language_general_config.bat"
	IF "!language_path!"=="" (
		echo %~1>"continue_update.txt"
		echo Initializing first language...
		set temp_language_path=languages\FR_fr
		rmdir /s /q "templogs" 2>nul
		call :initialize_language
	)
)
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
IF "%~2"=="language_init" (
	rmdir /s /q "templogs" 2>nul
	call :initialize_language
)
echo é >nul
set this_script_full_path=%~0
IF "%script_base_path%"=="" (
	cd >templogs\tempvar.txt
	set /p script_base_path=<templogs\tempvar.txt
	set script_base_path=!script_base_path!\
)
set associed_language_script=%language_path%\!this_script_full_path:%script_base_path%=!
set associed_language_script=%script_base_path%%associed_language_script%
IF NOT EXIST "%associed_language_script%" (
	set associed_language_script=languages\FR_fr\!this_script_full_path:%script_base_path%=!
	set associed_language_script=%script_base_path%!associed_language_script!
	echo The associated language file cannot be found, please run the updater to download it. French will be set as default.
	pause
)
IF NOT EXIST "%associed_language_script%" (
	echo Language error, please use the update manager to update the script. The script will force the initialization of the language.
	pause
rmdir /s /q "templogs" 2>nul
		call :initialize_language
)
call "%associed_language_script%" "display_title"
IF "%lng_yes_choice%"=="" (
	IF "%language_custom%"=="0" (
		"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
		IF !errorlevel! EQU 0 (
			call :verif_file_version "%language_path%\language_general_config.bat"
			IF "!update_finded!"=="Y" (
				::echo %~1>"continue_update.txt"
				"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "language_general_config.bat" "%files_url_project_base%/%language_path:\=/%/language_general_config.bat"
				IF !errorlevel! EQU 0 (
					move "templogs\language_general_config.bat" "%language_path%\language_general_config.bat" >nul
					"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "language_general_config.bat.version" "%files_url_project_base%/%language_path:\=/%/language_general_config.bat.version"
					IF !errorlevel! EQU 0 (
						move "templogs\language_general_config.bat.version" "%language_path%\language_general_config.bat.version" >nul
						rmdir /s /q templogs
						call "%associed_language_script%" "language_config_update_info"
						pause
						start /i "" "%windir%\system32\cmd.exe" /c call "%project_name%.bat"
						IF /i "%language_echo%"=="on" pause
						exit
					)
				)
			)
		) else (
			call "%associed_language_script%" "no_internet_connection_error"
			pause
			goto:end_script
		)
	)
)
IF EXIST "continue_update.txt" (
	set auto_update=O
	set /p what_to_update=<continue_update.txt
	goto:begin_update
)
IF  "%~2"=="force" (
	set auto_update=O
	goto:begin_update
)
IF EXIST "failed_updates\*.failed" (
	set auto_update=O
	set failed_updates_finded=Y
	goto:begin_update
)
:verif_auto_update_ini
IF EXIST "%language_path%\script_general_config.bat\*.*" (
	rmdir /s /q "%language_path%\script_general_config.bat"
)
IF not EXIST "%language_path%\script_general_config.bat" copy nul "%language_path%\script_general_config.bat" >nul
tools\gnuwin32\bin\grep.exe -n "set auto_update=" <"%language_path%\script_general_config.bat" >templogs\tempvar.txt
set /p temp_auto_update_line=<templogs\tempvar.txt
IF NOT "%temp_auto_update_line%"=="" (
	echo %temp_auto_update_line%|"tools\gnuwin32\bin\cut.exe" -d : -f 1 >templogs\tempvar.txt
	set /p auto_update_file_param_line=<templogs\tempvar.txt
	echo %temp_auto_update_line%|"tools\gnuwin32\bin\cut.exe" -d = -f 2 >templogs\tempvar.txt
	set /p ini_auto_update=<templogs\tempvar.txt
)
set temp_auto_update_line=
:initialize_auto_update
IF "%ini_auto_update%"=="" (
	call "%associed_language_script%" "autoupdate_choice"
) else IF /i "%ini_auto_update%"=="O" (
	set auto_update=O
) else IF /i "%ini_auto_update%"=="N" (
	set auto_update=N
) else (
	call "%associed_language_script%" "autoupdate_bad_value_error"
	"tools\gnuwin32\bin\sed.exe" %auto_update_file_param_line%d "%language_path%\script_general_config.bat">"%language_path%\script_general_config2.bat"
	del /q "%language_path%\script_general_config.bat"
	ren "%language_path%\script_general_config2.bat" "script_general_config.bat"
	set ini_auto_update=
	goto:initialize_auto_update
)
IF NOT "%auto_update%"=="" (
	set auto_update=%auto_update:~0,1%
) else (
	call "%associed_language_script%" "autoupdate_empty_value_error"
	goto:initialize_auto_update
)
call :o/n/t/j_choice "auto_update"
IF /i "%auto_update%"=="J" (
	IF NOT "%auto_update_file_param_line%"=="" (
		"tools\gnuwin32\bin\sed.exe" '%auto_update_file_param_line% d' "%language_path%\script_general_config.bat">"%language_path%\script_general_config2.bat"
		del /q "%language_path%\script_general_config.bat"
		ren "%language_path%\script_general_config2.bat" "script_general_config.bat"
	)
	echo set auto_update=N>>"%language_path%\script_general_config.bat"
	set auto_update=N
)
IF /i "%auto_update%"=="T" (
	IF NOT "%auto_update_file_param_line%"=="" (
		"tools\gnuwin32\bin\sed.exe" '%auto_update_file_param_line% d' "%language_path%\script_general_config.bat">"%language_path%\script_general_config2.bat"
		del /q "%language_path%\script_general_config.bat"
		ren "%language_path%\script_general_config2.bat" "script_general_config.bat"
	)
	echo set auto_update=O>>"%language_path%\script_general_config.bat"
	set auto_update=O
)
IF /i "%auto_update%"=="N" (
	goto:end_script
) else IF /i "%auto_update%"=="O" (
	goto:begin_update
) else (
	call "%associed_language_script%" "autoupdate_choice_not_permited_error"
	goto:initialize_auto_update
)
:begin_update
echo :::::::::::::::::::::::::::::::::::::
echo ::%project_author% %project_name% %version% updater::
echo.
IF EXIST "failed_updates\*.failed" (
	set failed_updates_finded=Y
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates" 2>nul
)
mkdir "failed_updates" >nul 2>&1
set error_level=0
:new_script_install
IF "%what_to_update%"=="update_all" goto:skip_new_script_install
IF "%what_to_update%"=="general_content_update" goto:skip_new_script_install
IF "%~2"=="force" (
	IF NOT "%verified_internet_connexion%"=="Y" (
		"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
		set error_level=!errorlevel!
	) else (
		set error_level=0
	)
	IF !error_level! NEQ 0 (
		call "%associed_language_script%" "no_internet_connection_error"
		call "%associed_language_script%" "no_internet_connection_for_new_installation_error"
		pause
		goto:end_script
	)
	set verified_internet_connexion=Y
	set new_install_choice=
	call "%associed_language_script%" "new_installation_choice"
	IF NOT "!new_install_choice!"=="" set new_install_choice=!new_install_choice:~0,1!
	call :o/n_choice "new_install_choice"
	IF /i NOT "!new_install_choice!"=="o" (
		IF EXIST templogs (
			rmdir /s /q templogs
		)
		IF NOT EXIST "failed_updates\*.failed" (
			rmdir /s /q failed_updates
		)
		exit
	)
	call :verif_file_version "tools\Storage\update_manager.bat"
	IF "!update_finded!"=="Y" (
		call :verif_file_version "tools\Storage\update_manager_updater.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
		call :verif_file_version "languages\FR_fr\tools\Storage\update_manager_updater.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
		IF NOT "%language_path%"=="languages\FR_fr" (
			IF "%language_custom%"=="0" (
				call :verif_file_version "%language_path%\tools\Storage\update_manager_updater.bat"
				IF "!update_finded!"=="Y" (
					call :update_file
				)
			)
		)
		call "%associed_language_script%" "update_manager_updater_update"
		pause
		call :update_manager_update_special_script
	)
)
:skip_new_script_install
IF NOT "%verified_internet_connexion%"=="Y" (
	"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
	set error_level=!errorlevel!
) else (
	set error_level=0
)
IF %error_level% NEQ 0 (
	call "%associed_language_script%" "no_internet_connection_error"
	IF /i "%new_install_choice%"=="o" (
		call "%associed_language_script%" "no_internet_connection_for_new_installation_error"
		pause
		IF EXIST templogs (
			rmdir /s /q templogs
		)
		IF NOT EXIST "failed_updates\*.failed" (
			rmdir /s /q failed_updates
		)
		exit
	)
	pause
	goto:end_script
)
set verified_internet_connexion=Y
:failed_updates_verification
IF NOT EXIST "failed_updates\*.failed" goto:skip_failed_updates_verification
IF EXIST "failed_updates\update_manager.bat.file.failed" (
	call :verif_file_version "tools\Storage\update_manager_updater.bat"
	IF "!update_finded!"=="Y" (
		call :update_file
	)
	call :verif_file_version "languages\FR_fr\tools\Storage\update_manager_updater.bat"
	IF "!update_finded!"=="Y" (
		call :update_file
	)
	IF NOT "%language_path%"=="languages\FR_fr" (
		IF "%language_custom%"=="0" (
			call :verif_file_version "%language_path%\tools\Storage\update_manager_updater.bat"
			IF "!update_finded!"=="Y" (
				call :update_file
			)
		)
	)
	call "%associed_language_script%" "update_manager_updater_update"
	pause
	call :update_manager_update_special_script
)
for %%f in (failed_updates\*.failed) do (
	call :update_failed_content "%%f"
)
:skip_failed_updates_verification
:start_verif_update
:update_manager_update
call :verif_file_version "tools\Storage\update_manager.bat"
IF "!update_finded!"=="Y" (
	call :verif_file_version "tools\Storage\update_manager_updater.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
	call :verif_file_version "languages\FR_fr\tools\Storage\update_manager_updater.bat"
	IF "!update_finded!"=="Y" (
		call :update_file
	)
	IF NOT "%language_path%"=="languages\FR_fr" (
		IF "%language_custom%"=="0" (
			call :verif_file_version "%language_path%\tools\Storage\update_manager_updater.bat"
			IF "!update_finded!"=="Y" (
				call :update_file
			)
		)
	)
	call "%associed_language_script%" "update_manager_updater_update"
	pause
	call :update_manager_update_special_script
)
IF "%what_to_update%"=="" (
		IF EXIST "continue_update.txt" del /q "continue_update.txt"
		goto:end_script
) else (
	echo %~1>"continue_update.txt"
	call "%associed_language_script%" "begin_update"
	call :verif_file_version "tools\version.txt"
	IF "!update_finded!"=="Y" (
		call :update_file
		IF "%version%"=="1.00.00" (
			set restart_needed=Y
			call "%associed_language_script%" "script_version_not_initialized_info"
		)
	)
	call :verif_file_version "tools\general_update_version.txt"
	IF "!update_finded!"=="Y" (
		set restart_needed=Y
		call :general_content_update
	) else (
		call :verif_file_version "%language_path%\tools\general_update_version.txt"
		IF "!update_finded!"=="Y" (
			set restart_needed=Y
			call :general_content_update
		)
	)
	IF "%language_custom%"=="0" (
		call :verif_folder_version "%language_path%\doc"
		IF "!update_finded!"=="Y" (
			call :update_folder
		)
		call :verif_file_version "%language_path%\language_general_config.bat"
		IF "!update_finded!"=="Y" (
			"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "language_general_config.bat" "%files_url_project_base%/%language_path:\=/%/language_general_config.bat"
			IF !errorlevel! EQU 0 (
				move "templogs\language_general_config.bat" "%language_path%\language_general_config.bat" >nul
				"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "language_general_config.bat.version" "%files_url_project_base%/%language_path:\=/%/language_general_config.bat.version"
				IF !errorlevel! EQU 0 (
					move "templogs\language_general_config.bat.version" "%language_path%\language_general_config.bat.version" >nul
					call "%associed_language_script%" "language_config_update_info"
					set restart_needed=Y
				)
			)
		)
	)
	IF "%what_to_update%"=="general_content_update" (
		IF EXIST "continue_update.txt" del /q "continue_update.txt"
		goto:clean_files
	)
	call :%what_to_update%
	IF EXIST "continue_update.txt" del /q "continue_update.txt"
)
:clean_files
call :del_old_or_unused_files
IF "%restart_needed%"=="Y" (
	call "%associed_language_script%" "end_update_restart_needed"
	pause
	rmdir /s /q templogs
	start /i "" "%windir%\system32\cmd.exe" /c call "%project_name%.bat"
	IF /i "%language_echo%"=="on" pause
	exit
) else (
	call "%associed_language_script%" "end_update"
	pause
)
goto:end_script

rem Specific scripts instructions must be added here

:update_all
call "%associed_language_script%" "update_all_begin"
call "%associed_language_script%" "languages_update_begin"
"tools\gnuwin32\bin\wget.exe" -q -np -nH -r --level=0 --cut-dirs=1 -t 3 --user="anonymous" --password="" -P "." %folders_url_project_base%/languages
call "%associed_language_script%" "languages_update_end"
call :update_ftp.bat
call :update_nvda_remote_control.bat
call "%associed_language_script%" "update_all_end"
exit /b

:update_starting_script
call :verif_file_version "%project_name%.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\%project_name%.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\%project_name%.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_about.bat
call :verif_file_version "tools\Storage\about.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\about.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\about.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_donate.bat
call :verif_file_version "tools\Storage\donate.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\donate.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\donate.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_language_selector.bat
call :verif_file_version "tools\Storage\language_selector.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\language_selector.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\language_selector.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_menu.bat
call :verif_file_version "tools\Storage\menu.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\menu.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\menu.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_ftp.bat
call :verif_file_version "tools\Storage\ftp.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\ftp.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\ftp.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
call :verif_folder_version "tools\winscp"
IF "!update_finded!"=="Y" (
	call :update_folder
)
exit /b

:update_nvda_remote_control.bat
call :verif_file_version "tools\Storage\nvda_remote_control.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\nvda_remote_control.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\nvda_remote_control.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
call :verif_folder_version "tools\nvda"
IF "!update_finded!"=="Y" (
	call :update_folder
)
exit /b

:update_projects_profiles_management.bat
call :verif_file_version "tools\Storage\projects_profiles_management.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\projects_profiles_management.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\projects_profiles_management.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_restore_configs.bat
call :verif_file_version "tools\Storage\restore_configs.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\restore_configs.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\restore_configs.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_restore_default.bat
call :verif_file_version "tools\Storage\restore_default.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\restore_default.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\restore_default.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_save_configs.bat
call :verif_file_version "tools\Storage\save_configs.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\save_configs.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\save_configs.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_settings_menu.bat
call :verif_file_version "tools\Storage\settings_menu.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\settings_menu.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\settings_menu.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:update_theme_selector.bat
call :verif_file_version "tools\Storage\theme_selector.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\Storage\theme_selector.bat"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\theme_selector.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
exit /b

:general_content_update
call "%associed_language_script%" "update_basic_elements_begin"
call :verif_file_version "languages\FR_fr\tools\Storage\update_manager.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
call :verif_file_version "languages\FR_fr\tools\Storage\update_manager_updater.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\Storage\update_manager.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
		call :verif_file_version "%language_path%\tools\Storage\update_manager_updater.bat"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
call :update_starting_script
call :update_about.bat
call :update_donate.bat
call :update_language_selector.bat
call :update_menu.bat
call :update_projects_profiles_management.bat
call :update_restore_configs.bat
call :update_restore_default.bat
call :update_save_configs.bat
call :update_settings_menu.bat
call :update_theme_selector.bat
call :verif_folder_version "tools\7zip"
IF "!update_finded!"=="Y" (
	call :update_folder
)
call :verif_folder_version "tools\aria2"
IF "!update_finded!"=="Y" (
	call :update_folder
)
call :verif_folder_version "tools\default_configs"
IF "!update_finded!"=="Y" (
	call :update_folder
)
call :verif_folder_version "tools\gh"
IF "!update_finded!"=="Y" (
	call :update_folder
)
call :verif_folder_version "tools\git_installer"
IF "!update_finded!"=="Y" (
	call :update_folder
)
call :verif_folder_version "tools\gnuwin32"
IF "!update_finded!"=="Y" (
	call :update_folder
)
call :verif_folder_version "tools\PortableGit"
IF "!update_finded!"=="Y" (
	call :update_folder
)
call :verif_folder_version "tools\Storage\functions"
IF "!update_finded!"=="Y" (
	call :update_folder
)
call :verif_file_version "tools\general_update_version.txt"
IF "!update_finded!"=="Y" (
	call :update_file
)
call :verif_file_version "languages\FR_fr\tools\general_update_version.txt"
IF "!update_finded!"=="Y" (
	call :update_file
)
IF NOT "%language_path%"=="languages\FR_fr" (
	IF "%language_custom%"=="0" (
		call :verif_file_version "%language_path%\tools\general_update_version.txt"
		IF "!update_finded!"=="Y" (
			call :update_file
		)
	)
)
call "%associed_language_script%" "update_basic_elements_end"
exit /b

rem End of specific scripts instructions

:verif_file_version
set temp_file_path=%~1
set temp_file_slash_path=%temp_file_path:\=/%
call :test_write_access file "%~dp1"
set script_version=0
IF "%temp_file_path%"=="tools\sd_switch\version.txt" (
	IF EXIST "%temp_file_path%" (
		set /p script_version=<"%temp_file_path%"
	) else (
		set script_version=0
	)
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "version.txt" "%files_url_project_base%/%temp_file_slash_path%"
) else IF "%temp_file_path%"=="tools\general_update_version.txt" (
	IF EXIST "%temp_file_path%" (
		set /p script_version=<"%temp_file_path%"
	) else (
		set script_version=0
	)
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "version.txt" "%files_url_project_base%/%temp_file_slash_path%"
) else IF "%temp_file_path%"=="languages\FR_fr\tools\general_update_version.txt" (
	IF EXIST "%temp_file_path%" (
		set /p script_version=<"%temp_file_path%"
	) else (
		set script_version=0
	)
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "version.txt" "%files_url_project_base%/%temp_file_slash_path%"
) else IF "%temp_file_path%"=="%language_path%\tools\general_update_version.txt" (
	IF EXIST "%temp_file_path%" (
		set /p script_version=<"%temp_file_path%"
	) else (
		set script_version=0
	)
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "version.txt" "%files_url_project_base%/%temp_file_slash_path%"
) else IF "%temp_file_path%"=="tools\version.txt" (
	IF EXIST "%temp_file_path%" (
		set /p script_version=<"%temp_file_path%"
	) else (
		set script_version=0
	)
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "version.txt" "%files_url_project_base%/%temp_file_slash_path%"
) else (
	IF EXIST "%~1.version" set /p script_version=<"%~1.version"
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "version.txt" "%files_url_project_base%/%temp_file_slash_path%.version"
)
set /p script_version_verif=<"templogs\version.txt"
rem echo %temp_file_path% : va=%script_version%, vm=%script_version_verif%
rem echo %temp_file_slash_path%
rem pause
call :compare_version
exit /b

:verif_folder_version
set temp_folder_path=%~1
set temp_folder_slash_path=%temp_folder_path:\=/%
call :test_write_access folder "%~1"
set script_version=0
IF EXIST "%~1\folder_version.txt" set /p script_version=<"%~1\folder_version.txt"
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -d "templogs" -o "version.txt" "%files_url_project_base%/%temp_folder_slash_path%/folder_version.txt"
set /p script_version_verif=<"templogs\version.txt"
rem echo %temp_folder_path% : va=%script_version%, vm=%script_version_verif%
rem echo %temp_folder_slash_path%
rem pause
call :compare_version
exit /b

:update_file
echo %temp_file_path%>"failed_updates\%temp_file_path:\=;%.file.failed"
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%temp_file_path%" "%files_url_project_base%/%temp_file_slash_path%"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_file_error"
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
:file.version_download
IF "%temp_file_path%"=="tools\general_update_version.txt" goto:skip_file.version_download
IF "%temp_file_path%"=="languages\FR_fr\tools\general_update_version.txt" goto:skip_file.version_download
IF "%temp_file_path%"=="%language_path%\tools\general_update_version.txt" goto:skip_file.version_download
IF "%temp_file_path%"=="tools\version.txt" (
			set /p version=<tools\version.txt
	goto:skip_file.version_download
)
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%temp_file_path%.version" "%files_url_project_base%/%temp_file_slash_path%.version"
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "update_file.version_error"
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
:skip_file.version_download
del /q "failed_updates\%temp_file_path:\=;%.file.failed"
call "%associed_language_script%" "update_file_success"
exit /b

:update_folder
echo !temp_folder_path!>"failed_updates\!temp_folder_path:\=;!.fold.failed"
rmdir /s /q "%temp_folder_path%" >nul 2>&1
"tools\gnuwin32\bin\wget.exe" -q -np -nH -r --level=0 --cut-dirs=1 -t 3 --user="anonymous" --password="" -P "." %folders_url_project_base%/%temp_folder_slash_path%
set temp_folder_download_error=%errorlevel%
IF %temp_folder_download_error% NEQ 0 (
	call "%associed_language_script%" "update_folder_error"
	IF EXIST templogs (
		rmdir /s /q templogs
	)
	pause
	exit
)
del /q "failed_updates\%temp_folder_path:\=;%.fold.failed"
call "%associed_language_script%" "update_folder_success"
exit /b

:compare_version
set update_finded=
IF "%script_version_verif%"=="" goto:end_compare_version
IF "%script_version%"=="" (
	IF NOT "%script_version_verif%"=="" (
		set update_finded=Y
		exit /b
	) else (
		exit /b
	)
)
echo %script_version_verif%|"tools\gnuwin32\bin\grep.exe" -o "\."|"tools\gnuwin32\bin\wc.exe" -l >templogs\tempvar.txt
set /p count_script_version_verif_cols=<templogs\tempvar.txt
set /a count_script_version_verif_cols+=1
echo %script_version%|"tools\gnuwin32\bin\grep.exe" -o "\."|"tools\gnuwin32\bin\wc.exe" -l >templogs\tempvar.txt
set /p count_script_version_cols=<templogs\tempvar.txt
set /a count_script_version_cols+=1
IF %count_script_version_verif_cols% EQU 1 (
	IF %count_script_version_cols% EQU 1 (
		IF %script_version_verif% GTR %script_version% (
			set update_finded=Y
			exit /b
		) else (
			exit /b
		)
	)
)
for /l %%i in (1,1,%count_script_version_verif_cols%) do (
	echo %script_version_verif%|"tools\gnuwin32\bin\grep.exe" ""|"tools\gnuwin32\bin\cut.exe" -d . -f %%i >templogs\tempvar.txt
	set /p temp_script_version_verif=<templogs\tempvar.txt
	echo %script_version%|"tools\gnuwin32\bin\grep.exe" ""|"tools\gnuwin32\bin\cut.exe" -d . -f %%i >templogs\tempvar.txt
	set /p temp_script_version=<templogs\tempvar.txt
	IF !temp_script_version_verif! GTR !temp_script_version! (
		set update_finded=Y
		exit /b
	)
)

:test_write_access
IF "%~1"=="folder" (
	mkdir "%~2\test"
) else (
	mkdir "%~dp2\test"
)
IF %errorlevel% NEQ 0 (
	call "%associed_language_script%" "write_access_test_error"
	pause
	goto:end_script
)
IF "%~1"=="folder" (
	rmdir /s /q "%~2\test"
) else (
	rmdir /s /q "%~dp2\test"
)
exit /b

:update_failed_content
set /p temp_failed_update_path=<"%~1"
set temp_failed_file=%~1
IF "%temp_failed_file:~-11,4%"=="file" (
	set temp_file_path=%temp_failed_update_path%
	set temp_file_slash_path=%temp_failed_update_path:\=/%
	call :update_file
)
IF "%temp_failed_file:~-11,4%"=="fold" (
	set temp_folder_path=%temp_failed_update_path%
	set temp_folder_slash_path=%temp_failed_update_path:\=/%
	call :update_folder
)
exit /b

:update_manager_update_special_script
echo %what_to_update%>"continue_update.txt"
IF EXIST templogs (
	rmdir /s /q templogs
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q failed_updates
)
endlocal
::start /i "" "%windir%\system32\cmd.exe" /c call "tools\Storage\update_manager_updater.bat" "%project_author%" "%project_name%"
::IF /i "%language_echo%"=="on" pause
call "tools\Storage\update_manager_updater.bat" "%project_author%" "%project_name%"
exit
exit /b

:initialize_language
"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	echo No internet connection and the language is not initialized, script will close.
	pause
	exit /b 500
)
copy nul "continue_update.txt" >nul
IF NOT EXIST "tools\default_configs\Lists\languages.list" (
	"tools\gnuwin32\bin\wget.exe" -q -np -nH -r --level=0 --cut-dirs=1 -t 3 --user="anonymous" --password="" -P "." %folders_url_project_base%/tools/default_configs/Lists
)
"tools\gnuwin32\bin\wget.exe" -q -np -nH -r --level=0 --cut-dirs=1 -t 3 --user="anonymous" --password="" -P "." %folders_url_project_base%/%temp_language_path:\=/%
IF NOT "%temp_language_path%"=="languages\FR_fr" (
	"tools\gnuwin32\bin\wget.exe" -q -np -nH -r --level=0 --cut-dirs=1 -t 3 --user="anonymous" --password="" -P "." %folders_url_project_base%/languages/FR_fr
)
echo Language initialized, script will restart.
pause
start /i "" "%windir%\system32\cmd.exe" /c call "%project_name%.bat"
IF /i "%language_echo%"=="on" pause
exit
exit /b

:del_old_or_unused_files
call "%associed_language_script%" "del_hold_files_begin"
rmdir /s /q "tools\gitget"
call "%associed_language_script%" "del_hold_files_end"
exit /b

:o/n_choice
IF /i "!%~1!"=="%lng_yes_choice%" (
	set %~1=o
) else IF /i "!%~1!"=="%lng_no_choice%" (
	set %~1=n
) else (
	set %~1=n
)
exit /b

:o/n/t/j_choice
IF /i "!%~1!"=="%lng_yes_choice%" (
	set %~1=o
) else IF /i "!%~1!"=="%lng_no_choice%" (
	set %~1=n
) else IF /i "!%~1!"=="%lng_always_choice%" (
	set %~1=t
) else IF /i "!%~1!"=="%lng_never_choice%" (
	set %~1=j
) else (
	set %~1=n
)
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q failed_updates
)
cls
:skip_ending_cls
endlocal