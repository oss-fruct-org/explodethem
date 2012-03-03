import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.meego 1.0
import Qt 4.7
import QtMultimediaKit 1.1

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
        gameModel.startLevel(gamePlay.level)
        gamePlay.bestScore = highScores.getBest()
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
                                //gameModel.test()
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
                delegate: Debris{}
            }
        }
    }
    Tutorial{
        id:tutorial
        handX: statusBar.x + 100
        handY: statusBar.y + 100
        visible: false
    }

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
                text:qsTr("Your score: ")+gamePlay.score+"\n"+qsTr("Best score: ")+gamePlay.bestScore
                color: "white"
                font.pixelSize:UI.FONT_SIZE
            }
            Row{
                Text{
                    text:qsTr("Your name: ")
                    color: "white"
                    font.pixelSize:UI.FONT_SIZE
                }
                TextField{
                    id:inputName
                    maximumLength: 5
                    width: UI.INPUT_SIZE
                    text: "name"
                    Keys.onEnterPressed: gameOverDialog.accept();
                }
            }
            Item {
                width: 20
                height: 40
            }
            Item {
                id: enterKey
                Keys.onEnterPressed: gameOverDialog.accept();
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
                inputName.focus = true
                inputName.selectAll()
            }
            if(gameOverDialog.status === DialogStatus.Closing){
                inputName.focus = false
                highScores.setScore(inputName.text, gamePlay.score)
                gamePlay.init()
            }
        }
        Keys.onEnterPressed: gameOverDialog.accept();
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
