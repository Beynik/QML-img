#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QIcon>
#include <QQmlContext>
#include "imagelistmodel.h"
#include "viewcontroller.h"
int main(int argc, char *argv[])
{


#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QQuickStyle::setStyle("Material");
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<ImageListModel>("ModelData",1,0,"ImageModel");
    qmlRegisterType<ViewController>("Controller",1,0,"MyTimer");


    DataForModel dataItem;
    engine.rootContext()->setContextProperty("dataForModel",&dataItem);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
