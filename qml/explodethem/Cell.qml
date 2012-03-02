import QtQuick 1.1
import "UIConstants.js" as UI
import Qt 4.7
import QtMultimediaKit 1.1

Rectangle {
    id:cellMain

    signal clicked
    signal exploded
    radius: 5
    width: (gamePlay.width / UI.COL_COUNT) - (UI.CELL_SPACING); height: width
    color: "#ffffff"

    SoundEffect  {
        id: bangSound
        source: "audio/bomb.wav"
        volume: 0.5
    }
    Image {
        id: bombIcon
        source: if(t === 1){
                    return "images/bomb.png"
                } else if( t === 2) {
                    return "images/bomb-bandage.png"
                } else if(t === 3){
                    return "images/red-bomb.png"
                } else
                    return ""
        anchors.centerIn: parent
        height: if(t === 1){
                    return 7*parent.width/12
                } else if( t === 2) {
                    return 4*parent.width/5
                } else if(t === 3){
                    return parent.width
                } else
                    return 0

        width: height

    }

    AnimatedImage {
        id : bang;
        source: "images/bang.gif"
        opacity: 0
        //paused: true
        //visible: false
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            cellMain.clicked()
        }
    }

    states: [State {
                name: "big"
                when: (t === 3)
                PropertyChanges {target: bombIcon; height: cellMain.height}
                PropertyChanges {target: bang; paused: true}
                PropertyChanges {target: bang; currentFrame: 0}
            },State {
                name: "medium"
                when: (t === 2)
                PropertyChanges {target: bombIcon; height: 4*cellMain.height/5}
                PropertyChanges {target: bang; paused: true}
                PropertyChanges {target: bang; currentFrame: 0}
            },State {
                name: "small"
                when: (t === 1)
                PropertyChanges {target: bombIcon; height: 7*cellMain.height/12}
                PropertyChanges {target: bang; paused: true}
                PropertyChanges {target: bang; currentFrame: 0}
            }, State {
                name: "none"
                when: (t === 0)
                PropertyChanges {target: bombIcon; height: 0}
                PropertyChanges {target: bang; currentFrame: 7}

            }

    ]
    transitions: [
        Transition {
            ScriptAction {script: {bang.opacity = 0.0}}
            PropertyAnimation{properties: "height,width"; duration: 500; easing.type: Easing.InQuad}
        },Transition {
            to: "none"
            SequentialAnimation {
                //ScriptAction { script: bangSound.play(); }
                ScriptAction { script: cellMain.exploded(); }
                ScriptAction {
                    script: {
                        bang.opacity = 1.0
                    }
                }
                PropertyAnimation {
                    target: bang
                    properties: "currentFrame"
                    duration: 400
                }
                ScriptAction {
                    script: {
                        bang.opacity = 0.0
                    }
                }
            }
        }
    ]
}
