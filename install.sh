#/bin/sh
#multiplatformal/distribution system dumping and comparation - https://github.com/safrm/xmlenv
#author:  Miroslav Safr <miroslav.safr@gmail.com>
BINDIR=/usr/bin
DATADIR=/usr/share

#root check
USERID=`id -u`
[ $USERID -eq "0" ] || { 
    echo "I cannot continue, you should be root or run it with sudo!"
    exit 0
}

#automatic version 
if [ command -v appver >/dev/null 2>&1 ]; then . appver; else APP_FULL_VERSION_TAG=NA ; APP_BUILD_DATE=`date +'%Y%m%d_%H%M'`; fi

mkdir -p -m 0755 $BINDIR
mkdir -p -m 0755 $DATADIR/xmlenv/
install -m 0777 -v ./xmlenv  $BINDIR/
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=$APP_FULL_VERSION_TAG/" $BINDIR/xmlenv && rm -f $BINDIR/xmlenv.bkp
sed -i".bkp" "1,/^VERSION_DATE=/s/^VERSION_DATE=.*/VERSION_DATE=$APP_BUILD_DATE/" $BINDIR/xmlenv && rm -f $BINDIR/xmlenv.bkp
install -m 0664 -v ./compare-pkgs.xsl $DATADIR/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   $APP_FULL_VERSION_TAG $APP_BUILD_DATE/"  $DATADIR/xmlenv/compare-pkgs.xsl && rm -f $DATADIR/xmlenv/compare-pkgs.xsl.bkp

