import QtQuick 1.1
import "UIConstants.js" as UI
import QtMobility.sensors 1.2
Item{
    id: gameModel

    property alias model: listModel
    property alias timer: timer
    property bool __inProgress: false
    property int count: 0
    property bool needNext: false
    property bool isMoved: false
    property int tempCount: 0

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
        var msg = {'action': 'move', 'model': listModel};
        if(worker !== null)
            worker.sendMessage(msg);
    }



    function touch(id){
        var msg = {'action': 'touch', 'model': listModel, 'id': id};
        worker.sendMessage(msg);
        timer.start()
    }

    function startLevel(__level){
        var msg = {'action': 'startLevel', 'model': listModel, 'level': __level};
        worker.sendMessage(msg);

    }
    function test(){
        for(var i = 0;i < UI.COL_COUNT*UI.ROW_COUNT; i++){
                listModel.set(i,{t: 0, upD:1, downD:1, rightD:1,leftD:1})
        }
    }

    function goNextLevel(){
        timer.stop()
        gameModel.__inProgress = false
        nextlevel()
    }
    Accelerometer{
        id:sens
        property double preX: 0
        property double preY: 0
        property double preZ: 0
        property bool flag: true
        active: true
        dataRate: 2
        outputRange: 2
        onReadingChanged: {
            if((reading.x-preX)*(reading.x-preX)+(reading.y-preY)*(reading.y-preY)>70&&0<reading.x-preX){
                if(flag){
                    //console.log("left");
                    if(!gameModel.__inProgress){
                        worker.sendMessage({'action': 'splash', 'direction':'left', 'model': listModel});
                        gamePlay.touched = true
                        timer.start()
                    }
                    flag = false
                } else
                flag = true
            } else if((reading.x-preX)*(reading.x-preX)+(reading.y-preY)*(reading.y-preY)>70&&0>reading.x-preX){
                if(flag){
                    //console.log("right");
                    if(!gameModel.__inProgress){
                        worker.sendMessage({'action': 'splash', 'direction':'right', 'model': listModel});
                        gamePlay.touched = true
                        timer.start()
                    }
                    flag = false
                } else
                    flag = true
            } else
                flag = true
            preX = reading.x; preY = reading.y; preZ = reading.z
        }
        onSensorError: {
            console.log(sens.error)
        }
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
                gameModel.__inProgress = false
                gameModel.stopped()
            }
            if(messageObject.needBang)
                bang()
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
