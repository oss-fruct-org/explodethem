// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.symbian 1.1

Page {
    id:gameHelp
    orientationLock: PageOrientation.LockPortrait
    tools: ToolBarLayout {
        visible: true
        ToolButton {
            iconSource: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
    }

    Image{
        id:background
        anchors.fill: parent
        opacity: 0.8
        source: "qrc:/qml/symbian/images/background.jpg"
    }
    Text{
        id:titleHS
        text: qsTr("Help")
        anchors{horizontalCenter: parent.horizontalCenter; top:parent.top; topMargin: 40}
        font{pixelSize: UI.FONT_SIZE*1.5;family: someFont.name}
    }
    ListModel {
        id: appModel
        ListElement { name: "When you push the bomb you will spend a spark. If no sparks are avaible then game is over."; icon: "images/bomb.png" }
        ListElement { name: "If the bomb acuires a red color then next push will cause explosion. You can't push the bomb until reaction doesn't stop "; icon: "images/bomb-bandage.png" }
        ListElement { name: "You get one spark after every sixth bomb explosion and at the end of level"; icon: "images/red-bomb.png" }
        ListElement { name: "The main goal is to explode as many bombs as possible using the least amount of sparks"; icon: "images/red-bomb.png" }
    }

    Component {
        id: appDelegate
        Rectangle {
            width: 260; height: 280
            scale: PathView.iconScale
            radius: 30
            Text {
                anchors {top: parent.top; topMargin: 60; horizontalCenter: parent.horizontalCenter}
                font{pixelSize: UI.HELP_FONT_SIZE;family: helpFont.name; weight: Font.Light}
                horizontalAlignment: Text.AlignJustify
                width: parent.width-45
                wrapMode: Text.WordWrap
                text: name
                smooth: true
            }
            /*Image {
                id: myIcon
                anchors.bottom: parent.bottom
                source: icon
                smooth: true
            }*/

            MouseArea {
                anchors.fill: parent
                onClicked: view.currentIndex = index
            }
        }
    }

    /*Component {
        id: appHighlight
        Rectangle { width: 300; height: 300; color: "lightsteelblue" }
    }*/
    Rectangle{
        id:centRect
        width: parent.width; height: parent.width
        anchors{bottom: parent.bottom; bottomMargin: 100}
        opacity: 0
    }
    PathView {
        /*Keys.onRightPressed: if (!moving) { incrementCurrentIndex(); console.log(moving) }
        Keys.onLeftPressed: if (!moving) decrementCurrentIndex()*/
        id: view
        clip: true
        anchors.fill: centRect
        /*highlight: appHighlight*/
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        dragMargin: 50
        model: appModel
        delegate: appDelegate
        path: Path {
            startX: -310
            startY: 100
            PathAttribute { name: "iconScale"; value: 0.5 }
            //PathQuad { x: gamePlay.width/2; y: 150; controlX: 50; controlY: 200 }
            PathLine {x: gamePlay.width/2; y: 200}
            PathAttribute { name: "iconScale"; value: 1.0 }
            //PathQuad { x: gamePlay.width+300; y: 50; controlX: 350; controlY: 200 }
            PathLine { x: gamePlay.width+310; y: 100;}
            PathAttribute { name: "iconScale"; value: 0.5 }/*
            PathLine { x: gamePlay.width+240+gamePlay.width/2; y: 200;}
            PathAttribute { name: "iconScale"; value: 1 }*/
        }
    }
}
