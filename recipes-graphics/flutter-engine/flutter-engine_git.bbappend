#do_install:append() {
#    # Canonical provider for Yocto shlib resolver
#    install -d ${D}${libdir}
#    ln -sf ${datadir}/flutter/${FLUTTER_SDK_VERSION}/release/lib/libflutter_engine.so \
#           ${D}${libdir}/libflutter_engine.so
#}
# Tell Yocto that this file belongs to the main runtime package
#FILES:${PN} += "${libdir}/libflutter_engine.so"
##########


# Avoid QA warnings (because libflutter_engine.so is unversioned)
# Need symlink from /usr/lib/libflutter_engine.so,  allow unversioned .so symlink in main package iso -dev package
INSANE_SKIP:${PN} += "dev-so"


# debug profile release jit_release

PACKAGE_BEFORE_PN += "${PN}-debug ${PN}-profile ${PN}-release ${PN}-jit_release"

FILES:${PN}-debug = "${D}${FLUTTER_ENGINE_INSTALL_PREFIX}/debug/*"
FILES:${PN}-profile = "${D}${FLUTTER_ENGINE_INSTALL_PREFIX}/profile/*"
FILES:${PN}-release = "${D}${FLUTTER_ENGINE_INSTALL_PREFIX}/release/*"
FILES:${PN}-jit_release = "${D}${FLUTTER_ENGINE_INSTALL_PREFIX}/release/*"

RDEPENDS:${PN}-debug += "${PN}"
RDEPENDS:${PN}-profile += "${PN}"
RDEPENDS:${PN}-release += "${PN}"
RDEPENDS:${PN}-jit_release += "${PN}"

RCONFLICTS:${PN}-debug += "${PN}-profile ${PN}-release"
RCONFLICTS:${PN}-profile += "${PN}-debug ${PN}-release"
RCONFLICTS:${PN}-release += "${PN}-debug ${PN}-profile"
RCONFLICTS:${PN}-jit_release += "${PN}-debug ${PN}-profile ${PN}-release"




