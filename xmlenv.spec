%define buildroot %{_topdir}/%{name}-%{version}-root

Name:       xmlenv
Summary:    multiplatformal/distribution system dumping and comparation
Version:    1.0.0
Release:    1
Group:      System/Libraries
License:    LGPL v2.1
BuildArch:  noarch
URL:        https://github.com/safrm/xmlenv
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
install -m 755 ./compare-pkgs.xsl %{buildroot}%{_datadir}/xmlenv/

# >> install post
# << install post






%files
%defattr(-,root,root,-)
# >> files
%{_bindir}/xmlenv
%{_datadir}/xmlenv/compare-pkgs.xsl
# << files


