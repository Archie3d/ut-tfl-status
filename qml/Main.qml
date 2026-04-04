import QtQuick 2.7
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import "components"

import "tfl.js" as TFL

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'tflstatus.archie3d'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    ListModel {
        id: linesListModel

        function fetchStatus() {
            TFL.getAllLinesStatus(function(status, data) {
                if (status === TFL.OK) {
                    linesListModel.clear();
                    for (var i = 0; i < data.length; i++) {
                        linesListModel.append(data[i]);
                    }
                }
            });
        }
    }

    Component {
        id: lineStatusDialog
        LineStatusDialog {}
    }


    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('Tfl Status')
        }

        ColumnLayout {
            spacing: units.gu(1)
            anchors {
                margins: units.gu(1)
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            ListView {
                id: linesListView
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: linesListModel

                delegate: LineStatusListItem {
                    width: parent.width
                    height: units.gu(6)
                    lineMode: model.mode
                    lineName: model.name
                    lineColor: model.color
                    lineStatus: model.status
                    lineStatusSeverity: model.severity
                    onLineClicked: function(){
                        PopupUtils.open(lineStatusDialog, null, {
                            "lineMode": model.mode,
                            "lineName": model.name,
                            "lineColor": model.color,
                            "message": model.reason
                        })
                    }
                }
            }
        }
    }

    Component.onCompleted: {
       linesListModel.fetchStatus();
    }

    Timer {
        // Update status once a minute
        interval: 60000; running: true; repeat: true
        onTriggered: {
            linesListModel.fetchStatus();
        }
    }
}
