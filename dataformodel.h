#ifndef DATAFORMODEL_H
#define DATAFORMODEL_H

#include <QObject>
struct DataItem{
    QString source;
    QString filePath;
};

class DataForModel : public QObject
{
    Q_OBJECT
public:
    explicit DataForModel(QObject *parent = nullptr);
    QVector<DataItem> items() const;
    bool setItemAt(int index, const DataItem& item);
public slots:
    void appendItem(QString source, QString filePath);
signals:
    void preAppendItem();
    void postAppendItem();
private:
    QVector<DataItem> m_item;
};

#endif // DATAFORMODEL_H
