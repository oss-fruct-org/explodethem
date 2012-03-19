import QtQuick 1.1
import "UIConstants.js" as UI
import Qt 4.7
import QtMultimediaKit 1.1

Rectangle {
    id:cellMain

    signal clicked
    signal pressed
    signal exploded
    radius: 5
    width: (gamePlay.width / UI.COL_COUNT) - (UI.CELL_SPACING); height: width
    color: "#ffffff"

    Image {
        id: bombIcon
        source: if(t === 1){
                    return "qrc:/qml/symbian/images/bomb.png"
                } else if( t === 2) {
                    return "qrc:/qml/symbian/images/bomb-bandage.png"
                } else if(t === 3){
                    return "qrc:/qml/symbian/images/red-bomb.png"
                } else
                    return ""
        anchors.centerIn: parent
        height: /*if(t === 1){
                    return 7*parent.width/12
                } else if( t === 2) {
                    return 4*parent.width/5
                } else if(t === 3){
                    return*/ parent.width/*
                } else
                    return 0*/

        width: height

    }

    /*AnimatedImage {
        id : bombs
        source: "images/bombs.gif"
        paused: true
        //visible: false
    }*/
    /*AnimatedImage {
        id : bang;
        anchors.centerIn: parent
        source: "images/bang3.gif"
        paused: true
        currentFrame: 1
    }*/
    Image {
        id: bang
        anchors.centerIn: parent
        source: "qrc:/qml/symbian/images/bang.png"
        opacity: 0
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            cellMain.clicked()
        }
        onPressed: {
            cellMain.pressed()
        }
    }

    states: [State {
                name: "big"
                when: (t === 3)
                PropertyChanges {target: bombIcon; height: cellMain.height}
                //PropertyChanges {target: bang; currentFrame: 0}
                //PropertyChanges {target: bang; paused: true}
               // PropertyChanges {target: bombs; currentFrame: 9}
            },State {
                name: "medium"
                when: (t === 2)
                PropertyChanges {target: bombIcon; height: 4*cellMain.height/5}
                //PropertyChanges {target: bang; currentFrame: 0}
                //PropertyChanges {target: bang; paused: true}
                //PropertyChanges {target: bombs; currentFrame: 5}
            },State {
                name: "small"
                when: (t === 1)
                PropertyChanges {target: bombIcon; height: 7*cellMain.height/12}
                //PropertyChanges {target: bang; paused: true}
                //PropertyChanges {target: bang; currentFrame: 0}
                //PropertyChanges {target: bombs; currentFrame: 1}
            }, State {
                name: "none"
                when: (t === 0)
                PropertyChanges {target: bombIcon; height: 0}
                //PropertyChanges {target: bang; currentFrame: 5}
                //PropertyChanges {target: bombs; currentFrame: 0}

            }

    ]
    transitions: [
        Transition {
            //ScriptAction {script: {bang.opacity = 0.0}}
            PropertyAnimation{properties: "height, width"; duration: 300; easing.type: Easing.InQuad}
        },Transition { to: "none"
            SequentialAnimation {
                ScriptAction { script: cellMain.exploded(); }
                ScriptAction {
                    script: {
                        bang.opacity = 0.8
                    }
                }
                PropertyAnimation {
                    target: bang
                    properties: "opacity"
                    duration: 100
                    to: 0.7
                }
                ScriptAction {
                    script: {
                        bang.opacity = 0.0
                    }
                }
            }
        },Transition { from:"";to: "none"
        }

    ]
}
