#!/bin/sh
#multiplatformal/distribution system dumping and comparation - https://github.com/safrm/xmlenv
#author:  Miroslav Safr <miroslav.safr@gmail.com>
#script to dump installed packages to xml file
#tested with tubuntu 10.10, Fedora 9 (CentOS)

#TODO
#yum -remove .i386 from package name
#aptitude - remoev ubuntu packaging tag from version

VERSION=0.0.1
XML_VERSIONS_FILE=./pkgversions.xml
XML_DESCRIPTIONS_FILE=./pkgdescriptions.xml
XML_HEADER_START="<?xml version=\"1.0\" encoding=\"utf-8\"?>"
XML_HEADER="<system "
PREFFERED_MANAGER="" #aptitude
MANAGERS="managers: "          #status
RIGHT_NOW=$(date +"%x %r %Z")

Init() {
#header - os type --------------------------------------------------------
if [ -r `which uname 2>/dev/null` ]; then
        OSTYPE=`uname`
        log "type=$OSTYPE";
fi
if [ "x$OSTYPE" = "x" ]
then
    echo "No system name and type detected (uname)"
else
XML_HEADER="$XML_HEADER type=\"$OSTYPE\" "
fi

#header - system name --------------------------------------------------- 
if [ -r `which lsb_release 2>/dev/null` ]; then
#if $(type -P lsb_release > /dev/null); then \
	SYSTEMNAME=`lsb_release -d | sed 's/^Description:[[:space:]]//g'`
        log "systemname=$SYSTEMNAME";
fi
if [ "x$SYSTEMNAME" = "x" ]
then
    echo "No system name detected (lsb_release)"
else
XML_HEADER="$XML_HEADER systemname=\"$SYSTEMNAME\" "
fi

#header - os info --------------------------------------------------------
if [ -r `which uname 2>/dev/null` ]; then
	OSINFO=`uname -a `
        log "info=$OSINFO";
fi
if [ "x$OSINFO" = "x" ]
then
    echo "No system name and type detected (uname)"
else
XML_HEADER="$XML_HEADER info=\"$OSINFO\" "
fi


#header - computername ----------------------------------------------------
if [ -r `which hostname 2>/dev/null` ]; then
	HOSTNAME=`hostname -f`
        log "hostname=$HOSTNAME";
fi
if [ "x$HOSTNAME" = "x" ]
then
    echo "No system name detected (hostname)"
else
XML_HEADER="$XML_HEADER hostname=\"$HOSTNAME\""
fi

#header - username ----------------------------------------------------
if $(type -P whoami > /dev/null); then \
	USERNAME=`whoami`
        log "username=$USERNAME";
fi
if [ "x$USERNAME" = "x" ]
then
    echo "No username detected (whoami)"
else
XML_HEADER="$XML_HEADER username=\"$USERNAME\""
fi

#header - preffered method ----------------------------------------------------
DPKGEXEC=`which dpkg 2>/dev/null`
if [ "x$DPKGEXEC" != "x"  ]; then
        MANAGERS=$MANAGERS"dpkg:OK "
        PREFFERED_MANAGER="dpkg"
else
        MANAGERS=$MANAGERS"dpkg:failed "
fi
APTITUDEEXEC=`which aptitude 2>/dev/null`
if [ "x$APTITUDEEXEC" != "x"  ]; then
        MANAGERS=$MANAGERS"aptitude:OK "
        PREFFERED_MANAGER="aptitude"
else
        MANAGERS=$MANAGERS"aptitude:failed "
fi
YUMEXEC=`which yum 2>/dev/null`
if [ "x$YUMEXEC" != "x"  ]; then
        MANAGERS=$MANAGERS"yum:OK "
        PREFFERED_MANAGER="yum"
else
        MANAGERS=$MANAGERS"yum:failed "
fi

if [ "x$PREFFERED_MANAGER" = "x" ]; then
	echo "not found supported package manager"
        exit 1
fi
MANAGERS=$MANAGERS"preffered=$PREFFERED_MANAGER"

if [ $cmd_show = 1 -a $group_sysinfo = 1 ]; then
        echo "type=$OSTYPE"
        echo "systemname=$SYSTEMNAME"
        echo "info=$OSINFO"
        echo "hostname=$HOSTNAME"
        echo "username=$USERNAME"
	echo $MANAGERS
fi
}



