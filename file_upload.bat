@echo off &setlocal enabledelayedexpansion

rem Author: Gregori Povolotski
rem Created: 18.05.2020
rem The script connect to FTP server and transfer the files, move original the files to Archiv directory.
rem Also checking each 15 min for new files.

set "file=upload.txt"
set "server=tourget ip"
set "var=no files in directory"
set "minsize=0"

set "job_file=path to the files, where the list of 'new names of files' are stored"
set "my_path=path to directory where the file, there must be transfared are stoured"
set "my_path_archiv=path to archiv file"

for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set DateTime=%%a

rem variables for the date/time format
set Yr=%DateTime:~0,4%
set Mon=%DateTime:~4,2%
set Day=%DateTime:~6,2%
set Hr=%DateTime:~8,2%
set Min=%DateTime:~10,2%
set Sec=%DateTime:~12,2%
rem path variable
set BackupName= _%Yr%_%Mon%_%Day%_(%Hr%_%Min%_%Sec%)


rem start of loop
:loop
set /a count=0
rem read the  file and sett the lines to array file_[]
for /f "delims=" %%a in (%job_file%) DO ( 
  set "file_[!count!]=%%a"
  set /a count+=1
)

set file_
set /a count-=1
rem delete file 
del %job_file%
rem Display array elements
for /l %%A in (0,1,%Count%) do (
rem output to follow the code; change old name and new name to name of the file
    echo "var%%A" is assigned to ==^> "!file_[%%A]!"
rem copy the file to archiv folder
		if "!file_[%%A]!"=="old name" (
		echo "%my_path%new name*"
			move "%my_path%new name*" %my_path_archiv%
			set file[%%A]=0
			pause
		)
		
)
pause
rem python script to conect the ftp server
python C:\ProjectFinatycs\FTP_Upload\FTP.py %*
pause
rem check if some files are in the directory
if  exist %my_path_archiv%*.* (
for %%a in (%my_path_archiv%*.*) do (
rem copy file to Archiv directory
    copy "%%a" %my_path%"Archiv\%%~na%BackupName%%%~xa"	
rem delete all files

)
del %my_path_archiv%*.* /F /Q
 rem del %my_path%*.* /F /Q
) 

rem delay for 60 min in seconds
timeout /t 900
rem back to the loop
goto loop 
rem end of loop
rem end script
