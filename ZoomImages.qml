import QtQuick 2.0
import QtQuick.Controls 2.14

Page{
    width:700
    height:560
    visible:true
    id:zoomedImage
    property alias imageSource:clickingImage.source
    property alias text:zoomImageLabelText.text
    Rectangle{
        anchors.fill:parent
        color:'white'
        Image{
            id:clickingImage
            width:500
            height:400
            smooth:true
            anchors{top:parent.top;topMargin:20;horizontalCenter: parent.horizontalCenter}
        }
        Label{
            id:zoomImageLabelText
            anchors{top:clickingImage.bottom;topMargin:10;horizontalCenter: clickingImage.horizontalCenter}

            height:36
            font.pixelSize: 20
        }
        Image{
            source:"qrc:/arrow.png"
            rotation:180
            anchors{left:parent.left;bottom:parent.bottom;leftMargin:10;bottomMargin: 10}
            MouseArea{anchors.fill:parent;onClicked:{makeViewChange()}}
        }

    }
}



