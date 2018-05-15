%define mydir   test_1
%define myname  app_test_1

Name:           test_3
Version:        0.0.1
Release:        1%{?dist}

Summary:        C++ app.
Group:          Development/Libraries
License:        MIT
URL:            https://github.com/marekuj/pjs

Source0:        %{name}-%{version}.tar.gz
Vendor:         MK
Packager:       Marek Kieruzel

BuildArch:      x86_64
BuildRequires:  gcc gcc-c++ make

%description
Test app

%package devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description devel
Development files for package %{name}

%prep
%setup -q -c %{name}-%{version}

%build
%{__make} %{mydir} 

%install
mkdir -p $RPM_BUILD_ROOT/app/tests/bin
mkdir -p $RPM_BUILD_ROOT/usr/include/tests/%{mydir}
cp %{mydir}/bin/%{myname} $RPM_BUILD_ROOT/app/tests/bin/%{myname}

%clean
rm -rf $RPM_BUILD_ROOT

%files 
%defattr(644,root,root,755)
%attr(755, root, root) /app/tests/bin/%{myname}

%files devel
%defattr(644,root,root,755)
%dir /usr/include/tests/%{mydir}

%post
/sbin/ldconfig

%postun
/sbin/ldconfig
