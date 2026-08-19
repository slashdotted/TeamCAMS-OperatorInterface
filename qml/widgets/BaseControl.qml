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
import "../../"

Item {
    id: root
    width: 820
    height: 50
    property string ctrlparam: "oxygen"
    property string ctrltext: "O<sub>2</sub> flow control"
    property string strengthtext: "O<sub>2</sub> flow strength"
    property alias source: deviceSimpleImageButton.source
    signal strengthChanged(string parameter, string value)
    signal controlChanged(string parameter, string value)
    property alias mainSwitch: controlSwitch
    property alias strengthSwitch: strengthLevelSwitch
    property bool panelEnabled: true
    property bool strengthEnabled: true

    Rectangle {
        x: 0
        width: parent.width
        height: 2
        color: "black"
        visible: SettingsManager.showControlDivider
    }

    Item {
        id: baseControl
        state: SettingsManager.keepcontrolsvisible ? "show" : "hidden"
        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: controlSwitch
                    opacity: 1.0
                }
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: controlSwitch
                    opacity: 0.0
                }
            }
        ]
        transitions: [
            Transition {
                NumberAnimation {
                    property: "opacity"
                    duration: 500
                }
            }
        ]

        Timer {
            id: basehideTimer
            interval: 15000
            repeat: false
            running: false
            onTriggered: function () {
                baseControl.state = "hidden";
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".control.visible",
                    "value": false
                }));
            }
        }
    }

    Item {
        id: strengthControl
        state: SettingsManager.keepcontrolsvisible ? "show" : "hidden"
        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: strengthLevelSwitch
                    opacity: 1.0
                }
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: strengthLevelSwitch
                    opacity: 0.0
                }
            }
        ]
        transitions: [
            Transition {
                NumberAnimation {
                    property: "opacity"
                    duration: 500
                }
            }
        ]

        Timer {
            id: strengthhideTimer
            interval: 15000
            repeat: false
            running: false
            onTriggered: function () {
                strengthControl.state = "hidden";
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".strength.visible",
                    "value": false
                }));
            }
        }
    }

    SimpleImageButton {
        id: deviceSimpleImageButton
        x: 18
        y: 10
        width: 30
        height: 30
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        sourceSize.height: height
        enabled: panelEnabled

        onClicked: {
            if (!SettingsManager.keepcontrolsvisible) {
                baseControl.state = "show";
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".control.visible",
                    "value": true
                }));
                basehideTimer.restart();
            }
        }
    }

    Text {
        id: deviceNameLabel
        x: 55
        y: 15
        width: 134
        height: 19
        text: ctrltext
        font.bold: true
        anchors.verticalCenterOffset: 1
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 16
        textFormat: Text.RichText
    }

    ThreeSlideSwitch {
        id: controlSwitch
        x: 200
        y: 10
        width: 180
        height: 30
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
        onExplicitStateChange: root.controlChanged(ctrlparam, state)
        opacity: 0.0
    }

    Text {
        id: strengthLabel
        x: 437
        y: 17
        width: 200
        height: 17
        text: strengthtext
        horizontalAlignment: Text.AlignLeft
        font.bold: true
        font.pixelSize: 16
        textFormat: Text.RichText
    }

    LevelSwitch {
        id: strengthLevelSwitch
        x: 630
        y: 10
        width: 180
        height: 30
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.bottomMargin: 3
        onExplicitStateChange: root.strengthChanged(ctrlparam, state)
        opacity: 0.0
    }

    SimpleImageButton {
        id: strengthSimpleImageButton
        x: 400
        y: 6
        width: 30
        height: 30
        anchors.verticalCenter: parent.verticalCenter
        source: deviceSimpleImageButton.source
        anchors.verticalCenterOffset: 0
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        sourceSize.height: height
        enabled: panelEnabled && strengthEnabled

        onClicked: {
            if (!SettingsManager.keepcontrolsvisible) {
                strengthControl.state = "show";
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".strength.visible",
                    "value": true
                }));
                strengthhideTimer.restart();
            }
        }
    }
}
