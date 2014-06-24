#/bin/sh
#multiplatformal/distribution system dumping and comparation - http://safrm.net/projects/xmlenv
#author:  Miroslav Safr <miroslav.safr@gmail.com>
BINDIR=/usr/bin
COMPLETION_DIR=/etc/bash_completion.d
DATADIR=/usr/share
MANDIR=/usr/share/man

#root check
USERID=`id -u`
[ $USERID -eq "0" ] || {
    echo "I cannot continue, you should be root or run it with sudo!"
    exit 0
}

#automatic version
if command -v appver 1>/dev/null 2>&1; then . appver; else APP_SHORT_VERSION=NA ; APP_FULL_VERSION_TAG=NA ; APP_BUILD_DATE=`date +'%Y%m%d_%H%M'`; fi
#test
for TEST in $(  grep -r -l -h --exclude-dir=.git --exclude-dir=test "#\!/bin/sh" . )
do
		sh -n $TEST
		if  [ $? != 0 ]; then
			echo "syntax error in $TEST, exiting.." 
			exit 1
		fi
done

#update documentation
jss-docs-update ./doc 

mkdir -p -m 0755 $BINDIR
mkdir -p -m 0755 $DATADIR/xmlenv/
install -m 0777 -v ./xmlenv  $BINDIR/
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=$APP_FULL_VERSION_TAG/" $BINDIR/xmlenv && rm -f $BINDIR/xmlenv.bkp
sed -i".bkp" "1,/^VERSION_DATE=/s/^VERSION_DATE=.*/VERSION_DATE=$APP_BUILD_DATE/" $BINDIR/xmlenv && rm -f $BINDIR/xmlenv.bkp
install -m 0664 -v ./compare-pkgs.xsl $DATADIR/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   $APP_FULL_VERSION_TAG $APP_BUILD_DATE/"  $DATADIR/xmlenv/compare-pkgs.xsl && rm -f $DATADIR/xmlenv/compare-pkgs.xsl.bkp
install -m 0664 -v ./pkglist-extra-installed.xsl $DATADIR/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   $APP_FULL_VERSION_TAG $APP_BUILD_DATE/"  $DATADIR/xmlenv/pkglist-extra-installed.xsl && rm -f $DATADIR/xmlenv/pkglist-extra-installed.xsl.bkp


mkdir -p -m 0755 $COMPLETION_DIR
install -m 0777 -v ./xmlenv_completion  $COMPLETION_DIR/

MANPAGES=`find ./doc/manpages -type f`
install -d -m 755 $MANDIR/man1
install -m 644 $MANPAGES $MANDIR/man1
