import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0
import QtQuick.Controls 2.14
Page{
    objectName: "gridViewContainer"
    width:root.width
    height:root.height
    visible:true
    Rectangle{
        id:gridViewContainer
        //property var listModel:folderModel
        width:parent.width
        height:parent.height
        clip:true
        GridView{
            id:gridView
            ScrollBar.vertical: ScrollBar{
                anchors{right:parent.right;bottom:parent.bottom;top:parent.top}
                parent:gridView
            }
            remove: Transition {
                      ParallelAnimation {
                          NumberAnimation { property: "opacity"; to: 0; duration: 1000 }
                          NumberAnimation { properties: "x"; to: x-100; duration: 2000 }
                      }
                  }
            removeDisplaced: Transition {
                      NumberAnimation { properties: "x,y"; duration: 1000 }
                  }
            anchors.fill:parent
            anchors{
                leftMargin:70
                rightMargin:20
            }
            cellWidth:200
            cellHeight:200
            model:fileModel
            delegate:Item{
                width:gridView.width;height:140;
                Image{
                    id:gridViewItemImage
                    fillMode:Image.PreserveAspectCrop
                    x:20;y:20
                    width:128;height:128
                    source:model.source
                }
                Text{
                    clip:true
                    id:textGridView
                    y:5
                    anchors{
                        top:gridViewItemImage.bottom
                        topMargin:20
                        horizontalCenter: gridViewItemImage.horizontalCenter
                    }
                    text:filePath
                    font.pointSize: 15
                }


                MouseArea{anchors.fill:parent;onClicked:zoomImage(gridViewItemImage,filePath,index)}

            }

        }
    }
}
