#include <QtGui/QApplication>
//#include <QTranslator>
//#include <QDebug>
//#include "model.h"
#include "qmlapplicationviewer.h"
//#include "qiap/qiap.h"
#include <QtDeclarative>


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication::setGraphicsSystem("openvg");
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    /*QTranslator qtTranslator;
    if(qtTranslator.load("explodethem_ru")){
        qDebug("bla");
        app->installTranslator(&qtTranslator);
    }*/

  // qmlRegisterType<MyModel>("models", 1, 0, "MyModel");
   // qmlRegisterType<QIap>("IAP", 1, 0, "QIap");
    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    //viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
    viewer.setMainQmlFile(QLatin1String("qml/symbian/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
