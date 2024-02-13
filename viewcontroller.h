#ifndef VIEWCONTROLLER_H
#define VIEWCONTROLLER_H

#include <QObject>
#include <QComboBox>
#include <QTimer>
class ViewController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)
public:
    explicit ViewController(QObject *parent = nullptr);
    explicit ViewController(int duration,QObject *parent = nullptr);
    int count() const;
    void setCount(int newCount);

public slots:
    void start();
    void stop();
    void timeout();
signals:
    void dueTime(int pre, int post);
    void countChanged();

private:
    QTimer* m_timer = nullptr;
    int m_duration;
    int m_count;
    int m_pre, m_post;
};

#endif // VIEWCONTROLLER_H
