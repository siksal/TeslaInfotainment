#include "system.h"
#include <QDateTime>

System::System(QObject *parent)
    : QObject{parent}
    , m_carLocked(true)
    , m_outdoorTemp(64)
    , m_userName("Lake")
{
    m_currentTimeTimer = new QTimer(this);
    m_currentTimeTimer->setInterval(500);
    m_currentTimeTimer->setSingleShot(true);
//    connect(m_currentTimeTimer, &QTimer::timeout, this, QOverload<>::of(&System::currentTimeTimerTimeout));
    connect(m_currentTimeTimer, &QTimer::timeout, this, &System::currentTimeTimerTimeout);
    currentTimeTimerTimeout();
}

bool System::carLocked() const
{
    return m_carLocked;
}

void System::setCarLocked(bool carLocked)
{
    if (m_carLocked == carLocked)
        return;
    m_carLocked = carLocked;
    emit carLockedChanged(m_carLocked);
}

int System::outdoorTemp() const
{
    return m_outdoorTemp;
}

void System::setOutdoorTemp(int outdoorTemp)
{
    if (m_outdoorTemp == outdoorTemp)
        return;
    m_outdoorTemp = outdoorTemp;
    emit outdoorTempChanged(m_outdoorTemp);
}

QString System::userName() const
{
    return m_userName;
}

void System::setUserName(const QString userName)
{
    if (m_userName == userName)
        return;
    m_userName = userName;
    emit userNameChanged(m_userName);
}

QString System::currentTime() const
{
    return m_currentTime;
}

void System::setCurrentTime(const QString currentTime)
{
    if (m_currentTime == currentTime)
        return;
    m_currentTime = currentTime;
    emit currentTimeChanged(m_currentTime);
}

void System::currentTimeTimerTimeout()
{
    QDateTime dateTime;
    QString currentTime = dateTime.currentDateTime().toString("h:m ap");
    setCurrentTime(currentTime);
    m_currentTimeTimer->start();
}
