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
. appver || APP_FULL_VERSION_TAG=NA

mkdir -p -m 0755 $BINDIR
mkdir -p -m 0755 $DATADIR/xmlenv/
install -m 0777 -v ./xmlenv  $BINDIR/
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=$APP_FULL_VERSION_TAG/" $BINDIR/xmlenv && rm -f $BINDIR/xmlenv.bkp
install -m 0664 -v ./compare-pkgs.xsl $DATADIR/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   $APP_FULL_VERSION_AND_DATE/"  $DATADIR/xmlenv/compare-pkgs.xsl && rm -f $DATADIR/xmlenv/compare-pkgs.xsl.bkp

