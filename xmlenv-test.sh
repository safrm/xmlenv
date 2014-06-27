#!/bin/sh
#xml based system environments dumping and comparation - http://safrm.net/projects/xmlenv
#author: Miroslav Safr <miroslav.safr@gmail.com> 
VERSION=NA                                                                   
VERSION_DATE=NA

#support color escape characters on different terminals
alias echo="/bin/echo -e"
BASENAME=`basename $0`
usage() {
    echo "$BASENAME ${VERSION} - xml based system environments dumping and comparation "
    echo " http://safrm.net/projects/xmlenv"
    echo "Usage:$BASENAME"
    echo " options: "
    echo " --help ............................ shows command line help"
    echo " -ld ............................... use executables from local dir (default from PATH)"
    echo " -x ................................ enable sh +x (write each command to standard error)"
    echo " "
}
TCID=10
testlog() { echo "\033[33mTC$TCID:\033[00m\033[34m$TCNAME:\033[00m\033[36m$*\033[00m"; }
testfail() { echo "\033[33mTC$TCID:\033[00m\033[34m$TCNAME failed:\033[00m\033[31m$*\033[00m"; exit ${TCID:-1} ;}
teststart() { TCID=$(($TCID + 1)) ; TCNAME="$1" ; }
testok() { testlog "OK" ;}

START_TIME=`date +'%s'`
while [ $# -gt 0 ]; do
  case "$1" in
    --help) 
        usage 
        exit 
        ;;
    -ld) BINDIR="./" ;;
    -x) set -x ;;
    * )      
        echo "Argument $1 is not supported, exiting.."; usage ; exit 1 ;;
  esac
  shift
done

teststart "sh syntax check"
for SCRIPT in $(  grep -r -l -h --exclude-dir=test --exclude-dir=.git --exclude-dir=doc "#\!/bin/sh" . )
do
    echo  " $PWD/$SCRIPT "
    sh -n "$SCRIPT"
	if  [ $? -ne 0 ]; then
		testfail "syntax error $SCRIPT"
	fi
done 
testok


teststart "xsl syntax check"
for FILE in $( find . -type f -name "*.xsl" )
do
    echo  " $PWD/$FILE "
	jss-xml-validator -ext xsl $FILE
	if  [ $? -ne 0 ]; then
		testfail "syntax error $SCRIPT"
	fi
done 
testok

echo "tests finished OK"
ELAPSED_TIME=$((`date +'%s'` - $START_TIME))
echo "$BASENAME checked \033[42m$(($TCID - 10)) tests sets \033[0m, took:$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) s"

