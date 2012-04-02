import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.meego 1.0
import Qt 4.7
import QtMultimediaKit 1.1
//import models 1.0

Page {
    id:gamePlay

    property int difficult: -1
    property int level
    property int exploded
    property int score
    property double rate
    property int count: 0
    property int bestScore: 0
    property int sparks
    property int shake
    property bool touched: false
    property alias input: inputName

    function init(){
        level = 1
        exploded = 0
        score = 0
        sparks = UI.START_COUNT_SPARKS
        shake = 3
        touched = false
        gameModel.startLevel(gamePlay.level)
        //gamePlay.bestScore = highScores.getBest()
        //myModel.startLevel(1);
        if(difficult === UI.HARD)
            rate = 1.3
        else if(difficult === UI.EASY)
            rate = 0.7
        else
            rate = 1
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
                            gamePlay.exploded++
                            gamePlay.score += 10*gamePlay.rate
                            if(count === gamePlay.difficult){
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
            gamePlay.sparks++
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
                    text: "bomber"
                    Keys.onReturnPressed: {
                        platformCloseSoftwareInputPanel()
                        //gameOverDialog.accept()
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
                if(gamePlay.score === 0)
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
            gameModel.model.append({t: 0, upD:UI.NULL, downD:UI.NULL, rightD:UI.NULL,leftD:UI.NULL, water: false})
    }
    onStatusChanged: {
        if(gamePlay.status === PageStatus.Activating)
            if(difficult !== -1){
                gameModel.timer.start()
            }
        else if(gamePlay.status === PageStatus.Deactivating)
            gameModel.timer.stop()
    }
    onSparksChanged: {
        statusBar.sparksDigit.number = gamePlay.sparks
    }

}
