#include <QtGui/QApplication>
#include <QTranslator>
#include "qmlapplicationviewer.h"
#include <QDebug>


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication::setGraphicsSystem("raster");
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QTranslator qtTranslator;
    if(qtTranslator.load("explodethem_ru")){
        qDebug("bla");
        app->installTranslator(&qtTranslator);
    }
    qtTranslator.load("explodethem_ru");
            qDebug("bla");
            app->installTranslator(&qtTranslator);
    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
    //viewer.setMainQmlFile(QLatin1String("qml/symbian/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
