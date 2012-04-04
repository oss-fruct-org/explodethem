// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: digitItem
    width: size
    height: size

    clip: true

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "black"
        }

        GradientStop {
            position: 0.5
            color: "#222222"
        }

        GradientStop {
            position: 1.0
            color: "black"
        }
    }

    border.color: "white"
    border.width: 1

    property int digit: 0
    property int size: 40

    onDigitChanged: { digitPath.currentIndex = digit; }

    PathView {
        id: digitPath

        width: digitItem.size
        height: digitItem.size * 10

        interactive: false

        anchors.centerIn: parent

        model: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]

        delegate: Text {
            width: digitItem.size
            height: digitItem.size

            text: modelData;

            color: "white";
            style: Text.RichText
            styleColor: "black"

            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;

            font.pixelSize: digitItem.size-4;
        }

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5

        path: Path {
            startX: digitPath.width / 2
            startY: 0

            PathLine { x: digitPath.width / 2; y: digitPath.height }
        }
    }
}
