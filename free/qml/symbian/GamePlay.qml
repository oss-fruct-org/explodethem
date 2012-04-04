import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.symbian 1.1
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

    /*SoundEffect  {
        id: bombSound
        source: "audio/bomb4.wav"
        volume: 0.3
    }*/
    SoundEffect  {
        id: noneSound
        source: "audio/bomb4.wav"
    }
    Image {
        id:background
        anchors.fill: parent
        source: "qrc:/qml/symbian/images/background.jpg"
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
                    onPressed: {
                        if(!gameModel.isInProgress()){
                            if(gamePlay.sparks != 0 && t>0){
                                sparks--
                                if(t !== 3 && sparks === 0){
                                    gameOverDialog.open()
                                }
                                touched = true
                                gameModel.touch(index)
                                privateStyle.play(Symbian.BasicItem)
                                //myModel.touch(index)
                            }
                        } else {
                            /*if(!noneSound.playing)
                                noneSound.play()*/
                        }
                    }
                    onExploded: {
                        if(touched){

                            //privateStyle.play(Symbian.BasicItem)
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
            //bombSound.stop()
            gamePlay.sparks++
            nextLevelDialog.click = true
            nextLevelDialog.open()
        }
        onBang: {
            /*if(!bombSound.playing)
                bombSound.play()*/
        }

        onStopped: {
            //bombSound.stop()
            touched = false
            if(gamePlay.sparks == 0)
                gameOverDialog.open()
        }
    }

    /*QueryDialog {
        id: nextLevelDialog
        icon: "qrc:/qml/symbian/images/bomb4.png"
        titleText: qsTr("                       Next Level")
        message: qsTr("\n                       +1 sparks\n")
        acceptButtonText: "Next"
        onAccepted: {
            gameModel.startLevel(++gamePlay.level)
        }
    }*/

    NextLevelDialog{
        id:nextLevelDialog
        property bool click: false
        onAccepted: {
            if(nextLevelDialog.click){
                nextLevelDialog.click = false
                gameModel.startLevel(++gamePlay.level)
            }
        }
    }
    GameOverDialog{
        id:gameOverDialog
    }



    Component.onCompleted: {
        for(var i=0; i<UI.COL_COUNT*UI.ROW_COUNT; i++)
            gameModel.model.append({t: 0, upD:UI.NULL, downD:UI.NULL, rightD:UI.NULL,leftD:UI.NULL})
        init()
        //gameOverDialog.open()
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
