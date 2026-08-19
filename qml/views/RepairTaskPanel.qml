// TeamCAMS - reborn Cabin Air Management System
// Copyright (C) 2015-2026  Amos Brocco,
//                          Cognitive Ergonomics and Work Psychology Team,
//                          Psychology Department of Fribourg University,
//                          Switzerland / Department of Innovative Technologies
//                          University of Applied Sciences and Arts of Southern
//                          Switzerland, Contact: amos.brocco@supsi.ch
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import QtQuick
import QtQuick.Effects
import "../widgets"
import "../utils"
import "../../"

Item {
    id: root
    width: 240
    height: 170
    property bool repairVisible: true
    property bool repairVisibleInterface: true
    visible: SettingsManager.repairtaskvisible

    Component.onCompleted: {
        EventBus.subU("system.repair.label", (pname, pvalue) => {
            if (pvalue === "") {
                if (repairLabel.text !== qsTr("No repairs in progress")) {
                    repairLabel.text = qsTr("Repairs executed; system settings reset to normal");
                    repairDoneMsgTimer.start();
                    root.repairVisible = true;
                } else {
                    repairLabel.text = qsTr("No repairs in progress");
                    root.repairVisible = true;
                }
            } else {
                root.repairVisible = false;
                repairDoneMsgTimer.stop();
                repairLabel.text = pvalue;
            }
        });

        EventBus.subU("interface.repairbutton.visible", (pname, pvalue) => {
            root.repairVisibleInterface = pvalue;
        });
    }

    Timer {
        id: repairDoneMsgTimer
        interval: 10
        repeat: false
        triggeredOnStart: false
        onTriggered: function () {
            repairLabel.text = qsTr("No repairs in progress");
        }
    }

    MultiEffect {
        source: mainItem
        anchors.fill: mainItem
        shadowBlur: 1.0
        shadowEnabled: true
        shadowColor: "#80000000"
        shadowVerticalOffset: 3
        shadowHorizontalOffset: 3
    }

    Rectangle {
        id: mainItem
        y: 10
        width: 230
        height: 160
        color: "#AAAAAA"
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: "black"

        Text {
            id: repairStatusTitleLabel
            x: 8
            y: 8
            text: qsTr("Repair status")
            z: 1
            font.bold: true
            font.pixelSize: 17
            textFormat: Text.RichText
        }

        Text {
            id: repairLabel
            x: 8
            y: 40
            width: 214
            height: 80
            text: qsTr("No repairs in progress")
            font.italic: true
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
        }

        SimpleButton {
            id: repairButton
            x: 10
            y: 122
            width: 210
            height: 30
            visible: root.repairVisible && root.repairVisibleInterface
            label: qsTr("Repair")
            z: 1
            onClicked: {
                EventBus.sendLocalNotification("showRepairDialog");
            }
        }
    }
}
