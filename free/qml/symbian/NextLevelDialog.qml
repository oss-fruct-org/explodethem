// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "UIConstants.js" as UI

Rectangle {
    id:nextLevelDialog


    signal accepted

    function open(){
        state = "open"
    }

    function close(){
        state = "close"
    }
    z:40
    anchors.fill: parent
    color: "black"
    state: "close"

    Image{
        id:nextLevelImage
        anchors.centerIn: parent
        source: "qrc:/qml/symbian/images/bomb4.png"
    }
    Text {
        id: nextLevelText
        anchors{top: nextLevelImage.bottom; topMargin: -40; horizontalCenter: parent.horizontalCenter}
        color: "white"; font.pixelSize: UI.FONT_SIZE*1.5
        text: qsTr("Next Level")
    }
    Text {
        anchors{top: nextLevelText.bottom; topMargin: 20; horizontalCenter: parent.horizontalCenter}
        color: "white"; font.pixelSize: UI.HELP_FONT_SIZE
        text: qsTr("+1 sparks")
    }
    MouseArea{
        anchors.fill: parent
        onClicked: nextLevelDialog.accepted()
    }

    onAccepted: {
        nextLevelDialog.close()
    }
    states: [
        State {
            name: "open"
            PropertyChanges { target: nextLevelDialog; opacity: 0.9}
            PropertyChanges { target: nextLevelImage; scale: 1}
            PropertyChanges { target: toolbarMenuIcon; visible: false}
        },
        State {
            name: "close"
            PropertyChanges { target: nextLevelDialog; opacity: 0}
            PropertyChanges { target: nextLevelImage; scale: 0.8}
        }
    ]
    transitions: [
        Transition {
            NumberAnimation { properties: "opacity,scale"; duration: 300 }
        }
    ]
}
