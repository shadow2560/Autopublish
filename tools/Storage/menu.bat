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
set full_launch=Y
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
mkdir templogs

call "%associed_language_script%" "display_title"
call "%associed_language_script%" "display_app_infos_during_first_verifications"
:test_git_installation
git -v >nul 2>&1
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "git_must_be_installed"
	pause
	"%script_base_path%tools\git_installer\git_x86_installer.exe"
	endlocal
	exit
)

:verify_profile
if not exist "tools\profiles\github\*.bat" (
	call "%associed_language_script%" "must_create_one_profile"
	pause
	call tools\Storage\projects_profiles_management.bat
	goto:verify_profile
)
call :aply_profile_to_script

if not exist "%git_project_local_path%\" (
	goto:clone_project
)
if EXIST "%git_project_local_path%\.git" goto:init_project
for /f "usebackq" %%i in (`dir "%git_project_local_path%\" /b`) do (
	call "%associed_language_script%" "git_directory_not_git_repos_and_not_empty"
	pause
	goto:end_script
)
rmdir "%git_project_local_path%"
:clone_project
call "%associed_language_script%" "cloning_repos"
git clone --recursive "%git_project_remote_url%" "%git_project_local_path%"
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "clone_repos_error"
	pause
	goto:end_script
)

:init_project
cd /d "%git_project_local_path%"
call "%associed_language_script%" "getting_project_status"
git status >nul 2>&1
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "get_project_status_error"
	pause
	goto:end_script
)

:define_action_choice
cd /d "%script_base_path%"
set action_choice=
cls
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "display_menu"
IF "%action_choice%"=="0" goto:launch_doc
IF "%action_choice%"=="1" goto:project_auth_menu
IF "%action_choice%"=="2" goto:project_infos_menu
IF "%action_choice%"=="3" goto:project_modifs_menu
if "%action_choice%"=="4" (
	cd /d "%git_project_local_path%"
	git fetch
	git pull
	git submodule update --init --recursive
	pause
	goto:define_action_choice
)
IF "%action_choice%"=="5" goto:manage_projects_profiles
IF "%action_choice%"=="6" (
	call :aply_profile_to_script
	goto:verify_profile
)
IF "%action_choice%"=="7" goto:ftp
IF "%action_choice%"=="8" goto:nvda_remote_control
IF "%action_choice%"=="9" goto:settings
IF "%action_choice%"=="10" goto:language_change
IF "%action_choice%"=="11" goto:theme_change
IF "%action_choice%"=="12" goto:about
IF "%action_choice%"=="13" goto:donate
goto:end_script

:project_auth_menu
cd /d "%script_base_path%"
cls
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "display_auth_menu"
if "%action_choice%"=="1" (
	"%script_base_path%tools\gh\gh.exe" auth login
	pause
	goto:project_auth_menu
)
if "%action_choice%"=="2" (
	"%script_base_path%tools\gh\gh.exe" auth setup-git
	pause
	goto:project_auth_menu
)
goto:define_action_choice

:project_infos_menu
cd /d "%script_base_path%"
cls
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "display_infos_menu"
if "%action_choice%"=="1" (
	cd /d "%git_project_local_path%"
	"%script_base_path%tools\gh\gh.exe" repo view -w
	pause
	goto:project_infos_menu
)
IF "%action_choice%"=="2" (
	cd /d "%git_project_local_path%"
	git log
	goto:project_infos_menu
)
if "%action_choice%"=="3" (
	cd /d "%git_project_local_path%"
	git status
	pause
	goto:project_infos_menu
)
if "%action_choice%"=="4" (
	cd /d "%git_project_local_path%"
	"%script_base_path%tools\gh\gh.exe" release view -w
	pause
	goto:project_infos_menu
)
if "%action_choice%"=="5" (
	cd /d "%git_project_local_path%"
	"%script_base_path%tools\gh\gh.exe" run view --log
	pause
	goto:project_infos_menu
)
if "%action_choice%"=="6" (
	cd /d "%git_project_local_path%"
	"%script_base_path%tools\gh\gh.exe" run view -w
	pause
	goto:project_infos_menu
)
IF "%action_choice%"=="7" (
	set sha256_file=
	call "%associed_language_script%" "calculate_sha256_file_select"
	set /p sha256_file=<"templogs\tempvar.txt"
	if "!sha256_file!" == "" goto:define_action_choice
	"tools\gnuwin32\bin\sha256sum.exe" "!sha256_file!"
	pause
	goto:project_infos_menu
)
goto:define_action_choice

