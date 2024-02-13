
#include "imagelistmodel.h"
#include "QFileDialog"
#include <QDir>
#include <QDebug>
#include <QUrl>
ImageListModel::ImageListModel(QObject *parent)
    : QAbstractListModel(parent),m_data(nullptr)
{
}

int ImageListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()||!m_data)
        return 0;
    return m_data->items().size();
}

QVariant ImageListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()||!m_data)
        return QVariant();
    const DataItem& item = m_data->items().at(index.row());
    switch(role)
    {
        case SourceRole:
        {

            return item.source;
        }
        case FilePathRole:
        {

            return item.filePath;
        }
    }


    return QVariant();
}

bool ImageListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!m_data)
    {
        return false;
    }
    DataItem item = m_data->items().at(index.row());
    switch(role)
    {
        case SourceRole:
        {
            item.source = value.toString();
            break;
        }
        case FilePathRole:
        {
            item.filePath = value.toString();
            break;
        }
    }
    if(m_data->setItemAt(index.row(),item)) {

        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags ImageListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

DataForModel* ImageListModel::data() const
{
    return m_data;
}

void ImageListModel::setData(DataForModel* data)
{
    beginResetModel();
    if (m_data)
    {
        m_data->disconnect(this);
    }
    m_data = data;
    if(m_data)
    {
        connect(m_data,&DataForModel::preAppendItem,this,[=](){
            const int& index = m_data->items().size();
            beginInsertRows(QModelIndex(),index,index);
        });
        connect(m_data,&DataForModel::postAppendItem,this,[=](){

            endInsertRows();
            emit countChanged();
        });
    }
    endResetModel();
}

QHash<int, QByteArray> ImageListModel::roleNames() const
{
    QHash<int,QByteArray> roles;
    roles[SourceRole] = "source";
    roles[FilePathRole] = "filePath";
    return roles;
}

int ImageListModel::count() const
{
    if (m_data)
    {
        return m_data->items().count();
    }
    return 0;
}

QString ImageListModel::get(int index,int role) const
{
    if (index>=0&&index<m_data->items().size())
    {

        switch(role){
        case SourceRole:
            return m_data->items().at(index).source;
        case FilePathRole:
            return m_data->items().at(index).filePath;
        }

    }
    return "";
}

void ImageListModel::pickingFile()
{
    QStringList names = QFileDialog::getOpenFileNames(nullptr,"Choose images",
                                                      QDir::fromNativeSeparators(""),
                                                      tr("Images (*.png *.jpg)"));

    for (int i=0;i<names.count();i++)
    {
        QString source = names[i];
        QString filePath = source.right(source.size()-1-source.lastIndexOf('/'));
        source = "file:///"+source;
        m_data->appendItem(source,filePath);
    }
    emit makeViewChange();
}

void ImageListModel::appendPics(QString path)
{
    QUrl url = QUrl(path);
    m_data->appendItem(path,QString("Pic %1").arg(count()+1));
}

void ImageListModel::emitMakeViewChange()
{

    emit makeViewChange();
}



void ImageListModel::setCount(int newCount)
{

    if (m_count == newCount)
        return;
    m_count = newCount;
    emit countChanged();
}
