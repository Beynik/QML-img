import QtQuick 2.14
import Qt.labs.folderlistmodel 1.0
import QtQuick.Controls 2.14
Page{
    objectName: "pathViewContainer"
    width:root.width
    height:root.height
    visible:true
    id:pathViewContainer

    Rectangle{
        width:240;height:200
        anchors.centerIn:parent
        PathView{
            focus:true
            id:pathView
            anchors.fill:parent

            Keys.onLeftPressed: pathView.incrementCurrentIndex()
            Keys.onRightPressed: pathView.decrementCurrentIndex()
            model:fileModel

            delegate:Column{
                opacity:PathView.isCurrentItem?1:0.1
                z:PathView.isCurrentItem?1:0
                Image{
                    id:imagePathView
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:256;height:256
                    source:model.source
                    MouseArea{anchors.fill:parent;onClicked: zoomImage(imagePathView,filePath,index)
                    }
                }
                Row{
                    leftPadding:parent.width/3
                    width:parent.width
                    Text {

                        id: pathViewItemText
                        text: filePath
                        font.pointSize: 18

                    }

                }


            }
            path:Path{
                startX:125;startY:130
                PathQuad { x: 200; y: 25; controlX: 400; controlY: 75 }
                PathQuad { x: 125; y: 130; controlX: -200; controlY: 75 }
            }
        }
    }
}

