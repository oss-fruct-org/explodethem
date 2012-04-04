// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.particles 1.0
import "UIConstants.js" as UI

Item {
    id:miniItems
    property string source:"images/mini-fire.png"
    property int velocity: UI.VELOCITY
    width: (gamePlay.width / UI.COL_COUNT) - (UI.CELL_SPACING); height: width

    Repeater{
        anchors.fill: parent
        model:4
        Particles {
            id:rep
            property int type:0
            x:miniItems.width/2
            y:x
            //visible:  rightD !==UI.NUll /*|| (index === 1 && upD !==UI.NUll) ||
                     //(index === 2 && leftD !==UI.NUll) || (index === 3 && downD !==UI.NUll)*/
            width: 1;height: 1
            source: "images/mini-fire.png"
            lifeSpan: 3000
            count: -1
            angle: index*90
            velocity: 170

            states: [State {
                        name: "bang"
                        when: (t === 0)
                    },State {
                        name: "wait"
                        when: (t > 0 ||rightD === NULL)
                        PropertyChanges { target: rep; visible: false }
                    },State {
                        name: "bla"
                        when: (rightD === NULL)
                        PropertyChanges { target: rep; visible: false }
                    }

            ]
            transitions: [
                Transition {
                    from:"wait"; to:"bang"
                    ScriptAction {
                        script: {
                            rep.count = 0
                            rep.burst(1)
                        }
                    }
                },Transition {
                    from: "bang";to:"bla"
                    ScriptAction {
                        script: {
                            console.log("bla")
                        }
                    }
                }

            ]
        }
    }

}
