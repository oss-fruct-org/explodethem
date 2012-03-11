import QtQuick 1.0

Row {
    id: scrollingDigits

    property int number: 0
    property int positions: 5


    Repeater {
        id: rep

        model: scrollingDigits.positions

        Digit {
        }
    }

    onNumberChanged: {

        var tmp = number

        for( var i = 0; i < positions; ++i ) {
            rep.itemAt( positions - i - 1).digit = tmp % 10
            tmp = Math.floor( tmp / 10 )
        }
    }
}
