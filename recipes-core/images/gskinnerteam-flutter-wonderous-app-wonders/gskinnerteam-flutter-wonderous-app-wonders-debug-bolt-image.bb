SUMMARY = "Flutter demo wonderous app"
#see https://github.com/meta-flutter/meta-flutter/blob/kirkstone/meta-flutter-apps/recipes-graphics/flutter-apps/third-party/gskinnerteam-flutter-wonderous-app-wonders_2.2.4.bb
#see https://github.com/gskinnerTeam/flutter-wonderous-app requires mouse for full functionality
inherit base-bolt-image

# XXX installing baselayer rdke profile1, it's content is defined in this packagegroup
IMAGE_INSTALL:remove = "packagegroup-app-base-layer-rdke-profile1"

IMAGE_INSTALL:append = " gskinnerteam-flutter-wonderous-app-wonders-debug"

