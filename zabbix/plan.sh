pkg_name=zabbix
pkg_origin=myorigin
pkg_version=3.0.4
pkg_maintainer="Some Maintainer <somemaintainer@example.com"
pkg_license=('GPL-2.0')
pkg_source=http://downloads.sourceforge.net/${pkg_name}/${pkg_name}-${pkg_version}.tar.gz
pkg_shasum=9fa47d97843b6ca9f550d706b40ee6b35b76c5165ff32ff11ef0474f161e7700
pkg_deps=()
pkg_build_deps=(core/libiconv core/gcc core/make core/mysql)
pkg_svc_user="root"
pkg_svc_group="root"

do_build() {
	./configure --enable-server \
				--enable-agent \
				--with-mysql="$(pkg_path_for mysql)/bin/mysql_config" \
				--with-iconv-lib="$(pkg_path_for libiconv)"
	make
}

do_install() {
	make install
}
