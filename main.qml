import QtQuick 2.12
import Qt.labs.platform 1.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.5
import QtQuick.Layouts 1.14
import Qt.labs.folderlistmodel 2.12
import ModelData 1.0

ApplicationWindow{
    id:root
    width:700
    height:560
    visible:true
    title:qsTr("QML Image")
    color:'white'
    function zoomImage(img,text,index)
    {
        stackView.pop()
        stackView.push(zoomedImage)
        zoomedImage.imageSource = img.source
        zoomedImage.text = text
        zoomedImage.currentIndex = index
        zoomedImage.count = fileModel.count-1
    }
    function changeCurrentIndex(index)
    {
        var filePath = fileModel.get(index,ImageModel.SourceRole)
        var text = fileModel.get(index,ImageModel.FilePathRole)
        zoomedImage.imageSource = filePath
        zoomedImage.text = text
    }
    function makeViewChange()
    {
        stackView.pop()
        switch(comboBox.currentIndex)
        {
        case 0:
        {
            stackView.push(listViewContainer)
            break
        }
        case 1:
        {
            stackView.push(gridViewContainer)
            break
        }
        case 2:
        {
            stackView.push(pathViewContainer)
            break
        }
        }
    }
    Component{id:gridViewContainer;GridViewContainer{}}
    Component{id:listViewContainer;ListViewContainer{}}
    Component{id:pathViewContainer;PathViewContainer{}}
    ImageModel{
        id:fileModel
        data:dataForModel
        onMakeViewChange:
        {
            if (fileModel.count)
            {
                root.makeViewChange();
            }
        }
        onCountChanged:{
            if (fileModel.count===0)
            {
                root.setTheCurrentIndex(0,comboBox.currentIndex);
                stackView.push(openFileView);
            }


        }
    }

    function setTheCurrentIndex(desiredIndex,currentIndex)
    {
        if (desiredIndex!==currentIndex)
        {

            if (desiredIndex>currentIndex)
            {

                for (var i=currentIndex;i<desiredIndex;i++)
                {
                    comboBox.incrementCurrentIndex()
                }
            }
            else
            {
                for (var i=currentIndex;i>desiredIndex;i--)
                {
                    comboBox.decrementCurrentIndex()
                }
            }
        }
    }
    header: ComboBox{
        Material.background:'DeepPurple'
        id:comboBox
        model:['list','grid','path']
        ToolTip{
            text:"Choose the View"
            visible:parent.hovered
        }
        onCurrentIndexChanged: {
            if (fileModel.count!==0)
                root.makeViewChange()
        }
    }
    Page{
        width:root.width
        height:root.height
        visible:true
        id:zoomedImage
        property alias imageSource:clickingImage.source
        property alias text:zoomImageLabelText.text
        property int currentIndex
        property int count
        Rectangle{
            anchors.fill:parent
            color:'white'
            focus:true
            Image{
                id:clickingImage
                width:500
                height:400
                smooth:true
                anchors{top:parent.top;topMargin:20;horizontalCenter: parent.horizontalCenter}
                Keys.onEscapePressed: {
                    makeViewChange()
                }
            }
            Label{
                id:zoomImageLabelText
                anchors{top:clickingImage.bottom;topMargin:10;horizontalCenter: clickingImage.horizontalCenter}
                height:36
                font.pixelSize: 20
            }
            Rectangle{
                anchors{left:parent.left;top:parent.top;bottom:parent.bottom}
                width:imageLeft.width*2
                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered: {
                        imageLeft.opacity = 1
                    }
                    onExited: {
                        imageLeft.opacity = 0.3
                    }
                }
                Image{
                    source:"qrc:/arrow.png"
                    rotation:180
                    id:imageLeft
                    opacity:0.3
                    anchors{left:parent.left;bottom:parent.bottom;leftMargin:10;bottomMargin: 70}
                    Behavior on opacity{
                        NumberAnimation{duration:500}
                    }
                    MouseArea{
                        anchors.fill:parent;onReleased: {

                            if (zoomedImage.currentIndex>0)
                            {
                                zoomedImage.currentIndex--
                                changeCurrentIndex(zoomedImage.currentIndex)
                            }
                            else{
                                makeViewChange()
                            }
                        }
                    }
                }
            }
            Rectangle{
                anchors{right:parent.right;top:parent.top;bottom:parent.bottom}
                width:imageRight.width*2

                MouseArea{
                    anchors.fill:parent
                    hoverEnabled: true
                    onEntered: {
                        imageRight.opacity = 1
                    }
                    onExited: {
                        imageRight.opacity = 0.3
                    }
                }
                Image{
                    source:"qrc:/arrow.png"
                    id:imageRight
                    opacity:0.3
                    anchors{right:parent.right;bottom:parent.bottom;rightMargin:10;bottomMargin: 70}
                    Behavior on opacity{
                        NumberAnimation{duration:500}
                    }
                    MouseArea{
                        anchors.fill:parent;onReleased: {

                            if (zoomedImage.currentIndex<zoomedImage.count)
                            {
                                zoomedImage.currentIndex++
                                changeCurrentIndex(zoomedImage.currentIndex)
                            }
                            else{
                                makeViewChange()
                            }
                        }
                    }
                }
            }
        }
    }

    StackView{
        id:stackView
        anchors.fill:parent
        initialItem:openFileView
        focus:true

    }
    Component{
        id:openFileView
        Page{
            id:rootItem
            width:root.width
            height:root.height
            visible:true
            property alias size:bar.height


            StackLayout {


                width: parent.width
                currentIndex: bar.currentIndex
                Item {
                    id: openFileBar
                    Page{
                        width:root.width
                        height:root.height
                        visible:true

                        Item{
                            anchors.centerIn:parent
                            id: container
                            property color tint: "transparent"
                            width: labelText.width + 70 ; height: labelText.height + 18
                            Rectangle {
                                anchors.fill: container; color: "darkorchid"; visible: container.tint != ""
                                opacity: 0.25

                            }
                            Text { id: labelText; text:'Load Images';font.pixelSize: 15; anchors.centerIn: parent;font.capitalization: Font.MixedCase }

                            MouseArea {
                                anchors { fill: parent; leftMargin: -20; topMargin: -20; rightMargin: -20; bottomMargin: -20 }
                                hoverEnabled: true
                                onClicked: fileModel.pickingFile()
                            }
                        }
                    }
                }


            }
            TabBar {
                Component.onCompleted: {}
                z:2
                id: bar
                width: parent.width
                anchors.top:parent.top
                TabButton {
                    text: qsTr("Images")
                    id:localButton
                    background: Rectangle {
                              implicitWidth: 100
                              implicitHeight: 40
                              opacity: enabled ? 1 : 0.3
                              color: bar.currentIndex===0?'#FFF59D':"#9C27B0"

                          }
                }

            }
        }
    }



}

