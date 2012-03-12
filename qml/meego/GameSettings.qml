import QtQuick 1.1
import com.nokia.meego 1.0
import "scores.js" as DB
import "UIConstants.js" as UI

Page{
    id:settings



    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {

        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            visible: highScores.current === -2
            onClicked: pageStack.pop()
        }
    }
    Image{
        id:background
        anchors.fill: parent
        opacity: 0.8
        source: "images/background.jpg"
    }
}