:project_modifs_menu
cd /d "%script_base_path%"
cls
set action_choice=
call "%associed_language_script%" "display_title"
call "%associed_language_script%" "display_modifs_menu"
IF "%action_choice%"=="1" goto:make_and_publish_changes
IF "%action_choice%"=="2" goto:publish_release
IF "%action_choice%"=="3" goto:del_release
if "%action_choice%"=="4" (
	cd /d "%git_project_local_path%"
	"%script_base_path%tools\gh\gh.exe" workflow run
	pause
	goto:project_modifs_menu
)
if "%action_choice%"=="5" goto:make_local_changes
if "%action_choice%"=="6" goto:del_commits
if "%action_choice%"=="7" goto:publish_changes
goto:define_action_choice

:make_local_changes
cd /d "%git_project_local_path%"
set changes_text=
call "%associed_language_script%" "set_changes_text"
if NOT "%changes_text%"=="" (
	set changes_text=%changes_text:"=\"%
) else (
	goto:project_modifs_menu
)
git pull
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "get_last_remote_project_modifications_error_local_adds"
	pause
	goto:project_modifs_menu
)
git submodule update --init --recursive
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "get_last_remote_project_modifications_error_local_adds"
	pause
	goto:project_modifs_menu
)
git add .
git commit -s -m "%changes_text%"
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "commit_add_error_local_adds"
	pause
	goto:project_modifs_menu
)
pause
goto:project_modifs_menu

:publish_changes
cd /d "%git_project_local_path%"
git push
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "push_error"
)
pause
goto:project_modifs_menu

:make_and_publish_changes
cd /d "%git_project_local_path%"
set changes_text=
call "%associed_language_script%" "set_changes_text"
if NOT "%changes_text%"=="" (
	set changes_text=%changes_text:"=\"%
) else (
	goto:project_modifs_menu
)
git pull
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "get_last_remote_project_modifications_error"
	pause
	goto:project_modifs_menu
)
git submodule update --init --recursive
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "get_last_remote_project_modifications_error"
	pause
	goto:project_modifs_menu
)
git add .
git commit -s -m "%changes_text%"
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "commit_add_error"
	pause
	goto:project_modifs_menu
)
git push
if %errorlevel% NEQ 0 (
	git reset "head~1"
	call "%associed_language_script%" "push_error"
)
pause
goto:project_modifs_menu

:del_commits
set n_commits_to_del=
call "%associed_language_script%" "set_commits_number_to_del"
if "%n_commits_to_del%"=="" goto:project_modifs_menu
call tools\Storage\functions\strlen.bat nb "%n_commits_to_del%"
set i=0
:check_chars_n_commits_to_del
IF %i% LSS %nb% (
	set check_chars=0
	FOR %%z in (0 1 2 3 4 5 6 7 8 9) do (
		IF "!n_commits_to_del:~%i%,1!"=="%%z" (
			set /a i+=1
			set check_chars=1
			goto:check_chars_n_commits_to_del
		)
	)
	IF "!check_chars!"=="0" (
		call "%associed_language_script%" "n_commits_to_del_char_error"
		pause
		goto:define_filename
	)
)
set commit_files_reset=
call "%associed_language_script%" "set_commit_files_reset"
if "%commit_files_reset%"=="" goto:project_modifs_menu
set commit_files_reset=%commit_files_reset:~0,1%
call "%script_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "commit_files_reset" "o/n_choice"
cd /d "%git_project_local_path%"
if /i "%commit_files_reset%"=="o" (
	git reset --hard --recurse-submodules "head~%n_commits_to_del%"
) else (
	git reset "head~%n_commits_to_del%"
)
pause
goto:project_modifs_menu

