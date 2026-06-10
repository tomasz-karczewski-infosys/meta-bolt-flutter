# Apollo+1/onemw setup

Scripts in this folder are to help with LGI Apollo+1 (brcm972127) RDK7 build setup; might be useful for other platforms as an example in cases when not-yet fully RDK8 platform needs to be temporarily used for the development

# description

setup_ap1_box_container.sh

    this script should be run **inside** of the flutter-bolt-dev container; it updates bolt tool installation target folders (the default paths are not rw on this target)

setup_ap1_box_host.sh

    this script sets up the missing 'gpu layer' on the box; it should not be necessary on full RDK8 build. it should be run from the host os, like:

    devtools/onemw/setup_ap1_box_host.sh root@${STB_IP}