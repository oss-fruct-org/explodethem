// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {

    id: appWindow
    initialPage: gamePlay

    GamePlay {
        id: gamePlay
    }

    HighScores {
        id:highScores
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("About"); onClicked:{aboutDialog.open()}}
            MenuItem { text: qsTr("Help"); onClicked:{}}
            MenuItem { text: qsTr("HighScores"); onClicked:{pageStack.push(highScores)}}
            MenuItem { text: qsTr("Restart"); onClicked: gamePlay.init()}
        }
    }
    QueryDialog {
        id: aboutDialog
        icon: "images/about.png"
        titleText: qsTr("About")
        message: qsTr("Copyright © 2012 FRUCT Lab in IT-park\n of Petrozavodsk State University.\n The main developer is Artemov Nikita")
        onPrivateClicked: {
            aboutDialog.close()
        }
    }
}