:publish_release
cd /d "%git_project_local_path%"
:set_tag_number
set tag_number=
call "%associed_language_script%" "set_tag_number"
if "%tag_number%"=="0" (
	git tag
	pause
	goto:set_tag_number
)
if "%tag_number%"=="" goto:project_modifs_menu
set tag_text=
call "%associed_language_script%" "set_tag_text"
if NOT "%tag_text%"=="" (
	set tag_text=%tag_text:"=\"%
) else (
	goto:project_modifs_menu
)
git pull
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "get_last_remote_project_release_publish_error"
	pause
	goto:project_modifs_menu
)
git submodule update --init --recursive
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "get_last_remote_project_release_publish_error"
	pause
	goto:project_modifs_menu
)
git tag -a "%tag_number%" -m "%tag_text%"
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "local_tag_create_error"
	pause
	goto:project_modifs_menu
)
git push --tags
if %errorlevel% NEQ 0 (
	git tag -d "%tag_number%"
	call "%associed_language_script%" "local_tag_push_error"
	pause
	goto:project_modifs_menu
)
"%script_base_path%tools\gh\gh.exe" release create "%tag_number%" --verify-tag
if %errorlevel% NEQ 0 (
	git tag -d "%tag_number%"
	git push --delete origin "%tag_number%"
	call "%associed_language_script%" "release_create_error"
	pause
	goto:project_modifs_menu
)
:ask_file_upload
set ask_file_upload=
call "%associed_language_script%" "set_ask_file_upload"
IF NOT "%ask_file_upload%"=="" set ask_file_upload=%ask_file_upload:~0,1%
call "%script_base_path%tools\Storage\functions\modify_yes_no_always_never_vars.bat" "ask_file_upload" "o/n_choice"
if /i "%ask_file_upload%"=="o" (
	call :file_upload "%tag_number%"
	goto:ask_file_upload
)
goto:project_modifs_menu

:file_upload
set up_file_path=
call "%associed_language_script%" "upload_file_choice"
set /p up_file_path=<"%script_base_path%templogs\tempvar.txt"
if "%up_file_path%"=="" (
	call "%associed_language_script%" "upload_file_choice_no_file_selected_error"
	exit /b
)
"%script_base_path%tools\gh\gh.exe" release upload "%~1" "%up_file_path%" --clobber
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "upload_file_choice_send_error"
) else (
	call "%associed_language_script%" "upload_file_choice_send_success"
)
exit /b

:del_release
cd /d "%git_project_local_path%"
:set_tag_number_for_release_delete
set tag_number=
call "%associed_language_script%" "set_release_number_for_release_del"
if "%tag_number%"=="0" (
	"%script_base_path%tools\gh\gh.exe" release  list
	pause
	goto:set_tag_number_for_release_delete
)
if "%tag_number%"=="" goto:project_modifs_menu
"%script_base_path%tools\gh\gh.exe" release  delete "%tag_number%" --cleanup-tag  -y
if %errorlevel% NEQ 0 (
	call "%associed_language_script%" "release_remote_del_error"
	pause
	goto:project_modifs_menu
) else (
	git tag -d "%tag_number%"
)
pause
goto:project_modifs_menu

:settings
set action_choice=
echo.
cls
call tools\Storage\settings_menu.bat
@echo off
goto:define_action_choice
:nvda_remote_control
set action_choice=
echo.
cls
IF EXIST "tools\Storage\nvda_remote_control.bat" (
	call tools\Storage\update_manager.bat "update_nvda_remote_control.bat"
) else (
	call tools\Storage\update_manager.bat "update_nvda_remote_control.bat" "force"
)
call tools\Storage\nvda_remote_control.bat
@echo off
goto:define_action_choice
:language_change
set action_choice=
echo.
cls
call tools\Storage\language_selector.bat
@echo off
goto:define_action_choice
:theme_change
set action_choice=
echo.
cls
call tools\Storage\theme_selector.bat
@echo off
goto:define_action_choice
:about
set action_choice=
echo.
cls
call tools\Storage\about.bat
@echo off
goto:define_action_choice
:donate
set action_choice=
echo.
cls
call tools\Storage\donate.bat
@echo off
goto:define_action_choice
:manage_projects_profiles
set action_choice=
echo.
cls
call tools\Storage\projects_profiles_management.bat
@echo off
goto:define_action_choice
:ftp
set action_choice=
echo.
cls
IF EXIST "tools\Storage\ftp.bat" (
	call tools\Storage\update_manager.bat "update_ftp.bat"
) else (
	call tools\Storage\update_manager.bat "update_ftp.bat" "force"
)
call tools\Storage\ftp.bat
@echo off
goto:define_action_choice
:launch_doc
echo.
start "" "%language_path%\doc\index.html"
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
IF "%profile_choice%"=="0" (
	call tools\Storage\projects_profiles_management.bat
	goto:select_profile
)
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

:aply_profile_to_script
:while_profile_not_selected
call "%associed_language_script%" "select_profile_to_apply"
echo.
call :select_profile
if %errorlevel% NEQ 200 goto:while_profile_not_selected
call "%profile_path%"
exit /b

:end_script
IF EXIST templogs (
	del /q templogs 2>nul
	rmdir /s /q templogs 2>nul
)
endlocal
exit