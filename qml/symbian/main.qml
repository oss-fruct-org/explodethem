// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

PageStackWindow {

    id: appWindow
    initialPage: gamePlay

    GamePlay {
        id: gamePlay
    }

    HighScores {
        id:highScores
    }

    GameHelp{
        id:gameHelp
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolButton {
            iconSource: "toolbar-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("About"); onClicked:{aboutDialog.open()}}
            MenuItem { text: qsTr("Help"); onClicked:{pageStack.push(gameHelp)}}
            MenuItem { text: qsTr("More app"); onClicked:{Qt.openUrlExternally("http://store.ovi.com/publisher/FRUCT/")}}
            MenuItem { text: qsTr("HighScores"); onClicked:{pageStack.push(highScores); highScores.current = -2}}
            MenuItem { text: qsTr("Restart"); onClicked: gamePlay.init()}
            MenuItem { text: qsTr("Quit"); onClicked: Qt.quit()}
        }
    }
    QueryDialog {
        id: aboutDialog
        icon: "images/about.png"
        titleText: qsTr("Explode Them 1.0")
        message: qsTr("Copyright © 2012 FRUCT Lab in IT-park\nof Petrozavodsk State University.")
        /*onPrivateClicked: {
            aboutDialog.close()
        }*/
    }
    FontLoader{id: someFont; source: "Colleged.ttf"}
    FontLoader{id: helpFont; source: "OneDirection.ttf"}
    FontLoader{id: statusFont; source: "coolvetica.ttf"}
}
