#/bin/sh
#multiplatformal/distribution system environments dumping and comparation - http://safrm.net/projects/xmlenv
#author:  Miroslav Safr <miroslav.safr@gmail.com>
DATADIR=/usr/share

. appver-installer

#test
./efind-test.sh -ld

$MKDIR_755 $BINDIR
$MKDIR_755 $DATADIR/xmlenv
$INSTALL_755 ./xmlenv  $BINDIR
appver_update_version_and_date $BINDIR/xmlenv

$INSTALL_644 ./compare-pkgs.xsl $DATADIR/xmlenv
sed -i".bkp" "1,/Version: /s/Version:   */Version:   $APP_FULL_VERSION_TAG $APP_BUILD_DATE/"  $DATADIR/xmlenv/compare-pkgs.xsl && rm -f $DATADIR/xmlenv/compare-pkgs.xsl.bkp
$INSTALL_644 ./pkglist-extra-installed.xsl $DATADIR/xmlenv
sed -i".bkp" "1,/Version: /s/Version:   */Version:   $APP_FULL_VERSION_TAG $APP_BUILD_DATE/"  $DATADIR/xmlenv/pkglist-extra-installed.xsl && rm -f $DATADIR/xmlenv/pkglist-extra-installed.xsl.bkp

$MKDIR_755 $COMPLETION_DIR
$INSTALL_755 ./xmlenv_completion  $COMPLETION_DIR

