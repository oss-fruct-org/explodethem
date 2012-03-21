// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "UIConstants.js" as UI

Rectangle {
    id:gameOverDialog
    signal accepted
    function open(){
        if(highScores.getScore(10) < gamePlay.score){
            inputRow.visible = true
            inputName.focus = true
            inputName.selectAll()
            inputName.openSoftwareInputPanel()
        }
        else
            inputRow.visible = false
        state = "open"
    }

    function close(){
        state = "close"
        var name
        inputName.focus = false
        if(gamePlay.score === 0)
             name = "pacifist"
        else
            name = inputName.text
        highScores.current = highScores.setScore(name, gamePlay.score)
        pageStack.push(highScores)
    }
    z:2
    anchors.fill: parent
    color: "black"
    state: "close"
    Text {
        id: gameOverText
        x:20
        anchors{top: parent.top; topMargin: 100; horizontalCenter: parent.horizontalCenter}
        color: "white"; font.pixelSize: UI.FONT_SIZE*1.8
        text: qsTr("Game Over")
    }
    Text{
        id:gameOverScore
        anchors{top:gameOverText.bottom;topMargin: 10; left: inputRow.left}
        text:qsTr("Your score: ")+gamePlay.score//+"\n"+qsTr("Best score: ")+gamePlay.bestScore
        color: "white"
        font.pixelSize:UI.FONT_SIZE
    }
    Row{
        id: inputRow
        anchors{top:gameOverScore.bottom;topMargin: 10; horizontalCenter: parent.horizontalCenter}
        Text{
            text:qsTr("Your name: ")
            color: "white"
            font.pixelSize:UI.FONT_SIZE
        }
        TextField{
            id:inputName
            maximumLength: 7
            width: UI.INPUT_SIZE
            text: "bomber"
            /*onAccepted: {
                platformCloseSoftwareInputPanel()
                gameOverDialog.accept()
            }*/
        }
    }
    Button{
        id:gameOverButton
        anchors{top:inputRow.bottom;topMargin: 10; horizontalCenter: parent.horizontalCenter}
        text: "Ok"
        width: parent.width/4
        onClicked: gameOverDialog.accepted()
    }
    Image{
        id:gameOverImage
        anchors{bottom: parent.bottom;horizontalCenter: parent.horizontalCenter}
        source: "qrc:/qml/symbian/images/bomb5.png"
    }
    onAccepted: {
        gameOverDialog.close()
    }
    states: [
        State {
            name: "open"
            PropertyChanges { target: gameOverDialog; opacity: 0.9}
            PropertyChanges { target: toolbarMenuIcon; visible: false}
            //PropertyChanges { target: gameOverImage; scale: 1}
        },
        State {
            name: "close"
            PropertyChanges { target: gameOverDialog; opacity: 0}
            //PropertyChanges { target: gameOverImage; scale: 0.8}
        }
    ]
    transitions: [
        Transition {
            NumberAnimation { properties: "opacity,scale"; duration: 300 }
        }
    ]
}
