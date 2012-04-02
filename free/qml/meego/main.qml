// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "UIConstants.js" as UI

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
            MenuItem { text: qsTr("Help"); onClicked:{pageStack.push(gameHelp)}}
            //MenuItem { text: qsTr("More app"); onClicked:{Qt.openUrlExternally("http://store.ovi.com/publisher/FRUCT/")}}
            MenuItem { text: qsTr("HighScores"); onClicked:{pageStack.push(highScores); highScores.current = -2}}
            MenuItem { text: qsTr("Restart"); onClicked: gamePlay.init}
            MenuItem { text: qsTr("Quit"); onClicked: Qt.quit()}
        }
    }
    QueryDialog {
        id: aboutDialog
        icon: "images/about.png"
        titleText: qsTr("Explode Them 1.0")
        acceptButtonText: "Other applications"
        message: qsTr("Copyright © 2012 FRUCT Lab in IT-park\nof Petrozavodsk State University.")
        onPrivateClicked: {
            aboutDialog.close()
        }
        onAccepted: {
            Qt.openUrlExternally("http://store.ovi.com/publisher/FRUCT/")
        }
    }
    QueryDialog {
        id: fullVersion
        titleText: qsTr("Full Version")
        acceptButtonText: "Buy Full version"
        rejectButtonText: "Play Free version"
        message: qsTr("Features:\n-splash effect       \n -3 difficulty level   \n -new bomb's types")
        onPrivateClicked: {
            fullVersion.close()
        }
        onAccepted: {
            Qt.openUrlExternally("http://store.ovi.com/publisher/FRUCT/")
        }
        onRejected: {
            fullVersion.close()
        }
    }

    FontLoader{id: someFont; source: "Colleged.ttf"}
    FontLoader{id: helpFont; source: "OneDirection.ttf"}
    FontLoader{id: statusFont; source: "coolvetica.ttf"}


    /*Dialog{
        id: levelDialog
        signal privateClicked
        content:Column{

            Text{
                text:qsTr("Select difficulty level")
                x:-15
                color: "white"
                font.pixelSize:UI.FONT_SIZE
            }
            Item {
                width: 20
                height: 25
            }

        }
        buttons: [
            Column{
                Button{
                    text: qsTr("Hard")
                    onClicked: {
                        gamePlay.difficult = UI.HARD
                        levelDialog.accept()
                    }
                }Item {
                    width: 20
                    height: 25
                }Button{
                    text: qsTr("Medium")
                    onClicked: {
                        gamePlay.difficult = UI.MEDIUM
                        levelDialog.accept()
                    }
                }Item {
                    width: 20
                    height: 25
                }Button{
                    text: qsTr("Easy")
                    onClicked: {
                        gamePlay.difficult = UI.EASY
                        levelDialog.accept()
                    }
                }
            }
        ]

        onPrivateClicked: {}
        onAccepted: {
            gamePlay.init()
        }

    }
    Component.onCompleted: {
        //fullVersion.open()
        levelDialog.open()
    }*/

}
