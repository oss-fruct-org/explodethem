// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.symbian 1.1
import IAP 1.0
import Qt 4.7

Page{
    id:buyPage
    orientationLock: PageOrientation.LockPortrait
    tools: ToolBarLayout {
        visible: true
        ToolButton {
            iconSource: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
        ToolButton {
            iconSource: "toolbar-add"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: console.log(iap_manager.purchaseProductByName("SBK Photo"))//iap_manager.purchaseProductByID("813279")
        }
    }

    QIap {
        id:iap_manager
        onPurchaseCompleted: {
           console.log("onPurchaseCompleted")
           console.log(">"+status)
           console.log(">"+productID)

            if( status==="OK") {
               if( productID === "813279" ) {
                   console.log(iap_manager.getDRMFileContent(productID,"video.csv"));
               } else
               if( productID === "821073" ) {
                   console.log(iap_manager.getDRMFileContent(productID,"photo.txt"));
               }
           }
       }
    }

    Text{
        id: text_purchased
        anchors.centerIn: parent
        text: "none"
    }
}
