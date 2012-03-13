import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.meego 1.0
import Qt 4.7
import QtMultimediaKit 1.1
//import models 1.0

Page {
    id:gamePlay

    property int level
    property int score
    property int count: 0
    property int bestScore: 0
    property int sparks
    property bool touched: false
    function init(){
        level = 1
        score = 0
        sparks = UI.START_COUNT_SPARKS
        touched = false
        gameModel.startLevel(gamePlay.level)
        //gamePlay.bestScore = highScores.getBest()
        //myModel.startLevel(1);
    }

    width: parent.width
    height: parent.height
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    SoundEffect  {
        id: bombSound
        source: "audio/bomb4.wav"
    }
    SoundEffect  {
        id: noneSound
        source: "audio/none.wav"
    }
    Image {
        id:background
        anchors.fill: parent
        source: "images/background.jpg"
    }
    GameStatusBar{
        id:statusBar
    }
    /*MyModel{
        id:myModel
    }*/

    Item{
        id: gameArea
        anchors.top: statusBar.bottom
        width: parent.width
        height: UI.ROW_COUNT*width/UI.COL_COUNT
        Grid{
            columns: UI.COL_COUNT
            rows: UI.ROW_COUNT
            spacing: UI.CELL_SPACING
            Repeater {
                id: cells
                model:gameModel.model
                delegate: Cell{
                    onClicked: {
                        if(!gameModel.isInProgress()){
                            if(gamePlay.sparks != 0 && t>0){
                                sparks--
                                if(t !== 3 && sparks === 0){
                                    gameOverDialog.open()
                                }
                                touched = true
                                gameModel.touch(index)
                                //myModel.touch(index)
                            }
                        } else {
                            if(!noneSound.playing)
                                noneSound.play()
                        }
                    }
                    onExploded: {
                        if(touched){

                            gamePlay.score++
                            if(count === UI.UP_COUNT){
                                gamePlay.sparks++
                                gamePlay.count = 0
                            } else {
                                gamePlay.count++
                            }
                        }
                    }
                }
            }
        }
        Grid{
            columns: UI.COL_COUNT
            rows: UI.ROW_COUNT
            spacing: UI.CELL_SPACING
            Repeater {
                id: miniDrops
                model:gameModel.model
                delegate: MiniDrops{}
            }
        }
    }
    /*Tutorial{
        id:tutorial
        handX: statusBar.x + 100
        handY: statusBar.y + 100
        visible: false
    }*/

    GameModel{
        id:gameModel
        onNextlevel: {
            bombSound.stop()
            gamePlay.sparks++
            nextLevelDialog.open()
        }
        onBang: {
            if(!bombSound.playing)
                bombSound.play()
        }

        onStopped: {
            bombSound.stop()
            touched = false
            if(gamePlay.sparks == 0)
                gameOverDialog.open()
        }
    }

    QueryDialog {
        id: nextLevelDialog
        icon: "images/bomb4.png"
        titleText: qsTr("Next Level")
        message: qsTr("+1 sparks")
        onPrivateClicked: {
            gameModel.startLevel(++gamePlay.level)
        }
    }

    Dialog{
        id: gameOverDialog
        signal privateClicked
        content:Column{
            Image{
                source: "images/bomb5.png"
            }

            Text{
                text:qsTr("Game Over")
                color: "white"
                font.pixelSize:UI.FONT_SIZE*1.6
            }
            Text{
                text:qsTr("Your score: ")+gamePlay.score//+"\n"+qsTr("Best score: ")+gamePlay.bestScore
                color: "white"
                font.pixelSize:UI.FONT_SIZE
            }
            Row{
                id: inputRow
                Text{
                    text:qsTr("Your name: ")
                    color: "white"
                    font.pixelSize:UI.FONT_SIZE
                }
                TextField{
                    id:inputName
                    maximumLength: 7
                    width: UI.INPUT_SIZE
                    text: "name"
                    onAccepted: {
                        platformCloseSoftwareInputPanel()
                        gameOverDialog.accept()
                    }
                }
            }
            Item {
                width: 20
                height: 25
            }

        }
        buttons: [
            Button{
                text: qsTr("Ok")
                onClicked: gameOverDialog.accept()
            }
        ]

        onPrivateClicked: {}

        onStatusChanged: {
            if(gameOverDialog.status === DialogStatus.Opening){
                if(highScores.getScore(10) < gamePlay.score){
                    inputRow.visible = true
                    inputName.focus = true
                    inputName.selectAll()
                }
                else
                    inputRow.visible = false
            }
            if(gameOverDialog.status === DialogStatus.Closing){
                var name
                inputName.focus = false
                if(gamePlay.score ===0)
                     name = "pacifist"
                else
                    name = inputName.text
                highScores.current = highScores.setScore(name, gamePlay.score)
                pageStack.push(highScores)
            }
        }
    }


    Component.onCompleted: {
        for(var i=0; i<UI.COL_COUNT*UI.ROW_COUNT; i++)
            gameModel.model.append({t: 0, upD:UI.NULL, downD:UI.NULL, rightD:UI.NULL,leftD:UI.NULL, audio: gameModel.getRandomInt(0,1)})
        init()
    }
    onStatusChanged: {
        if(gamePlay.status === PageStatus.Activating)
            gameModel.timer.start()
        else if(gamePlay.status === PageStatus.Deactivating)
            gameModel.timer.stop()
    }
    onSparksChanged: {
        statusBar.sparksDigit.number = gamePlay.sparks
    }

}
