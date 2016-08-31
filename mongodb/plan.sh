pkg_name=mongodb
pkg_origin=core
pkg_version=3.2.9
pkg_maintainer="Some Maintainer <somemaintainer@example.com>"
pkg_description="High-performance, schema-free, document-oriented database"
pkg_license=('AGPL-3.0')
pkg_source=http://downloads.mongodb.org/src/${pkg_name}-src-r${pkg_version}.tar.gz
pkg_shasum=25f8817762b784ce870edbeaef14141c7561eb6d7c14cd3197370c2f9790061b
pkg_deps=(core/gcc-libs core/glibc core/openssl)
pkg_build_deps=(
  core/coreutils
  core/gcc
  core/glibc
  core/patchelf
  core/python2
  core/scons
  core/openssl
)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_dirname=${pkg_name}-r${pkg_version}

do_prepare() {
    echo ""
    echo "STARTING MONGODB BUILD PREPARATION"
    if [[ ! -r /usr/bin/basename ]]; then
        ln -sv "$(pkg_path_for coreutils)/bin/basename" /usr/bin/basename
        _clean_basename=true
    fi

    if [[ ! -r /usr/bin/tr ]]; then
        ln -sv "$(pkg_path_for coreutils)/bin/tr" /usr/bin/tr
        _clean_tr=true
    fi

    ln -sv "$(pkg_path_for openssl)/include/openssl" "$(pkg_path_for gcc)/include/openssl"
}

do_unpack() {
    echo ""
    echo "STARTING MONGODB UNPACKING"
    # Because mongodb would normally unpack into mongodb-r3.2.9 and
    # we expect the pattern mongodb-3.2.9
    mkdir -p $pkg_dirname
    tar -xzf "$pkg_filename" -C $pkg_dirname --strip-components=1
    sed -i'' -e "s#chmod 755#$(pkg_path_for coreutils)/bin/chmod 755#" $pkg_dirname/src/mongo/SConscript
    # echo "env.Append( CPATH=['$(pkg_path_for openssl)/include'] )" >> $pkg_dirname/src/mongo/SConscript
}

do_build() {
    echo ""
    echo "STARTING MONGODB BUILD"
    CC="$(pkg_path_for gcc)/bin/gcc"
    CXX="$(pkg_path_for gcc)/bin/g++"
    scons --prefix="$pkg_prefix" CFLAGS="$CFLAGS -static-libgcc -static-libstdc++" CXX="$CXX" CC="$CC" LINKFLAGS="$LDFLAGS" --release --ssl -j 4 core
}

do_check() {
    echo ""
    echo "STARTING MONGODB CHECK"
    CC="$(pkg_path_for gcc)/bin/gcc"
    CXX="$(pkg_path_for gcc)/bin/g++"
    scons --prefix="$pkg_prefix" CXX="$CXX" CC="$CC" LINKFLAGS="$LDFLAGS" --release dbtest
    python buildscripts/resmoke.py --suites=dbtest
}

do_install() {
    echo ""
    echo "STARTING MONGODB INSTALL"
    CC="$(pkg_path_for gcc)/bin/gcc"
    CXX="$(pkg_path_for gcc)/bin/g++"
    scons --prefix="$pkg_prefix" CFLAGS="$CFLAGS -static-libgcc -static-libstdc++" CXX="$CXX" CC="$CC" LINKFLAGS="$LDFLAGS" --ssl -j 4 install
}

do_end() {
    echo ""
    echo "ENDING MONGODB BUILD PROCESS"
    if [[ -n "$_clean_basename" ]]; then
        rm -fv /usr/bin/basename
    fi

    if [[ -n "$_clean_tr" ]]; then
        rm -fv /usr/bin/tr
    fi
}
