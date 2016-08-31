pkg_name=net-tools
pkg_distname=$pkg_name
pkg_origin=myorigin
pkg_version=1.60
pkg_maintainer="Some Maintainer <somemaintainer@example.com"
pkg_license=('GPL-2.0')
pkg_source=http://downloads.sourceforge.net/${pkg_name}/${pkg_name}-${pkg_version}.tar.bz2
pkg_shasum=7ae4dd6d44d6715f18e10559ffd270511b6e55a8900ca54fbebafe0ae6cf7d7b
pkg_deps=()
pkg_build_deps=(core/coreutils core/patch core/make core/gcc)
pkg_svc_user="root"
pkg_svc_group="root"

do_build() {
    # the patch here http://www.linuxfromscratch.org/patches/blfs/6.3/net-tools-1.60-gcc34-3.patch implemented in sed and echo
    # patch -Np1 -i net-tools-1.60-gcc34-3.patch
    #patching hostname.c file
    sed -i -e '80s/default:/default:\'$'\n((void)0);/g' hostname.c
    sed -i -e '101s/default:/default:\'$'\n((void)0);/g' hostname.c
    sed -i -e '121s/default:/default:\'$'\n((void)0);/g' hostname.c
    sed -i -e '179s/default:/default:\'$'\n((void)0);/g' hostname.c

    #patching inet_sr.c file
    sed -i -e '107s/default:/default:\'$'\n((void)0);/g' lib/inet_sr.c

    #patching mii-tool.c file
    sed -i -e '382s/$/\\n/g' mii-tool.c
    sed -i -e '383s/$/\\n/g' mii-tool.c
    sed -i -e '384s/$/\\n/g' mii-tool.c
    sed -i -e '385s/$/\\n/g' mii-tool.c
    sed -i -e '386s/$/\\n/g' mii-tool.c
    sed -i -e '387s/$/\\n/g' mii-tool.c
    sed -i -e '388s/$/\\n/g' mii-tool.c
    sed -i -e '389s/$/\\n/g' mii-tool.c
    sed -i -e '390s/$/\\n/g' mii-tool.c
    sed -i -e '391s/$/\\n/g' mii-tool.c

    # the patch here http://www.linuxfromscratch.org/patches/blfs/6.3/net-tools-1.60-kernel_headers-2.patch implemented n sed and echo
    # patch -Np1 -i net-tools-1.60-kernel_headers-2.patch
    #patching hostname.c file
    sed -i -e '44s/h"/h"\'$'\n#include <linux\/version.h>/g' hostname.c
    sed -i -e '47s/net/net\'$'\n#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 5, 0)/g' hostname.c
    sed -i -e '50s/if/if\'$'\n#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 0)/g' hostname.c
    sed -i -e '51s/)/)\'$'\n#include <linux\/dn.h>/g' hostname.c
    sed -i -e '52s/>/>\'$'\n#endif/g' hostname.c
    sed -i -e '53s/if/if\'$'\n#endif/g' hostname.c

    #patching x25_sr.c file
    sed -i -e '24s/>/>\'$'\n#include <linux\/version.h>/g' lib/x25_sr.c
    sed -i -e '80s/*\//*\/\'$'\n#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 0)/g' lib/x25_sr.c
    sed -i -e '82s/;/;\'$'\n#else/g' lib/x25_sr.c


    sed -i -e '83s/else/else\'$'\nmemcpy(\&rt.address, \&sx25.sx25_addr, sizeof(struct x25_address));/g' lib/x25_sr.c
    sed -i -e '84s/;/;\'$'\n#endif/g' lib/x25_sr.c

    OUTPUT=$(pkg_path_for coreutils)
    sed -i -e "s@#!\/usr\/bin\/env bash@#!$OUTPUT\/bin\/env bash@g" configure.sh
    yes "" | make config

    #patch to remove depreciated linux header files from config.h
    sed -i -e "s@#define HAVE_HWROSE 0@#define HAVE_HWROSE 1@g" config.h
    sed -i -e "s@#define HAVE_HWTR 1@#define HAVE_HWTR 0@g" config.h
    sed -i -e "s/#define HAVE_HWSTRIP 1/#define HAVE_HWSTRIP 0/g" config.h
    echo "#define HAVE_HWSLIP 1" >> config.h
    echo "#define HAVE_HWPPP 1" >> config.h
    echo "#define HAVE_HWTUNNEL 1" >> config.h
    echo "#define HAVE_HWAX25 1" >> config.h
    echo "#define HAVE_HWNETROM 1" >> config.h

    #patch to remove depreciated linux header files from config.make
    sed -i -e "s@HAVE_HWSTRIP=1@HAVE_HWSTRIP=0@g" config.make
    sed -i -e "s@HAVE_HWTR=1@HAVE_HWTR=0@g" config.make
    echo "HAVE_HWSLIP=1" >> config.make
    echo "HAVE_HWPPP=1" >> config.make
    echo "HAVE_HWTUNNEL=1" >> config.make

    make
    make update
}
