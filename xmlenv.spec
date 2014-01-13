%define APP_BUILD_DATE %(date +'%%Y%%m%%d_%%H%%M')

Name:       xmlenv
Summary:    multiplatformal/distribution system dumping and comparation
Version:    1.0.0
Release:    1
Group:      System/Libraries
License:    LGPL v2.1
BuildArch:  noarch
URL:        http://safrm.net/projects/xmlenv
Vendor:     Miroslav Safr <miroslav.safr@gmail.com>
Source0:    %{name}-%{version}.tar.bz2
Autoreq: on
Autoreqprov: on

%description
multiplatformal/distribution system dumping and comparation

%prep
%setup -c -n ./%{name}-%{version}

%build

%install
rm -fr %{buildroot}
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/xmlenv
install -m 755 ./xmlenv %{buildroot}/usr/bin/
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=%{version}/" %{buildroot}%{_bindir}/xmlenv && rm -f %{buildroot}%{_bindir}/xmlenv.bkp
sed -i".bkp" "1,/^VERSION_DATE=/s/^VERSION_DATE=.*/VERSION_DATE=%{APP_BUILD_DATE}/" %{buildroot}%{_bindir}/xmlenv && rm -f %{buildroot}%{_bindir}/xmlenv.bkp
install -m 755 ./compare-pkgs.xsl %{buildroot}%{_datadir}/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   %{version} %{APP_BUILD_DATE}/"  %{buildroot}%{_datadir}/xmlenv/compare-pkgs.xsl && rm -f %{buildroot}%{_datadir}/xmlenv/compare-pkgs.xsl.bkp

%check
for TEST in $(  grep -r -l -h "#\!/bin/sh" . )
do
		sh -n $TEST
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


