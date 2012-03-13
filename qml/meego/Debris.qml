// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "UIConstants.js" as UI

Item {
    id:miniItems
    property string source:"images/mini-fire.png"
    property int velocity: UI.VELOCITY
    width: (gamePlay.width / UI.COL_COUNT) - (UI.CELL_SPACING); height: width
    Image {
        id: rightDrop
        rotation: 270
        source: parent.source
        visible: rightD === UI.NULL ? false: true
        x: rightD === UI.NULL  ? parent.width/2 - width/2: parent.width/2 + parent.width*(rightD-index) - width/2
        y: parent.height/2 - height/2
        Behavior on x {
            //enabled: rightD !== UI.NULL
            NumberAnimation { duration: UI.VELOCITY }
        }
    }

    Image {
        id: leftDrop
        rotation: 90
        source: parent.source
        visible: leftD === UI.NULL ? false: true
        x: leftD === UI.NULL ? parent.width/2 - width/2: parent.width/2 - parent.width*(index - leftD) - width/2
        y: parent.height/2 - height/2

        Behavior on x {
            //enabled: leftD !== UI.NULL
            NumberAnimation { duration: UI.VELOCITY}
        }
    }

    Image {
        id: topDrop
        rotation: 180
        source: parent.source
        visible: upD === UI.NULL ? false: true
        x: parent.width/2 - width/2
        y: upD === UI.NULL ? parent.height/2 - height/2 : parent.height/2 - parent.height*(index-upD)/UI.COL_COUNT - height/2

        Behavior on y {
            //enabled: upD !== UI.NULL
            NumberAnimation {duration: UI.VELOCITY }
        }
    }

    Image {
        id: downDrop
        source: parent.source
        visible: downD === UI.NULL ? false: true
        x: parent.width/2 - width/2
        y: downD === UI.NULL ? parent.height/2 - height/2 : parent.height/2 + parent.height*(downD-index)/UI.COL_COUNT - height/2

        Behavior on y {
            //enabled: downD !== UI.NULL
            NumberAnimation { duration: UI.VELOCITY }
        }
    }
}
