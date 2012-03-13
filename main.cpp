#include <QtGui/QApplication>
#include <QTranslator>
//#include <qdeclarative.h>
#include "qmlapplicationviewer.h"
//#include <QDebug>
//#include "model.h"


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    //QApplication::setGraphicsSystem("opengl");
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    /*QTranslator qtTranslator;
    if(qtTranslator.load("explodethem_ru")){
        qDebug("bla");
        app->installTranslator(&qtTranslator);
    }*/

    //qmlRegisterType<MyModel>("models", 1, 0, "MyModel");
    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
    //viewer.setMainQmlFile(QLatin1String("qml/symbian/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
