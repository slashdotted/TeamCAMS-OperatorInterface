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
import "qrc:///qml/js/Utils.js" as Utils
import "../../"

Item {
    id: root
    width: 240
    height: 230
    visible: SettingsManager.n2loggingtaskvisible

    property int currentTimestamp: 0
    property int nextLogDueAt: -1
    property int hiresTimestamp: 0

    Timer {
        id: hiresTimer
        interval: 10
        repeat: true
        onTriggered: function () {
            root.hiresTimestamp += 10;
        }
    }

    function n2LogValue(value) {
        if (nextLogDueAt < 0) {
            EventBus.sendCommand("trigger", "n2log", {
                "n2Amount": value,
                "responseTime": -1,
                "dueTime": -1
            });
        } else {
            var delta = nextLogDueAt * 1000 - ((currentTimestamp * 1000) + hiresTimestamp);
            EventBus.sendCommand("trigger", "n2log", {
                "n2Amount": value,
                "responseTime": delta,
                "dueTime": nextLogDueAt
            });
            nextLogDueAt = -1;
        }
    }

    Component.onCompleted: {
        EventBus.subN("n2log", (event, payload) => {
            if (!root.visible) {
                return;
            }
            nextLogDueAt = payload.due;
            SoundEffectProxy.highchime();
        });
        EventBus.subN("n2loghide", (event, payload) => {
            if (!root.visible) {
                return;
            }
            nextLogDueAt = -1;
        });
        EventBus.subN("start", (event, payload) => {
            if (!root.visible) {
                return;
            }
            nextLogDueAt = -1;
        });
        EventBus.subU("system.timestamp", (pname, pvalue) => {
            hiresTimestamp = 0;
            hiresTimer.restart();
            currentTimestamp = pvalue;
            if (pvalue === -1) {
                nextLogDueAt = -1;
            }
        });
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
        height: 220
        color: "#AAAAAA"
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: "black"

        Text {
            id: loggingTaskTitle
            x: 8
            y: 8
            text: qsTr("N<sub>2</sub> logging task")
            z: 1
            font.bold: true
            textFormat: Text.RichText
            font.pixelSize: 17
        }

        SimpleButton {
            id: logButton
            x: 10
            y: 182
            width: 210
            height: 30
            //radius: 1
            z: 1
            label: qsTr("Send log")
            onClicked: {
                root.n2LogValue(logInputBox.value);
                logInputBox.clear();
            }
        }

        TouchInputDisplay {
            id: logInputBox
            x: 10
            y: 95
            width: 210
            height: 42

            onLogged: {
                root.n2LogValue(logInputBox.value);
                logInputBox.clear();
            }
        }

        Text {
            id: nextLogDueLabel
            x: 8
            y: 34
            text: qsTr("Next log due at:")
            z: 1
            font.pixelSize: 15
        }

        Text {
            id: nextLogDuetime
            x: 140
            y: 34
            width: 68
            height: 18
            text: root.nextLogDueAt > 0 ? Utils.formatTimestamp(root.nextLogDueAt) : "--:--:--"
            horizontalAlignment: Text.AlignRight
            z: 1
            font.bold: true
            font.pixelSize: 15
        }
    }
}
