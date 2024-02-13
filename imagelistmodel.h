#ifndef IMAGELISTMODEL_H
#define IMAGELISTMODEL_H

#include <QAbstractListModel>
#include "dataformodel.h"
class ImageListModel : public QAbstractListModel
{
    Q_OBJECT


    Q_PROPERTY(DataForModel *data READ data WRITE setData)
    Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)
public:
    enum DataType{SourceRole=Qt::UserRole,FilePathRole=Qt::UserRole+1};
    Q_ENUM(DataType)
    explicit ImageListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;
    DataForModel* data() const;
    void setData(DataForModel* data);
    virtual QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE int count() const;
    Q_INVOKABLE QString get(int index,int role) const;
    void setCount(int newCount);

signals:
    void makeViewChange();
    void countChanged();

public slots:
    void pickingFile();
    void appendPics(QString path);
    void emitMakeViewChange();
private:
    DataForModel* m_data;
    int m_count;
    QString test;
};

#endif // IMAGELISTMODEL_H
