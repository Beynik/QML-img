import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0
import QtQuick.Controls 2.14
Page{
    objectName: "listViewContainer"
    width:root.width
    height:root.height
    visible:true
    Rectangle{
        id:listViewContainer
        height:parent.height;width:parent.width
        clip:true

        ListView{

            id:listView
            ScrollBar.vertical: ScrollBar{
                hoverEnabled:true
                active:hovered|pressed
                anchors{right:parent.right;bottom:parent.bottom;top:parent.top}
                parent:listView
                policy:ScrollBar.AlwaysOn
                snapMode:ScrollBar.SnapOnRelease
            }
            anchors.fill:parent
            anchors{
                leftMargin:20
                rightMargin:20
            }
            model:fileModel
            delegate:SwipeDelegate {
                id: swipeDelegate
                Text{
                    text: filePath
                    anchors{
                        left:listViewItemImage.right
                        leftMargin:30
                        verticalCenter: parent.verticalCenter
                    }

                   font.pointSize: 20
                }
                Image{
                    anchors{left:parent.left;verticalCenter: parent.verticalCenter}
                    source:model.source
                    width:128;height:128
                    anchors{left:parent.left;leftMargin:20}
                    id:listViewItemImage
                    MouseArea{
                        anchors.fill:parent;
                        onClicked: {
                            zoomImage(listViewItemImage,filePath,index)
                        }
                    }
                }
                width: parent.width
                height:160
            }
        }
    }
}


