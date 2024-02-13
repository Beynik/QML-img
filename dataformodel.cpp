#include "dataformodel.h"
#include <QDebug>
DataForModel::DataForModel(QObject *parent) : QObject(parent)
{

}
QVector<DataItem> DataForModel::items() const
{
    return m_item;
}


void DataForModel::appendItem(QString source, QString filePath)
{
    emit preAppendItem();
    DataItem item;
    item.source = source;
    item.filePath = filePath;
    m_item.append(item);
    emit postAppendItem();
}

bool DataForModel::setItemAt(int index, const DataItem& item)
{
    if (index<0||index>=m_item.size())
    {
        return false;
    }
    const DataItem& oldItem = m_item.at(index);
    if (oldItem.source == item.source&& oldItem.filePath == item.filePath)
    {
        return false;
    }
    m_item[index] =item;
    return true;
}
