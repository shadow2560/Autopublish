::Script by Shadow256
@echo off
Setlocal enabledelayedexpansion
chcp 65001 >nul
cls
IF EXIST "tools\Storage\update_manager_updater.bat.version" (
	set /p this_script_version=<"tools\Storage\update_manager_updater.bat.version"
) else (
	set this_script_version=1.00.00
)
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
mkdir "templogs"
cd >templogs\tempvar.txt
set /p script_base_path=<templogs\tempvar.txt
set script_base_path=%script_base_path%\
set project_author=%~1
set project_name=%~2
:define_language_path
set language_custom=0
set language_path=
IF EXIST "%project_name%.bat.lng" set /p language_path=<"%project_name%.bat.lng"
IF NOT "%language_path%"=="" (
	IF NOT EXIST "%language_path%\*.*" (
		del /q "%project_name%.bat.lng"
		goto:define_language_path
	)
)
IF NOT "%language_path%"=="" call "%language_path%\language_general_config.bat"
set this_script_full_path=%script_base_path%tools\Storage\update_manager_updater.bat
set associed_language_script=%language_path%\!this_script_full_path:%script_base_path%=!
set associed_language_script=%script_base_path%%associed_language_script%
IF NOT "%language_path%"=="" (
	call "%associed_language_script%" "display_title"
) else (
	title Update Manager Updater%this_script_version% - %project_author% %project_name%
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates" 2>nul
)
	mkdir "failed_updates"
set temp_file_path=tools\Storage\update_manager.bat
set temp_file_slash_path=%temp_file_path:\=/%
::set folders_url_project_base=https://github.com/shadow2560/Autopublish/trunk
::set files_url_project_base=https://raw.githubusercontent.com/shadow2560/Autopublish/main
set folders_url_project_base=ftp://158.178.198.95/Autopublish/
set files_url_project_base=ftp://158.178.198.95/Autopublish
IF NOT "%language_path%"=="" (
	call "%associed_language_script%" "begin_update"
) else (
	echo :::::::::::::::::::::::::::::::::::::
	echo ::%project_author% %project_name% Update Manager Updater::
	echo.
	echo Updating script Update Manager...
)
"%windir%\system32\ping.exe" /n 2 www.github.com >nul 2>&1
IF %errorlevel% NEQ 0 (
	IF NOT "%language_path%"=="" (
		call "%associed_language_script%" "no_internet_connection_error"
		pause
		endlocal
		exit
	) else (
		echo No internet connection could be verified, update could not be done and script will be closed.
		pause
		endlocal
		exit
	)
)
IF NOT EXIST "tools\aria2\aria2c.exe" (
	"tools\gnuwin32\bin\wget.exe" -q -np -nH -r --level=0 --cut-dirs=1 -t 3 --user="anonymous" --password="" -P "." %folders_url_project_base%/tools/aria2
)
echo %temp_file_path%>"failed_updates\%temp_file_path:\=;%.file.failed"
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%temp_file_path%" "%files_url_project_base%/%temp_file_slash_path%"
IF %errorlevel% NEQ 0 (
	IF NOT "%language_path%"=="" (
		call "%associed_language_script%" "update_file_error"
		IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	) else (
	echo Update file "%temp_file_path%" error, script will close and will retry the update on next update try.
	IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	)
)
"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%temp_file_path%.version" "%files_url_project_base%/%temp_file_slash_path%.version"
IF %errorlevel% NEQ 0 (
	IF NOT "%language_path%"=="" (
		call "%associed_language_script%" "update_file.version_error"
		IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	) else (
	echo Update file "%temp_file_path%.version" error, script will close and will retry the update on next update try.
	IF EXIST "templogs" (
			rmdir /s /q "templogs"
		)
		pause
		endlocal
		exit
	)
)
IF EXIST "languages\FR_fr" (
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "languages\FR_fr\%temp_file_path%" "%files_url_project_base%/languages/FR_fr/%temp_file_slash_path%"
	IF %errorlevel% NEQ 0 (
		IF NOT "%language_path%"=="" (
			call "%associed_language_script%" "update_file_error"
			IF EXIST "templogs" (
				rmdir /s /q "templogs"
			)
			pause
			endlocal
			exit
		) else (
		echo Update file "languages\FR_fr\%temp_file_path%" error, script will close and will retry the update on next update try.
		IF EXIST "templogs" (
				rmdir /s /q "templogs"
			)
			pause
			endlocal
			exit
		)
	)
	"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "languages\FR_fr\%temp_file_path%.version" "%files_url_project_base%/languages/FR_fr/%temp_file_slash_path%.version"
	IF %errorlevel% NEQ 0 (
		IF NOT "%language_path%"=="" (
			call "%associed_language_script%" "update_file.version_error"
			IF EXIST "templogs" (
				rmdir /s /q "templogs"
			)
			pause
			endlocal
			exit
		) else (
		echo Update file "languages\FR_fr\%temp_file_path%.version" error, script will close and will retry the update on next update try.
		IF EXIST "templogs" (
				rmdir /s /q "templogs"
			)
			pause
			endlocal
			exit
		)
	)
)
IF NOT "%language_path%"=="" (
	IF NOT "%language_path%"=="languages\FR_fr" (
		IF "%language_custom%"=="0" (
			"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%language_path%\%temp_file_path%" "%files_url_project_base%/%language_path:\=/%/%temp_file_slash_path%"
			IF %errorlevel% NEQ 0 (
				call "%associed_language_script%" "update_language_file_error"
				IF EXIST "templogs" (
					rmdir /s /q "templogs"
				)
				pause
				endlocal
				exit
			)
			"tools\aria2\aria2c.exe" -m 0 --auto-save-interval=0 --file-allocation=none --allow-overwrite=true --continue=false --auto-file-renaming=false --quiet=true --summary-interval=0 --remove-control-file=true --always-resume=false --save-not-found=false --keep-unfinished-download-result=false -o "%language_path%\%temp_file_path%.version" "%files_url_project_base%/%language_path:\=/%/%temp_file_slash_path%.version"
			IF %errorlevel% NEQ 0 (
				call "%associed_language_script%" "update_language_file.version_error"
				IF EXIST "templogs" (
					rmdir /s /q "templogs"
				)
				pause
				endlocal
				exit
			)
		)
	)
)
del /q "failed_updates\%temp_file_path:\=;%.file.failed"
IF EXIST "templogs" (
	rmdir /s /q "templogs"
)
IF NOT EXIST "failed_updates\*.failed" (
	rmdir /s /q "failed_updates"
)
IF NOT "%language_path%"=="" (
	call "%associed_language_script%" "update_success"
) else (
	echo Update Manager update success, script will restart.
)
pause
IF EXIST "templogs" (
	del /q "templogs" 2>nul
	rmdir /s /q "templogs" 2>nul
)
endlocal
start /i "" "%windir%\system32\cmd.exe" /c call "%project_name%.bat"
IF /i "%language_echo%"=="on" pause
exit