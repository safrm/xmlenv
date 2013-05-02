%define buildroot %{_topdir}/%{name}-%{version}-root
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
BuildRoot: %{buildroot}

%description
multiplatformal/distribution system dumping and comparation

%prep
%setup -c -n ./%{name}-%{version}
# >> setup
# << setup

%build
# >> build pre
#qmake install_prefix=/usr
# << build pre
#make %{?jobs:-j%jobs}

# >> build post
# << build post

%install
rm -fr $RPM_BUILD_ROOT
# >> install pre
export INSTALL_ROOT=$RPM_BUILD_ROOT
# << install pre 
#make install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/xmlenv
install -m 755 ./xmlenv %{buildroot}/usr/bin/
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=%{version}/" %{buildroot}%{_bindir}/xmlenv && rm -f %{buildroot}%{_bindir}/xmlenv.bkp
sed -i".bkp" "1,/^VERSION_DATE=/s/^VERSION_DATE=.*/VERSION_DATE=%{APP_BUILD_DATE}/" %{buildroot}%{_bindir}/xmlenv && rm -f %{buildroot}%{_bindir}/xmlenv.bkp
install -m 755 ./compare-pkgs.xsl %{buildroot}%{_datadir}/xmlenv/
sed -i".bkp" "1,/Version: /s/Version:   */Version:   %{version} %{APP_BUILD_DATE}/"  %{buildroot}%{_datadir}/xmlenv/compare-pkgs.xsl && rm -f %{buildroot}%{_datadir}/xmlenv/compare-pkgs.xsl.bkp
# >> install post
# << install post

%files
%defattr(-,root,root,-)
# >> files
%{_bindir}/xmlenv
%dir %{_datadir}/xmlenv
%{_datadir}/xmlenv/compare-pkgs.xsl
# << files


