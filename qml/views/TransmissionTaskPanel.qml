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
import "../../"

Item {
    id: root
    width: 240
    height: 140
    visible: SettingsManager.transmissioncontrolvisible
    property double transmissionCheckPingTime: 0
    property bool isValidResult: true

    function transmissionControl() {
        if (transmissionCheckLamp.active && isValidResult) {
            var now = new Date().getTime();
            var delta = now - transmissionCheckPingTime;
            EventBus.sendCommand("trigger", "transmissioncheck", {
                "responseTime": delta,
                "appeared": transmissionCheckPingTime,
                "clicked": now,
                "isValid": isValidResult
            });
            transmissionCheckLamp.active = false;
        } else {
            EventBus.sendCommand("trigger", "transmissioncheck", {
                "responseTime": -1,
                "isValid": isValidResult
            });
        }
    }

    Component.onCompleted: {
        EventBus.subN("transmissioncheck", (event, payload) => {
            if (!root.visible) {
                return;
            }
            isValidResult = true;
            transmissionCheckPingTime = new Date().getTime();
            transmissionCheckLamp.active = true;
            SoundEffectProxy.chime();
        });
        EventBus.subN("transmissioncheckreset", (event, payload) => {
            if (!root.visible) {
                return;
            }
            transmissionCheckLamp.active = false;
        });
        EventBus.subU("system.state", (pname, pvalue) => {
            if (pvalue === "PAUSED") {
                isValidResult = false;
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
        height: 130
        color: "#AAAAAA"
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: "black"

        Lamp {
            id: transmissionCheckLamp
            x: 129
            y: 36
            width: 50
            height: 50
            color: "blue"
            active: false
        }

        Image {
            id: transmissionCheckIcon
            x: 67
            y: 46
            width: 30
            height: 30
            source: "qrc:///qml/assets/images/transmission.svg"
        }

        SimpleButton {
            id: transmissionCheckButton
            x: 10
            y: 92
            width: 210
            height: 30
            label: qsTr("Check")
            onClicked: {
                root.transmissionControl();
            }
        }

        Text {
            id: text4
            x: 8
            y: 8
            text: qsTr("Transmission control")
            z: 1
            font.bold: true
            textFormat: Text.RichText
            font.pixelSize: 17
        }
    }
}
