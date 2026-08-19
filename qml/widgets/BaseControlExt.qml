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
    height: 100
    property string ctrlparam: "oxygen"
    property string ctrltext: "O<sub>2</sub> flow control"
    signal strengthChanged(string parameter, string value)
    signal controlChanged(string parameter, string value)

    property alias mainSwitch: temperatureControl
    property alias heatingLevelSwitch: heatingLevelSwitch
    property alias coolingLevelSwitch: coolingLevelSwitch

    property bool panelEnabled: true
    property bool strengthEnabledHeating: true
    property bool strengthEnabledCooling: true

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
                    target: temperatureControl
                    opacity: 1.0
                }
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: temperatureControl
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
            id: hideTimerBase
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
        id: coolControl
        state: SettingsManager.keepcontrolsvisible ? "show" : "hidden"
        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: coolingLevelSwitch
                    opacity: 1.0
                }
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: coolingLevelSwitch
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
            id: hideTimerCool
            interval: 15000
            repeat: false
            running: false
            onTriggered: function () {
                coolControl.state = "hidden";
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".cooler.strength.visible",
                    "value": false
                }));
            }
        }
    }

    Item {
        id: heatControl
        state: SettingsManager.keepcontrolsvisible ? "show" : "hidden"
        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: heatingLevelSwitch
                    opacity: 1.0
                }
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: heatingLevelSwitch
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
            id: hideTimerHeat
            interval: 15000
            repeat: false
            running: false
            onTriggered: function () {
                heatControl.state = "hidden";
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".heater.strength.visible",
                    "value": false
                }));
            }
        }
    }

    Rectangle {
        Text {
            id: deviceNameLabel
            x: 55
            y: SettingsManager.tempcontrolaligncenter ? (root.height / 2 - 10) : 15
            width: 134
            height: 19
            text: qsTr("Temperature")
            font.bold: true
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenterOffset: 0
            font.pixelSize: 17
            textFormat: Text.RichText
        }

        FourSlideSwitch {
            id: temperatureControl
            x: 200
            y: SettingsManager.tempcontrolaligncenter ? (root.height / 2 - 15) : 10
            width: 180
            height: 30
            onExplicitStateChange: root.controlChanged(ctrlparam, state)
            opacity: 0.0
        }

        LevelSwitch {
            id: heatingLevelSwitch
            x: 630
            y: 10
            width: 180
            height: 30
            anchors.bottomMargin: 3
            onExplicitStateChange: root.strengthChanged("heater", state)
            opacity: 0.0
        }

        Text {
            id: heatingStrengthLabel
            x: 437
            y: 15
            text: qsTr("Heating strength")
            font.bold: true
            anchors.verticalCenterOffset: 0
            font.pixelSize: 17
        }
    }

    SimpleImageButton {
        id: heatingSimpleImageButton
        x: 400
        y: 10
        width: 30
        height: 30
        source: "qrc:///qml/assets/images/heater.svg"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        sourceSize.height: height
        enabled: panelEnabled && strengthEnabledHeating

        onClicked: {
            if (!SettingsManager.keepcontrolsvisible) {
                heatControl.state = "show";
                hideTimerHeat.restart();
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".heater.strength.visible",
                    "value": true
                }));
            }
        }
    }

    Text {
        id: coolingStrengthLabel
        x: 437
        y: 67
        text: qsTr("Cooling strength")
        font.bold: true
        font.pixelSize: 17
        anchors.verticalCenterOffset: 0
    }

    LevelSwitch {
        id: coolingLevelSwitch
        x: 630
        y: 62
        width: 180
        height: 30
        anchors.rightMargin: -1
        anchors.bottomMargin: 3
        onExplicitStateChange: root.strengthChanged("cooler", state)
        opacity: 0.0
    }

    SimpleImageButton {
        id: coolingSimpleImageButton
        x: 400
        y: 62
        width: 30
        height: 30
        sourceSize.width: width
        source: "qrc:///qml/assets/images/cooler.svg"
        sourceSize.height: height
        fillMode: Image.PreserveAspectFit
        enabled: panelEnabled && strengthEnabledCooling

        onClicked: {
            if (!SettingsManager.keepcontrolsvisible) {
                coolControl.state = "show";
                hideTimerCool.restart();
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".cooler.strength.visible",
                    "value": true
                }));
            }
        }
    }

    SimpleImageButton {
        id: temperatureSimpleImageButton
        x: 18
        y: SettingsManager.tempcontrolaligncenter ? (root.height / 2 - 15) : 10
        width: 30
        height: 30
        sourceSize.height: height
        source: "qrc:///qml/assets/images/temperature.svg"
        fillMode: Image.PreserveAspectFit
        sourceSize.width: width
        enabled: panelEnabled

        onClicked: {
            if (!SettingsManager.keepcontrolsvisible) {
                baseControl.state = "show";
                hideTimerBase.restart();
                EventBus.log("userui", JSON.stringify({
                    "key": root.ctrlparam + ".control.visible",
                    "value": true
                }));
            }
        }
    }
}
