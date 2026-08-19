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
    width: 840
    height: 420
    visible: SettingsManager.devicecontrolvisible

    Component.onCompleted: {
        EventBus.subU("control.scrubber.state", (pname, pvalue) => {
            scrubbercontrol.mainSwitch.setState(pvalue);
            scrubbercontrol.strengthSwitch.allowUserChanges = (pvalue !== "assisted");
        });
        EventBus.subU("control.humidity.state", (pname, pvalue) => {
            dehumidifiercontrol.mainSwitch.setState(pvalue);
            dehumidifiercontrol.strengthSwitch.allowUserChanges = (pvalue !== "assisted");
        });
        EventBus.subU("control.o2.state", (pname, pvalue) => {
            o2control.mainSwitch.setState(pvalue);
            o2control.strengthSwitch.allowUserChanges = (pvalue !== "assisted");
        });
        EventBus.subU("control.pressure.state", (pname, pvalue) => {
            n2control.mainSwitch.setState(pvalue);
            n2control.strengthSwitch.allowUserChanges = (pvalue !== "assisted");
        });
        EventBus.subU("control.temperature.state", (pname, pvalue) => {
            temperaturecontrol.mainSwitch.setState(pvalue);
            temperaturecontrol.heatingLevelSwitch.allowUserChanges = (pvalue !== "assisted");
            temperaturecontrol.coolingLevelSwitch.allowUserChanges = (pvalue !== "assisted");
        });
        EventBus.subU("control.ventilation.state", (pname, pvalue) => {
            ventcontrol.mainSwitch.setState(pvalue);
            ventcontrol.strengthSwitch.allowUserChanges = (pvalue !== "assisted");
        });
        EventBus.subU("components.scrubber.strength", (pname, pvalue) => {
            scrubbercontrol.strengthSwitch.setState(pvalue);
        });
        EventBus.subU("components.o2valve.strength", (pname, pvalue) => {
            o2control.strengthSwitch.setState(pvalue);
        });
        EventBus.subU("components.n2valve.strength", (pname, pvalue) => {
            n2control.strengthSwitch.setState(pvalue);
        });
        EventBus.subU("components.cooler.strength", (pname, pvalue) => {
            temperaturecontrol.coolingLevelSwitch.setState(pvalue);
        });
        EventBus.subU("components.heater.strength", (pname, pvalue) => {
            temperaturecontrol.heatingLevelSwitch.setState(pvalue);
        });
        EventBus.subU("components.vent.strength", (pname, pvalue) => {
            ventcontrol.strengthSwitch.setState(pvalue);
        });
        EventBus.subU("components.dehumidifier.strength", (pname, pvalue) => {
            dehumidifiercontrol.strengthSwitch.setState(pvalue);
        });
        EventBus.subU("interface.oxygenpanelgeneral.enabled", (pname, pvalue) => {
            o2control.panelEnabled = pvalue;
        });
        EventBus.subU("interface.oxygenpanel.enabled", (pname, pvalue) => {
            o2control.panelEnabled = pvalue;
        });
        EventBus.subU("interface.oxygenpanelflow.enabled", (pname, pvalue) => {
            o2control.strengthEnabled = pvalue;
        });
        EventBus.subU("interface.carbonpanelgeneral.enabled", (pname, pvalue) => {
            scrubbercontrol.panelEnabled = pvalue;
        });
        EventBus.subU("interface.carbonpanel.enabled", (pname, pvalue) => {
            scrubbercontrol.panelEnabled = pvalue;
        });
        EventBus.subU("interface.carbonpanelscrubber.enabled", (pname, pvalue) => {
            scrubbercontrol.strengthEnabled = pvalue;
        });
        EventBus.subU("interface.humiditypanelgeneral.enabled", (pname, pvalue) => {
            dehumidifiercontrol.panelEnabled = pvalue;
        });
        EventBus.subU("interface.humiditypanel.enabled", (pname, pvalue) => {
            dehumidifiercontrol.panelEnabled = pvalue;
        });
        EventBus.subU("interface.humiditypanellevel.enabled", (pname, pvalue) => {
            dehumidifiercontrol.strengthEnabled = pvalue;
        });
        EventBus.subU("interface.pressurepanelgeneral.enabled", (pname, pvalue) => {
            n2control.panelEnabled = pvalue;
        });
        EventBus.subU("interface.pressurepanel.enabled", (pname, pvalue) => {
            n2control.panelEnabled = pvalue;
        });
        EventBus.subU("interface.pressurepanelflow.enabled", (pname, pvalue) => {
            n2control.strengthEnabled = pvalue;
        });
        EventBus.subU("interface.temppanelgeneral.enabled", (pname, pvalue) => {
            temperaturecontrol.panelEnabled = pvalue;
        });
        EventBus.subU("interface.temppanel.enabled", (pname, pvalue) => {
            temperaturecontrol.panelEnabled = pvalue;
        });
        EventBus.subU("interface.temppanelheater.enabled", (pname, pvalue) => {
            temperaturecontrol.strengthEnabledHeating = pvalue;
        });
        EventBus.subU("interface.temppanelcooler.enabled", (pname, pvalue) => {
            temperaturecontrol.strengthEnabledCooling = pvalue;
        });
    }

    function notifyStrengthChange(parameter, value) {
        var pname = "components." + parameter + ".strength";
        EventBus.set(pname, value);
    }

    function notifyControlChange(parameter, value) {
        if (value === "heat")
            value = "heater";
        else if (value === "cool")
            value = "cooler";
        var propname = "control." + parameter + ".state";
        EventBus.set(propname, value);
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
        width: 820
        height: 410
        color: "#AAAAAA"
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: "black"
        Column {
            id: controls
            x: 0
            y: 34
            z: 1

            BaseControl {
                id: o2control
                z: 99
                source: "qrc:///qml/assets/images/valve.svg"
                ctrlparam: "o2"
                ctrltext: qsTr("O<sub>2</sub> flow")
                strengthtext: qsTr("O<sub>2</sub> flow strength")
                onControlChanged: (parameter, value) => notifyControlChange("o2", value)
                onStrengthChanged: (parameter, value) => notifyStrengthChange("o2valve", value)
            }

            BaseControl {
                id: n2control
                z: 99
                source: "qrc:///qml/assets/images/valve.svg"
                ctrlparam: "n2"
                ctrltext: qsTr("N<sub>2</sub> flow")
                strengthtext: qsTr("N<sub>2</sub> flow strength")
                onControlChanged: (parameter, value) => notifyControlChange("pressure", value)
                onStrengthChanged: (parameter, value) => notifyStrengthChange("n2valve", value)
            }

            BaseControl {
                id: scrubbercontrol
                z: 99
                source: "qrc:///qml/assets/images/scrubber.svg"
                ctrlparam: "scrubber"
                ctrltext: qsTr("CO<sub>2</sub> scrubber")
                strengthtext: qsTr("CO<sub>2</sub> scrubbing strength")
                onControlChanged: (parameter, value) => notifyControlChange("scrubber", value)
                onStrengthChanged: (parameter, value) => notifyStrengthChange("scrubber", value)
            }

            BaseControl {
                id: ventcontrol
                z: 99
                source: "qrc:///qml/assets/images/vent.svg"
                ctrlparam: "ventilation"
                ctrltext: qsTr("Vent")
                strengthtext: qsTr("Ventilation strength")
                onControlChanged: (parameter, value) => notifyControlChange("ventilation", value)
                onStrengthChanged: (parameter, value) => notifyStrengthChange("vent", value)
            }

            BaseControl {
                id: dehumidifiercontrol
                z: 99
                source: "qrc:///qml/assets/images/dehumidifier.svg"
                ctrlparam: "dehumidifier"
                ctrltext: qsTr("Dehumidifier")
                strengthtext: qsTr("Dehumidifier strength")
                onControlChanged: (parameter, value) => notifyControlChange("humidity", value)
                onStrengthChanged: (parameter, value) => notifyStrengthChange(parameter, value)
            }

            BaseControlExt {
                id: temperaturecontrol
                ctrlparam: "temperature"
                z: 99
                onControlChanged: (parameter, value) => notifyControlChange(parameter, value)
                onStrengthChanged: (parameter, value) => notifyStrengthChange(parameter, value)
            }
        }

        Text {
            id: text1
            x: 8
            y: 8
            text: qsTr("Device control")
            font.bold: true
            font.pixelSize: 17
        }

        Text {
            id: strengthtext
            x: 390
            y: 8
            text: qsTr("Strength control")
            font.bold: true
            font.pixelSize: 17

            visible: SettingsManager.showStrengthTitle
        }
    }
}
