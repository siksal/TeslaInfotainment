#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <Controllers/system.h>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<System>("systemHandler",1,0,"SystemHandler");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/TeslaInfotainment/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
