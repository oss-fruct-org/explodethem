// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "scores.js" as DB
import "UIConstants.js" as UI

Page{
    id:highScores
    function setScore(name,score) {
        DB.setScore(name,score)
    }
    function getBest(){
        var best
        if(highScoresModel.count > 0)
            return highScoresModel.get(0).score
        else
            return 0
    }

    orientationLock: PageOrientation.LockPortrait
    tools: ToolBarLayout {
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
        ToolIcon {
            platformIconId: "toolbar-delete"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: {
                clearScoresDialog.open()
            }
        }
    }
    Image{
        id:background
        anchors.fill: parent
        opacity: 0.8
        source: "images/background.jpg"
    }
    Text{
        id:titleHS
        text: "Scores"
        anchors{horizontalCenter: parent.horizontalCenter; top:parent.top; topMargin: 40}
        font{pixelSize: UI.FONT_SIZE*1.5; family: someFont.name}
    }
    Text {
        text: "Scores is empty"
        color:"white"
        font.pixelSize:UI.FONT_SIZE
        anchors{top:titleHS.bottom; topMargin: 200; horizontalCenter: parent.horizontalCenter}
        style: Text.RichText
        styleColor: "black"
        visible: !(highScoresModel.count > 0)
    }
    ListView {
        height:10*UI.SCORES_LIST_ITEM_HEIGHT
        anchors{top: parent.top; topMargin: (parent.height-height)/2}
        model: highScoresModel
        delegate: Item {
                width: highScores.width; height: UI.SCORES_LIST_ITEM_HEIGHT
                Text {
                    id: scoreId
                    text: (index+1)+"."
                    color:"white"
                    font.pixelSize:UI.FONT_SIZE
                    anchors{right:parent.horizontalCenter; rightMargin: 130}
                    style: Text.RichText
                    styleColor: "black"
                }
                Text {
                    anchors{left: scoreId.right; leftMargin: 15}
                    text: name;
                    font.pixelSize:UI.FONT_SIZE
                    style: Text.RichText
                    styleColor: "black"
                    color:"white"
                }
                Text {
                    text: " " + score;
                    color: "#e64b45"
                    font.pixelSize:UI.FONT_SIZE
                    anchors{left:scoreId.right; leftMargin: 200}
                    style: Text.RichText
                    styleColor: "black"
                }
        }
    }
    QueryDialog {
        id: clearScoresDialog
        icon: "images/what.png"
        acceptButtonText: qsTr("Yes")
        rejectButtonText: qsTr("No")
        message: qsTr("Do you really want to delete scores?")
        onAccepted: {
            DB.reset()
        }
    }
    ListModel {
        id:highScoresModel
    }

    Component.onCompleted: {
        DB.loadScores()
        DB.updateScoreList()
    }
}
