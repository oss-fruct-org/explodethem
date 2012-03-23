// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "UIConstants.js" as UI
import com.nokia.symbian 1.1
import IAP 1.0
import Qt 4.7

Page{
    id:gameHelp
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
            onClicked: iap_manager.purchaseProductByName("SBK Photo")
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
                   text_purchased.text = iap_manager.getDRMFileContent(productID,"video.csv");
               } else
               if( productID === "821073" ) {
                   text_purchased.text = iap_manager.getDRMFileContent(productID,"photo.txt");
               }
           }
       }
    }

}
