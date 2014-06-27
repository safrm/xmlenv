%define APP_BUILD_DATE %(date +'%%Y%%m%%d_%%H%%M')

Name:       xmlenv
Summary:    multiplatformal/distribution system environments dumping and comparation
Version:    1.0.0
Release:    1
Group:      Development/Tools
License:    LGPL v2.1
BuildArch:  noarch
URL:        http://safrm.net/projects/xmlenv
Vendor:     Miroslav Safr <miroslav.safr@gmail.com>
Source0:    %{name}-%{version}.tar.bz2
Autoreq: on
Autoreqprov: on
BuildRequires:  appver >= 1.1.1
BuildRequires: jenkins-support-scripts >= 1.2.4

%description
multiplatformal/distribution system environments dumping and comparation

%prep
%setup -c -n ./%{name}-%{version}

%build
jss-docs-update ./doc -sv %{version} 

%install
rm -fr %{buildroot}
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/xmlenv
install -m 755 ./xmlenv %{buildroot}%{_bindir}
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=%{version}/" %{buildroot}%{_bindir}/xmlenv && rm -f %{buildroot}%{_bindir}/xmlenv.bkp
sed -i".bkp" "1,/^VERSION_DATE=/s/^VERSION_DATE=.*/VERSION_DATE=%{APP_BUILD_DATE}/" %{buildroot}%{_bindir}/xmlenv && rm -f %{buildroot}%{_bindir}/xmlenv.bkp
install -m 644 ./compare-pkgs.xsl %{buildroot}%{_datadir}/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   %{version} %{APP_BUILD_DATE}/"  %{buildroot}%{_datadir}/xmlenv/compare-pkgs.xsl && rm -f %{buildroot}%{_datadir}/xmlenv/compare-pkgs.xsl.bkp
install -m 644 ./pkglist-extra-installed.xsl %{buildroot}%{_datadir}/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   %{version} %{APP_BUILD_DATE}/"  %{buildroot}%{_datadir}/xmlenv/pkglist-extra-installed.xsl && rm -f %{buildroot}%{_datadir}/xmlenv/pkglist-extra-installed.xsl.bkp

mkdir -p -m 0755 %{buildroot}%{_sysconfdir}/bash_completion.d
install -m 0777 -v ./xmlenv_completion %{buildroot}%{_sysconfdir}/bash_completion.d

mkdir -p %{buildroot}%{_mandir}/man1
install -m 644 ./doc/manpages/xmlenv.1* %{buildroot}%{_mandir}/man1/

%clean
rm -fr %{buildroot}

%check
for TEST in $(  grep -r -l -h "#\!/bin/sh" . )
do
		sh -n "$TEST"
		if  [ $? != 0 ]; then
			echo "syntax error in $TEST, exiting.." 
			exit 1
		fi
done 

%files
%defattr(-,root,root,-)
%{_bindir}/xmlenv
%dir %{_datadir}/xmlenv
%{_datadir}/xmlenv/compare-pkgs.xsl
%{_datadir}/xmlenv/pkglist-extra-installed.xsl

%{_sysconfdir}/bash_completion.d/xmlenv_completion

%{_mandir}/man1/xmlenv.1*

