import QtQuick 1.0
import com.nokia.symbian 1.1

Item{
    property alias handX: handIcon.x
    property alias handY: handIcon.y

    z:2
    anchors.fill: parent

    function play(){
        infoAn.start()
    }

    /*Image{
        id: handIcon
        source: "images/hand.jpg"
        opacity: 0.8
        width: 30; height: 30
    }*/

    Rectangle{
        id:info
        anchors.centerIn: parent
        width:150; height: 30
        opacity: 0.8
        color: "black"
        radius: 7
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Push one bomb"
            transformOrigin: Item.Center
            color: "white"
            font.pixelSize: 20
        }
    }

    NumberAnimation {id:infoAn; running: false;target: info; property: "x"; to: 100; duration: 1000 }
}
