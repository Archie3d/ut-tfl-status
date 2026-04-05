import QtQuick 2.7
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3

/**
    Single row showing the line name and its status
*/
ListItem {
    property string lineMode
    property string lineName
    property color lineColor
    property string lineStatus
    property int lineStatusSeverity

    signal lineClicked()

    RowLayout {
        spacing: units.gu(1)
        anchors.fill: parent

        Rectangle {
            width: units.gu(1)
            height: parent.height
            Layout.fillHeight: true
            color: lineColor

            Rectangle {
                anchors.centerIn: parent
                width: parent.width / 3
                height: parent.height
                color: theme.palette.normal.background
                visible: lineMode == "overground"
            }
        }

        ColumnLayout {
            Item {
                height: 0
            }
            Text {
                width: parent.width
                text: lineName
                font.bold: true
                color: theme.palette.normal.baseText
            }
            Text {
                text: lineStatus
                color: theme.palette.normal.baseText
            }
        }

        Item {
            Layout.fillWidth: true;
        }

        Icon {
            width: units.gu(2)
            name: "dialog-warning-symbolic"
            color: theme.palette.normal.activity
            visible: lineStatusSeverity < 10
        }
    }


    onClicked: {
        lineClicked();
    }

}
