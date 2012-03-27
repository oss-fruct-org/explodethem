# Add more folders to ship with the application, here
folder_01.source = qml/symbian
#folder_01.source = qml/meego
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE4483312#0x2006179f

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices
symbian:{
    ICON = explodethem.svg
    DEPLOYMENT.display_name = Explode Them
    VERSION = 1.0.1
}
# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
CONFIG += mobility
MOBILITY += sensors

CONFIG += qt-components\
 qdeclarative-boostable \

CONFIG +=  mobility
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
#            model.cpp
#HEADERS += model.h

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

!symbian:{
    OTHER_FILES += \
        qtc_packaging/debian_harmattan/rules \
        qtc_packaging/debian_harmattan/README \
        qtc_packaging/debian_harmattan/manifest.aegis \
        qtc_packaging/debian_harmattan/copyright \
        qtc_packaging/debian_harmattan/control \
        qtc_packaging/debian_harmattan/compat \
        qtc_packaging/debian_harmattan/changelog \
        qtc_packaging/debian_harmattan/explodethem.conf
}

#TRANSLATIONS = qml/meego/translations/explodethem_ru.ts

gameclassify.files += qtc_packaging/debian_harmattan/explodethem.conf
gameclassify.path = /usr/share/policy/etc/syspart.conf.d
INSTALLS += gameclassify

RESOURCES += res.qrc
symbian{

    DEFINES += IN_APP_PURCHASE
    DEFINES += IN_APP_PURCHASE_DEBUG
    DEFINES += IA_PURCHASE_TEST_MODE
    my_deployment.pkg_prerules += vendorinfo

    DEPLOYMENT += my_deployment

    vendorinfo += "%{\"FRUCT lab\"}" ":\"FRUCT lab\""
    include(./qiap/in-app-purchase.pri)
}