PackagesRequests() {
XML_HEADER="$XML_HEADER pkgmanager=\"$PREFFERED_MANAGER\" xmlenv=\"$VERSION\">"
if [ "$cmd_dump" = "1" ]; then
	echo $XML_HEADER_START > $XML_VERSIONS_FILE
	echo $XML_HEADER >> $XML_VERSIONS_FILE
fi
	if [ $group_envvar = 1 ]; then

			if [ $cmd_show = 1 ]; then
				env | tr -d \"\'\|\%\\  | sort -V -s -u |  awk -F= ' { print $1 "=" $2 }'
			fi
			if [ $cmd_dump = 1 ]; then
				echo "<envvars>" >> $XML_VERSIONS_FILE
				env | tr -d \"\'\|\%\\  | sort -V -s -u | awk -F= ' { print "  <envvar name=\""$1"\" value=\""$2"\" />" }' >>  $XML_VERSIONS_FILE
				echo "</envvars>" >> $XML_VERSIONS_FILE
			fi
	fi

#packages ------------------------------------------------------------------------------
if [ "x$PREFFERED_MANAGER" = "xaptitude" ]; then
        #curently only for apt
	if [ "$cmd_dump" = "1" ]; then
		if [ "$group_descr" = "1" ]; then
			echo $XML_HEADER_START > $XML_DESCRIPTIONS_FILE
			echo $XML_HEADER >> $XML_DESCRIPTIONS_FILE
			aptitude -F '%p %m %d' search '~i' --disable-columns | tr \" \' | tr -d \&\<\> | awk '{print "  <package name=\""$1"\" mainteiner=\"" $2 "\" description=\""  substr($0, index($0,$3)) "\" />" }' >> $XML_DESCRIPTIONS_FILE		
			echo "</system>" >> $XML_DESCRIPTIONS_FILE
		fi

		if [ "$group_pkgver" = "1" ]; then
			echo "<packages>" >> $XML_VERSIONS_FILE	
			aptitude -F '%p %v %p' search '~i' --disable-columns | tr \" \' | tr -d \&\<\> | awk '{print "  <package name=\""$1"\" version=\""$2"\" fullpackagename=\""$3"\"/>" }' >>  $XML_VERSIONS_FILE	
			echo "</packages>" >> $XML_VERSIONS_FILE	
		elif [ "$group_pkglist" = "1" ]; then #simple list
			echo "<packages>" >> $XML_VERSIONS_FILE	
			aptitude -F '%p' search '~i' --disable-columns | tr \" \' | tr -d \&\<\> | awk '{print "  <package name=\""$1"\"/>" }' >>  $XML_VERSIONS_FILE	
			echo "</packages>" >> $XML_VERSIONS_FILE	
		fi
	fi	

	if [ "$cmd_show" = "1" ]; then
		if [ "$group_pkgver" = "1" ]; then
			aptitude -F '%p %v %p' search '~i' --disable-columns | tr \" \' | tr -d \&\<\> | awk '{print $1 " " $2 }'
		elif [ "$group_pkglist" = "1" ]; then #simple list
			aptitude -F '%p' search '~i' --disable-columns | tr \" \' | tr -d \&\<\> | awk '{print $1}'
                fi
		if [ "$group_pkgcount" = "1" ]; then
			COUNT=`aptitude -F '%p' search '~i' --disable-columns| wc -l`
			echo "installed $COUNT packages"
		fi
	fi
fi
if [ "x$PREFFERED_MANAGER" = "xdpkg" ]; then
	if [ "$cmd_dump" = "1" ]; then
		if [ "$group_descr" = "1" ]; then
			echo $XML_HEADER_START > $XML_DESCRIPTIONS_FILE
			echo $XML_HEADER >> $XML_DESCRIPTIONS_FILE
			dpkg-query -W -f='${PackageSpec} ${Description}\n' | tr \" \' | tr -d \&\<\> | awk '/^ii/ {print "  <package name=\""$2"\" description=\""  substr($0, index($0,$4)) "\" />"  }' >> $XML_DESCRIPTIONS_FILE
			echo "</system>" >> $XML_DESCRIPTIONS_FILE
		fi
		if [ "$group_pkgver" = "1" ]; then
			echo "<packages>" >> $XML_VERSIONS_FILE	
			dpkg -l | awk '/^ii/ {print "\t<package name=\"" $2 "\" version=\""$3 "\" />"}' >>  $XML_VERSIONS_FILE
			echo "</packages>" >> $XML_VERSIONS_FILE	
		elif [ "$group_pkglist" = "1" ]; then #simple list
			echo "<packages>" >> $XML_VERSIONS_FILE	
			dpkg -l | awk '/^ii/ {print "\t<package name=\"" $2 "\" />"}' >>  $XML_VERSIONS_FILE	
			echo "</packages>" >> $XML_VERSIONS_FILE	
		fi
 	fi
	if [ "$cmd_show" = "1" ]; then
		if [ "$group_pkgver" = "1" ]; then
			dpkg -l | awk '/^ii/ {print $2, $3}'
		elif [ "$group_pkglist" = "1" ]; then #simple list
			dpkg -l | awk '/^ii/ {print $2}'
                fi
		if [ "$group_pkgcount" = "1" ]; then
			COUNT=`dpkg -l | awk '/^ii/ {print $2}'| wc -l`
 			echo "installed $COUNT packages"
		fi
	fi
