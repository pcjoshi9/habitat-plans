pkg_origin=myorigin
pkg_name=nagios
pkg_version=4.2.0
pkg_maintainer="Some User <someuser@example.com>"
pkg_license=('Nagios Open Software License')
pkg_source=http://prdownloads.sourceforge.net/sourceforge/${pkg_name}/${pkg_name}-${pkg_version}.tar.gz
pkg_shasum=93be769854d7e64c526da29b79c92fb500a9795a82547a85ca0a9180a8f6725c
pkg_deps=(core/perl core/glibc)
pkg_build_deps=(core/gcc core/make core/shadow)
pkg_svc_user="root"
pkg_svc_group="root"

do_build() {
	#shadow pkg useradd and groupadd are not working or permission denied
	#building without useradd will configure and make but gives error saying nagios is not a user
	#building with useradd builds for a second and then exits on unseen error
	#I believe it is not a error due to privelages because this is being run as root user
	
	# useradd nagios
	# groupadd nagcmd
	# usermod -a -G nagios nagcmd
	./configure --with-command-group=nagcmd
  	make all
}
