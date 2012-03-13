// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "scores.js" as DB
import "UIConstants.js" as UI

Page{
    id:highScores

    property int current: -1

    function setScore(name,score) {
        return DB.setScore(name,score)
    }
    function getBest(){
        if(highScoresModel.count > 0)
            return highScoresModel.get(0).score
        else
            return 0
    }
    function getScore(id){
        if(highScoresModel.count < id)
            return 0
        else
            return highScoresModel.get(id-1).score
    }

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {

        ToolButton {
            iconSource: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            visible: highScores.current === -2
            onClicked: pageStack.pop()
        }
        ToolButton {
            iconSource: "toolbar-delete"
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
        text: qsTr("HighScores")
        anchors{horizontalCenter: parent.horizontalCenter; top:parent.top; topMargin: 40}
        font{pixelSize: UI.FONT_SIZE*1.5; family: someFont.name}
    }
    Text {
        text: qsTr("Scores is empty")
        color:"white"
        font.pixelSize:UI.FONT_SIZE
        anchors{top:titleHS.bottom; topMargin: 200; horizontalCenter: parent.horizontalCenter}
        style: Text.RichText
        styleColor: "black"
        visible: !(highScoresModel.count > 0)
    }
    Component {
        id: highlight
        /*Image {
            sourceSize.width: 60
            source: "images/arrow.png"
            opacity: highScores.current !== -2 ? 0.8 : 0
            y: highScores.current !== -1 ? list.currentItem.y+5 : highScores.height
            x:30
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }*/
        Rectangle {
            width: highScores.width;
            color: "lightsteelblue"; radius: 5
            opacity: 0.7
            y: highScores.current < 0? highScores.y : list.currentItem.y
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }
    ListView {
        id:list
        height:10*UI.SCORES_LIST_ITEM_HEIGHT
        anchors{top: parent.top; topMargin: (parent.height-height)/2}
        model: highScoresModel
        delegate: Item {
                id:wrapper
                width: highScores.width; height: UI.SCORES_LIST_ITEM_HEIGHT
                Text {
                    id: scoreId
                    text: (index+1)+"."
                    color:id === highScores.current ? "red" : "white"
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
        highlight: highlight
        //highlightFollowsCurrentItem: false
    }

    Button{
        text: qsTr("Play again")
        visible: highScores.current !== -2
        anchors{top: list.bottom; topMargin: 20; horizontalCenter: parent.horizontalCenter}
        onClicked: {
            pageStack.pop()
            gamePlay.init()
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
    onStatusChanged: {
        if(highScores.status === PageStatus.Activating){
            if(highScores.current !== -1){
                for(var i=0;i<highScoresModel.count;i++){
                    if(highScoresModel.get(i).id.toString() === highScores.current.toString()){
                        list.currentIndex = i
                    }
                }
            } else {
               list.currentIndex = -1
            }
        }

        if(highScores.status === PageStatus.Inactivating){
            highlight.y = parent.height
        }
    }
}
