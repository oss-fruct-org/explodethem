#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication::setGraphicsSystem("raster");
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
    //viewer.setMainQmlFile(QLatin1String("qml/symbian/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
