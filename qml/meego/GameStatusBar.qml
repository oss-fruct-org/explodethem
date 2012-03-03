// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.meego 1.0

Image {
    id: statusBar

    property alias sparksDigit: sparksDigit

    width: gamePlay.width
    z:1
    source: "images/bar.jpg"
    Text{
        id:scoreText
        anchors{left: parent.left}
        text: qsTr(" Score: ") + score
        font.pixelSize: UI.FONT_SIZE
        style: Text.RichText
        styleColor: "black"
        color:"white"
    }
    Text{
        id:levelText
        anchors{left: parent.left;leftMargin: 320}
        text: qsTr("Level: ") + level
        font.pixelSize: UI.FONT_SIZE
        style: Text.RichText
        styleColor: "black"
        color:"white"
    }

    ScrollingDigits {
        id:sparksDigit
        anchors{horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 8}
        positions: 2
    }
    Image{
        source: "images/spark.png"
        height: 70
        anchors{left: sparksDigit.right; leftMargin: -17;
                verticalCenter: sparksDigit.verticalCenter; verticalCenterOffset: -10}
    }
    Image{
        source: "images/spark.png"
        height: 70
        anchors{right: sparksDigit.left; rightMargin: -17;
                verticalCenter: sparksDigit.verticalCenter; verticalCenterOffset: -10}
    }

}
