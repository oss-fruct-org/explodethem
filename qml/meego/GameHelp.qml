// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.meego 1.0

Page {
    id:gameHelp
    orientationLock: PageOrientation.LockPortrait
    tools: ToolBarLayout {
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
        /*ToolIcon {
            platformIconId: "toolbar-delete"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: {
                clearScoresDialog.open()
            }
        }*/
    }

    Image{
        id:background
        anchors.fill: parent
        opacity: 0.8
        source: "images/background.jpg"
    }
    Text{
        id:titleHS
        text: "Help"
        anchors{horizontalCenter: parent.horizontalCenter; top:parent.top; topMargin: 40}
        font{pixelSize: UI.FONT_SIZE;family: someFont.name}
    }
    ListModel {
        id: appModel
        ListElement { name: "When you push on the bomb you spent spark. If sparks left off game over."; icon: "images/bomb.png" }
        ListElement { name: "If bomb is red next push do explosion. Need to explode the bomb as much as possible using as little as possible sparks "; icon: "images/bomb-bandage.png" }
        ListElement { name: "You get one spark after every sixth bombs exploded and at the end of level"; icon: "images/red-bomb.png" }
    }

    Component {
        id: appDelegate
        Rectangle {
            width: 360; height: 400
            scale: PathView.iconScale
            radius: 30
            Text {
                anchors {top: parent.top; topMargin: 30; horizontalCenter: parent.horizontalCenter}
                font.pixelSize: UI.HELP_FONT_SIZE
                horizontalAlignment: Text.AlignJustify
                width: parent.width-20
                wrapMode: Text.WordWrap
                text: name
                smooth: true
            }
            Image {
                id: myIcon
                anchors.bottom: parent.bottom
                source: icon
                smooth: true
            }

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
        anchors.bottom: parent.bottom
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
            startX: -240
            startY: 100
            PathAttribute { name: "iconScale"; value: 0.5 }
            //PathQuad { x: gamePlay.width/2; y: 150; controlX: 50; controlY: 200 }
            PathLine {x: gamePlay.width/2; y: 200}
            PathAttribute { name: "iconScale"; value: 1.0 }
            //PathQuad { x: gamePlay.width+300; y: 50; controlX: 350; controlY: 200 }
            PathLine { x: gamePlay.width+240; y: 100;}
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
    }
}
