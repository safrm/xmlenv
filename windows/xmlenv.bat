@REM multiplatformal/distribution system dumping and comparation - http://safrm.net/projects/xmlenv
@REM author:  Miroslav Safr miroslav.safr@gmail.com
@ECHO OFF
:Loop
IF "%1"=="" GOTO Continue
IF [%1]==[dump] set XMLENV_COMMANDS=dump
IF [%1]==[show] set XMLENV_COMMANDS=%XMLENV_COMMANDS% show
IF [%1]==[help] GOTO Usage
IF [%1]==[--commet] SHIFT; set XMLENV_COMMENT=%1
IF [%1]==[-c] SHIFT; set XMLENV_COMMENT=%1
   
SHIFT
GOTO Loop
:Continue
  cscript xmlenv.vbs %XMLENV_COMMANDS% comment=%XMLENV_COMMENT%
GOTO:EOF  

:Usage
echo "commands: show dump help"
echo "parameters: --comment <comment>"
cscript xmlenv.vbs help

