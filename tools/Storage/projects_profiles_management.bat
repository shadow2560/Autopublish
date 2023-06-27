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
IF NOT EXIST "tools\profiles\*.*" mkdir "tools\profiles"
IF NOT EXIST "tools\profiles\github\*.*" mkdir "tools\profiles\github"

set global_t_name=%git_project_name%
set global_t_path=%git_project_local_path%
set global_t_url=%git_project_remote_url%

:define_action_choice
cls
set error_level=0
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "main_action_choice"
IF "%action_choice%"=="1" cls & goto:create_profile
IF "%action_choice%"=="2" cls & goto:modify_profile
IF "%action_choice%"=="3" cls & goto:remove_profile
IF "%action_choice%"=="0" cls & goto:info_profile
goto:end_script

:info_profile
call "%associed_language_script%" "intro_info_profile"
call :select_profile
IF %errorlevel% EQU 400 goto:define_action_choice
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "info_no_profile_exist_error"
	pause
	goto:define_action_choice
)
call "%profile_path%"
call "%associed_language_script%" "info_profile"
pause
goto:define_action_choice

:create_profile
:define_new_profile_name
set new_profile_name=
call "%associed_language_script%" "intro_create_profile"
IF "%new_profile_name%"=="" goto:define_action_choice
call TOOLS\Storage\functions\strlen.bat nb "%new_profile_name%"
set i=0
:check_chars_new_profile_name
IF %i% LSS %nb% (
	FOR %%z in (^& ^< ^> ^/ ^* ^? ^: ^^ ^| ^\ ^( ^) ^") do (
		IF "!new_profile_name:~%i%,1!"=="%%z" (
			call "%associed_language_script%" "char_error_in_profile_name"
			goto:define_new_profile_name
		)
	)
	set /a i+=1
	goto:check_chars_new_profile_name
)
copy nul "tools\profiles\github\%new_profile_name%.bat" >nul
call "%associed_language_script%" "create_profile_success"
set profile_selected=%new_profile_name%.bat
set /a error_level=0
set /a add_profile=1
goto:skip_modify_select_profile

:modify_profile
set /a add_profile=0
call "%associed_language_script%" "intro_modify_profile"
echo.
call :select_profile
IF %errorlevel% EQU 400 goto:define_action_choice
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "modify_no_profile_exist_error"
	pause
	goto:define_action_choice
)
set /a error_level=0
:skip_modify_select_profile
IF %error_level% EQU 0 (
	if %add_profile% NEQ 1 (
		call "%profile_path%"
		call :set_profile_values "m"
	) else (
		call :set_profile_values "a"
		if !errorlevel! NEQ 200 (
			del /q "tools\profiles\github\%new_profile_name%.bat" >nul
			goto:define_action_choice
		)
	)
) else (
	goto:define_action_choice
)
IF %error_level% EQU 200 (
	call :save_profile_choices
)
goto:define_action_choice

:set_profile_values
if  "%~1" == "m" (
	set t_name=%git_project_name%
	set t_path=%git_project_local_path%
	set t_url=%git_project_remote_url%
)
call "%associed_language_script%" "set_values_intro" "%~1"
set name=
call "%associed_language_script%" "set_project_name"
if "%name%" == "" (
	if  "%~1" == "m" (
		set name=%t_name%
	) else (
		set error_level=400
		exit /b 400
	)
)
set path=
call "%associed_language_script%" "set_project_local_path"
set /p path=<templogs\tempvar.txt
if "%path%" == "" (
	if  "%~1" == "m" (
		set path=%t_path%
	) else (
		set error_level=400
		exit /b 400
	)
)
set url=
call "%associed_language_script%" "set_project_remote_url"
if "%url%" == "" (
	if  "%~1" == "m" (
		set url=%t_url%
	) else (
		set /a error_level=400
		exit /b 400
	)
) else (
	set url=https://github.com/%url%.git
)
set /a error_level=200
exit /b 200

:remove_profile
call "%associed_language_script%" "intro_delete_profile"
echo.
call :select_profile
IF %errorlevel% EQU 400 goto:define_action_choice
IF %errorlevel% EQU 404 (
	call "%associed_language_script%" "delete_no_profile_exist_error"
	pause
	goto:define_action_choice
)
IF %errorlevel% EQU 0 (
	call "%profile_path%"
	del /q "tools\profiles\github\%profile_selected%" >nul
	call "%associed_language_script%" "delete_profile_success"
	if "%global_t_name%" == "!git_project_name!" (
		if "%global_t_path%" == "!git_project_local_path!" (
			if "%global_t_url%" == "!git_project_remote_url!" (
				call "%associed_language_script%" "delete_profile_used_by_script"
				pause
				IF EXIST "templogs" (
					del /q "templogs" 2>nul
					rmdir /s /q "templogs" 2>nul
				)
				endlocal
				start /i "" "%windir%\system32\cmd.exe" /c call "%project_name%.bat"
				IF /i "%language_echo%"=="on" pause
				exit
			)
		)
	)
	pause
)
goto:define_action_choice

:select_profile
set profile_selected=
call "%associed_language_script%" "intro_select_profile"
IF NOT EXIST "tools\profiles\github\*.bat" exit /b 404
set /a temp_count=1
copy nul templogs\profiles_list.txt >nul
cd tools\profiles\github
for %%p in (*.bat) do (
	IF %%~zp EQU 0 (
		del /q %%p >nul
	) else (
		set temp_profilename=%%p
		set temp_profilename=!temp_profilename:~0,-4!
		echo !temp_count!: !temp_profilename!
		echo %%p>> ..\..\..\templogs\profiles_list.txt
		set /a temp_count+=1
	)
)
cd ..\..\..
set profile_choice=
call "%associed_language_script%" "select_profile_choice"
IF "%profile_choice%"=="" set /a profile_choice=0
call TOOLS\Storage\functions\strlen.bat nb "%profile_choice%"
set i=0
:check_chars_profile_choice
IF %i% NEQ %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!profile_choice:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_profile_choice
		)
	)
	IF "!check_chars!"=="0" (
		exit /b 400
	)
)
IF %profile_choice% GEQ %temp_count% exit /b 400
IF %profile_choice% EQU 0 exit /b 400
TOOLS\gnuwin32\bin\sed.exe -n %profile_choice%p <templogs\profiles_list.txt > templogs\tempvar.txt
del /q templogs\profiles_list.txt >nul
set /p profile_selected=<templogs\tempvar.txt
set profile_path=tools\profiles\github\%profile_selected%
exit /b  200

:save_profile_choices
IF %error_level% NEQ 200 exit /b
set profile_path=tools\profiles\github\%profile_selected%
echo set "git_project_name=%name%">"%profile_path%"
echo set "git_project_local_path=%path%">>"%profile_path%"
echo set "git_project_remote_url=%url%">>"%profile_path%"
call "%associed_language_script%" "values_saved_success"
pause
exit /b

:end_script
IF EXIST templogs (
	rmdir /s /q templogs
	mkdir templogs
)
endlocal