fi

#rpm -qa	
#rpm -qa | while read package; do rpm -qi $package | head -n 1 | while read a b c; do echo -n "$c "; done; rpm -qi $package | head -n 2 | tail -n 1 | while read a b c; do echo $c; done; done
#yum 
if [ "x$PREFFERED_MANAGER" = "xyum" ]; then
	#packages
	if [ "$cmd_dump" = "1" ]; then
		echo "<packages>" >> $XML_VERSIONS_FILE	
		yum list installed | tr \" \' | tr -d \&\<\> | awk '{print "  <package name=\"" $1 "\" version=\""$2 "\" />" }' >>  $XML_VERSIONS_FILE	
        	echo "</packages>" >> $XML_VERSIONS_FILE	
	fi
	if [ "$cmd_show" = "1" ]; then
             yum list installed | tr \" \' | tr -d \&\<\> | awk '{print "$1 " "$2" }'
        fi

	if [ "$group_pkgcount" = "1" ]; then
		COUNT=`yum list installed| wc -l`
		echo "installed $COUNT packages"
	fi
fi

#footer
if [ "$cmd_dump" = "1" ]; then
	echo "</system>" >> $XML_VERSIONS_FILE
fi
}


log() {
    if [ $_V -eq 1 ]; then
        echo "V: $@"
    fi
}

usage() {
    echo "xmlshow ${VERSION}"
    echo " commands: "
    echo " show - shows requested info"
    echo " dump - dumps requsted info"
    echo " compare <local or http base.xml> - compares requested info"
    echo "    groups: all or empty = default"
    echo "    default"
    echo "               pkglist  installed  package list (s,d)"
    echo "       *       pkgver  installed package versions (s,d)"
    echo "               pkgver gcc   package versions of one package (s,d)"
    echo "       *       env  environment variables according file (s,d)"
    echo "       *       sys   system info (s,d)"
    echo "               pkgdescr  packages with description (d)"
    echo "       *       pkgcount  number of installed packages (s)"
    echo "               pkgver gcc>=3.0  manual comparation for one version (c)"
    echo "               env:HOME=/home/user  environment variables equal query  (c)"
    echo "               env:HOME*/home/user  environment variables contains query (c)"
    echo "               sys:system=linux    system specifications equal query (c)"
    echo "               sys:release>=\"fedora 9\"  system specifications equal or higher query (c)"

}

interactive=
filename=~/system_page.html
cmd_show=0
cmd_dump=0
group_pkglist=0
group_pkgver=0
group_sysinfo=0
group_descr=0
group_envvar=0
group_pkgcount=0
_V=0  				#verbose

while [ "$1" != "" ]; do
    case $1 in
        show )                  cmd_show=1
                                ;;
        dump )                  cmd_dump=1
                                ;;
        all )                   group_pkglist=1
				group_pkgver=1
			        group_sysinfo=1
				group_envvar=1
                                ;;
        list | pkglist )        group_pkglist=1
                                ;;
        versions | pkgver )     group_pkgver=1
                                ;;
        sysinfo | sys )         group_sysinfo=1
                                ;;
        descr | pkgdescr | descriptions )  group_descr=1 #scpecial
                                ;;
        env | envvar )          group_envvar=1
                                ;;
        count | pkgcount )      group_pkgcount=1
				;;
#        -f | --file )           shift
#                                filename=$1
#                                ;;
#        -i | --interactive )    interactive=1
#                                ;;
        help | -h | --help )     usage
                                exit
                                ;;
        -v | --verbose )       _V=1
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
#cmd_run=$(($cmd_show+$cmd_dump))
#xmlver show (means all)
if [ "$group_pkglist" = "0" -a "$group_pkgver" = "0" -a "$group_sysinfo" = "0" -a "$group_descr" = "0"  -a "$group_envvar" = "0" -a "$group_pkgcount" = "0"  ]; then
	group_pkglist=1
	group_pkgver=1
	group_sysinfo=1
        group_envvar=1
	group_pkgcount=1
fi
log "show=$cmd_show dump=$cmd_dump"
if [ $cmd_show = 1 -o  $cmd_dump = 1 ]; then
	log "running";
	Init
	if [ $group_pkglist = 1 -o $group_pkgver = 1 -o $group_envvar = 1 -o $group_pkgcount = 1 -o $group_descr = 1 ]; then
		PackagesRequests
	fi
else
	echo "wrong parameters";
	usage
fi

