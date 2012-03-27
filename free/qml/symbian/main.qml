import QtQuick 1.1
import com.nokia.symbian 1.1
import IAP 1.0
import Qt 4.7
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

    BuyPage{
        id:buyPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolButton {
            id: toolbarMenuIcon
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
            MenuItem { text: qsTr("Buy"); onClicked: {pageStack.push(buyPage)}}
            MenuItem { text: qsTr("Help"); onClicked:{pageStack.push(gameHelp)}}
            //MenuItem { text: qsTr("More app"); onClicked:{Qt.openUrlExternally("http://store.ovi.com/publisher/FRUCT/")}}
            MenuItem { text: qsTr("HighScores"); onClicked:{pageStack.push(highScores); highScores.current = -2}}
            MenuItem { text: qsTr("Restart"); onClicked: gamePlay.init()}
            MenuItem { text: qsTr("Quit"); onClicked: Qt.quit()}
        }
    }
    QueryDialog {
        id: aboutDialog
        icon: "qrc:/qml/symbian/images/about.png"
        titleText: qsTr("Explode Them 1.0")
        acceptButtonText: "Other apps"
        rejectButtonText: "Close"
        message: qsTr("Copyright © 2012 FRUCT Lab in IT-park\nof Petrozavodsk State University.")

        onAccepted: {
            Qt.openUrlExternally("http://store.ovi.com/publisher/FRUCT/")
            aboutDialog.close()
        }
        onRejected: {
            aboutDialog.close()
        }
    }

    QtObject{
        id: gameMode
        property int type: UI.FREE
    }

    QIap {
        id:iap_manager
        onPurchaseCompleted: {
           console.log("onPurchaseCompleted")
           console.log(">"+status)
           console.log(">"+productID)

            if( status==="OK") {
               if( productID === "813279" ) {
                   console.log(iap_manager.getDRMFileContent(productID,"video.csv"));
               } else
               if( productID === "821073" ) {
                   console.log(iap_manager.getDRMFileContent(productID,"photo.txt"));
               }
           }
       }
    }

    FontLoader{id: someFont; source: "Colleged.ttf"}
    FontLoader{id: helpFont; source: "OneDirection.ttf"}
    FontLoader{id: statusFont; source: "coolvetica.ttf"}

    Component.onCompleted: {
        //console.log(iap_manager.isPurchased("SBK Photo"))
    }
}
