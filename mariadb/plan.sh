pkg_name=mariadb
pkg_origin=myorigin
pkg_version=10.1.16
pkg_maintainer="Some Maintainer <somemaintainer@example.com"
pkg_license=('GPL-2.0')
pkg_source=https://downloads.mariadb.org/f/${pkg_name}-${pkg_version}/source/${pkg_name}-${pkg_version}.tar.gz
pkg_shasum=67cb35c62cc5d4cf48d7b614c0c7a9245a762ca23d4e588e15c616c102e64393
pkg_deps=()
pkg_build_deps=(core/coreutils core/cmake core/make core/gcc core/perl core/bison core/libaio core/zlib core/ncurses core/libbsd core/libedit core/texinfo)
pkg_svc_user="root"
pkg_svc_group="root"

do_build() {
	sed -i 's/^.*abi_check.*$/#/' CMakeLists.txt
    sed -i "s@data/test@\${INSTALL_MYSQLTESTDIR}@g" sql/CMakeLists.txt

	export CFLAGS="$CFLAGS -static-libstdc++ -static-libgcc"
	export CXXFLAGS="$CFLAGS"
	BUILD/autorun.sh
	./configure --prefix=/usr/local/mysql \
				--enable-assembler \
				--with-extra-charsets=complex \
				--enable-thread-safe-client \
				--with-big-tables \
				--with-plugin-maria \
				--with-aria-tmp-tables \
				--without-plugin-innodb_plugin \
				--with-mysqld-ldflags=-static \
				--with-client-ldflags=-static \
				--with-readline \
				--with-ssl \
				--with-plugins=max-no-ndb \
				--with-embedded-server \
				--with-libevent \
				--with-mysqld-ldflags=-all-static \
				--with-client-ldflags=-all-static \
				--with-zlib-dir=bundled \
				--enable-local-infile
	make
}

do_install() {
	make install
	rm -rf ${pkg_prefix}/mysql-test
    rm -rf ${pkg_prefix}/bin/mysql_client_test
    rm -rf ${pkg_prefix}/bin/mysql_test
}
