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
BuildRequires:  libxslt
BuildRequires: docbook-xsl-stylesheets
BuildRequires:  appver >= 1.1.1

%description
multiplatformal/distribution system dumping and comparation

%prep
%setup -c -n ./%{name}-%{version}

%build
cd doc && ./update_docs.sh %{version} && cd -

%install
rm -fr %{buildroot}
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/xmlenv
install -m 755 ./xmlenv %{buildroot}%{_bindir}
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=%{version}/" %{buildroot}%{_bindir}/xmlenv && rm -f %{buildroot}%{_bindir}/xmlenv.bkp
sed -i".bkp" "1,/^VERSION_DATE=/s/^VERSION_DATE=.*/VERSION_DATE=%{APP_BUILD_DATE}/" %{buildroot}%{_bindir}/xmlenv && rm -f %{buildroot}%{_bindir}/xmlenv.bkp
install -m 755 ./compare-pkgs.xsl %{buildroot}%{_datadir}/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   %{version} %{APP_BUILD_DATE}/"  %{buildroot}%{_datadir}/xmlenv/compare-pkgs.xsl && rm -f %{buildroot}%{_datadir}/xmlenv/compare-pkgs.xsl.bkp

mkdir -p %{buildroot}%{_mandir}/man1
install -m 644 ./doc/manpages/xmlenv.1* %{buildroot}%{_mandir}/man1/
mkdir -p %{buildroot}%{_docdir}/xmlenv
install -m 644 ./README %{buildroot}%{_docdir}/xmlenv/
install -m 644 ./LICENSE.LGPL %{buildroot}%{_docdir}/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   %{version} %{APP_BUILD_DATE}/"  %{buildroot}%{_docdir}/xmlenv/README && rm -f %{buildroot}%{_docdir}/xmlenv/README.bkp

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

%{_mandir}/man1/xmlenv.1*
%dir %{_docdir}/xmlenv
%{_docdir}/xmlenv/README
%{_docdir}/xmlenv/LICENSE.LGPL
