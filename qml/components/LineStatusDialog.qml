import QtQuick 2.7
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

Dialog {
    id: dialog

    property string lineMode
    property string lineName
    property string lineColor
    property string message

    title: i18n.tr(lineName)

    Rectangle {
        Layout.fillWidth: true
        height: units.gu(1)
        color: lineColor

        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height / 3
            color: theme.palette.normal.background
            visible: lineMode == "overground"
        }
    }

    Flickable {
        width: parent.width
        height: dialog.height / 3
        contentWidth: parent.width
        contentHeight: messageLabel.height
        clip: true

        Label {
            id: messageLabel
            width: parent.width
            wrapMode: Text.WordWrap
            text: message
        }
    }

    Button {
        text: i18n.tr("OK")
        onClicked: PopupUtils.close(dialog)
    }
}
