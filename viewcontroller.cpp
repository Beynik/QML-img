#include "viewcontroller.h"
#include <QDebug>

#include <QDialog>
ViewController::ViewController(QObject *parent)
    :QObject(parent),m_duration(2000)
{
    qDebug()<<"Without parameter";
    m_timer = new QTimer(parent);
    m_timer->setInterval(m_duration);
    connect(m_timer,&QTimer::timeout,this,&ViewController::timeout);
}

ViewController::ViewController(int duration, QObject* parent) : QObject(parent),m_duration(duration),m_pre(0),m_post(0)
{
    qDebug()<<"With parameter";
    m_timer = new QTimer(parent);
    m_timer->setInterval(m_duration);
    connect(m_timer,&QTimer::timeout,this,&ViewController::timeout);
    m_timer->start();
}

void ViewController::start()
{
    m_pre = 0;
    m_post = 1;
    m_timer->start();
    qDebug()<<"start";
}

void ViewController::stop()
{
    m_timer->stop();
}
void ViewController::timeout()
{
    qDebug()<<"Trigger";
    m_pre = (m_pre+1)%m_count;
    m_post = (m_pre+1)%m_count;
    emit dueTime(m_pre,m_post);
}
int ViewController::count() const
{
    return m_count;
}

void ViewController::setCount(int newCount)
{
    if (m_count == newCount)
        return;
    m_count = newCount;
    emit countChanged();
}
