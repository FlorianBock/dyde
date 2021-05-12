REM DESCRIPTION: git update script that searches its directory and all subdirectories for valid git repositories and updates them

REM USAGE: copy the script to every folder where folders with git repositories are present

REM AUTHOR: Florian Bock (florian.inifau.bock@fau.de)

LICENSE: Apache License Version 2.0 (see LICENSE file)

REM COLORS: 
REM 0 = black 1 = navy 2 = green 3 = teal 4 = maroon 5 = purple 6 = olive E = yellow 7 = silver
REM 8 = gray 9 = blue A = lime B = aqua C = red D = fuchsia E = yellow F = white

@ECHO OFF
CLS
COLOR 08
SETLOCAL EnableDelayedExpansion

REM prepare text colorization
REM credits: https://stackoverflow.com/a/23072489/3931279
FOR /F "tokens=1,2 delims=#" %%a IN ('"PROMPT #$H#$E# & ECHO ON & FOR %%b IN (1) DO REM"') DO (
  SET "DEL=%%a"
)

REM check all directories recursively
FOR /F "tokens=*" %%G IN ('dir /b /a:d ') DO (
 CALL :ColorText 0F "CHECKING '"
 ECHO|SET /p="%%G"
 CALL :ColorText 0F "'"
 ECHO.
 
 REM enter directory
 CD "%%G"
 
 REM check if this batch file exists there as well (so it should be executed)
 IF EXIST "%~n0%~x0" ( START cmd /k CALL %~n0%~x0 )
 
 REM check if directory contains a .git folder (it is a git repository)
 IF EXIST ".git" (
  ECHO %%G is a GIT directory... Updating...
  
  REM update repository
  git pull
  ECHO|SET /p="%%G... "
  
  REM print status depending on what happened
  IF %errorlevel%==0 (
   CALL :ColorText 02 "updated."
  ) ELSE (
   CALL :ColorText 0C "failed."
  )
  ECHO.
 ) ELSE (
  REM not a git repository, so skip it
  ECHO|SET /p="%%G is not a GIT directory... "
  CALL :ColorText 0E "skipped."
  ECHO.
 )
 ECHO.
 
 REM leave directory
 CD..
)

REM all done
ECHO.
ECHO All directories updated.
PAUSE
EXIT

REM colorize text
REM credits: https://stackoverflow.com/a/23072489/3931279
:ColorText
<nul set /p "=%DEL%" > "%~2"
findstr /v /a:%1 /R "+" "%~2" nul
del "%~2" > nul
goto :eof