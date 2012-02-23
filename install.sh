#/bin/sh
#multiplatformal/distribution system dumping and comparation - https://github.com/safrm/xmlenv
#author:  Miroslav Safr <miroslav.safr@gmail.com>
BINDIR=/usr/local/bin
DATADIR=/usr/local/share

sudo mkdir -p -m 0755 $BINDIR
sudo mkdir -p -m 0755 $DATADIR/xmlenv/
sudo install -m 0777 -v ./xmlenv  $BINDIR/
sudo install -m 0664 -v ./compare-pkgs.xsl $DATADIR/xmlenv/
