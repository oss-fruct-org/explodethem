import QtQuick 1.1
import "UIConstants.js" as UI
import QtMobility.sensors 1.2
import "logic.js" as Logic
Item{
    id: gameModel

    property alias model: listModel
    property alias timer: timer
    property int count: 0
    property bool needNext: false
    property bool isMoved: false
    property int tempCount: 0
    property bool useWorker: false

    signal nextlevel
    signal scoreUp
    signal sparksUp
    signal stopped
    signal bang

    function getRandomInt(min, max){
      return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function isInProgress(){
        return timer.running
    }

    function move() {
        if(useWorker){
            var msg = {'action': 'move', 'model': listModel};
            worker.sendMessage(msg);
        } else
            Logic.move()
    }



    function touch(id){
        if(useWorker){
            var msg = {'action': 'touch', 'model': listModel, 'id': id};
            worker.sendMessage(msg);
        } else
            Logic.touch(id)
        timer.start()
    }

    function startLevel(__level){
        if(useWorker){
            var msg = {'action': 'startLevel', 'model': listModel, 'level': __level};
            worker.sendMessage(msg);
        } else
            Logic.startLevel(__level)
    }
    function test(){
        for(var i = 0;i < UI.COL_COUNT*UI.ROW_COUNT; i++){
                listModel.set(i,{t: 0, upD:1, downD:1, rightD:1,leftD:1})
        }
    }

    function goNextLevel(){
        timer.stop()
        nextlevel()
    }
    ListModel {
         id: listModel
    }

    WorkerScript {
        id: worker
        source: "checkin.js"

        onMessage:{
            if(messageObject.needNext)
                gameModel.goNextLevel()
            if(!messageObject.isMoved){
                timer.stop()
                gameModel.stopped()
            }
            if(messageObject.needBang)
                bang()
        }
    }

    Item{
        id:pseudoWorker
        signal message(bool needBang, bool needNext, bool isMoved)
        onMessage:{
            if(needNext /*&& gamePlay.difficult !== -1*/)
                gameModel.goNextLevel()
            if(!isMoved){
                timer.stop()
                gameModel.stopped()
            }
            if(needBang)
                bang()
            /*if(useWorker)
                if(splash)
                    shake--*/
        }
    }

    Timer {
        id:timer
        running: false
        interval: UI.VELOCITY; repeat: true
        onTriggered: {
            move()
        }
    }
    Connections {
        target: Qt.application
        onActiveChanged: {
            if (Qt.application.active){
            }
            else{
            }
        }
    }
    Component.onDestruction: {
       /* worker.source = ""
        worker.destroy()*/
    }
}
