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
    width: 960
    height: 540
    visible: SettingsManager.graphpanelvisible

    property bool interfaceO2Visible: true
    property bool interfacePressureVisible: true
    property bool interfaceCO2Visible: true
    property bool interfaceHumidityVisible: true
    property bool interfaceTemperatureVisible: true

    function hideAll() {
        pressure.visible = false;
        o2.visible = false;
        co2.visible = false;
        humidity.visible = false;
        temperature.visible = false;
    }

    function resetButtonStatus() {
        co2btn.toggled = false;
        o2btn.toggled = false;
        pressurebtn.toggled = false;
        temperaturebtn.toggled = false;
        humiditybtn.toggled = false;
    }

    Component.onCompleted: {
        EventBus.subN("start", (event, payload) => {
            pressure.clear();
            o2.clear();
            co2.clear();
            humidity.clear();
            temperature.clear();
        });
        EventBus.subU("system.timestamp", (pname, pvalue) => {
            o2.commit();
            co2.commit();
            pressure.commit();
            temperature.commit();
            humidity.commit();
        });
        EventBus.subU("components.cabin.o2.relvalue", (pname, pvalue) => {
            o2.push(EventBus.getStored("system.timestamp"), pvalue);
        });
        EventBus.subU("components.cabin.co2.relvalue", (pname, pvalue) => {
            co2.push(EventBus.getStored("system.timestamp"), pvalue);
        });
        EventBus.subU("components.cabin.pressure", (pname, pvalue) => {
            pressure.push(EventBus.getStored("system.timestamp"), pvalue * 1000);
        });
        EventBus.subU("components.cabin.temperature", (pname, pvalue) => {
            temperature.push(EventBus.getStored("system.timestamp"), pvalue);
        });
        EventBus.subU("components.cabin.humidity", (pname, pvalue) => {
            humidity.push(EventBus.getStored("system.timestamp"), pvalue);
        });
        EventBus.subU("interface.oxygenscope.visible", (pname, pvalue) => {
            interfaceO2Visible = pvalue;
        });
        EventBus.subU("interface.pressurescope.visible", (pname, pvalue) => {
            interfacePressureVisible = pvalue;
        });
        EventBus.subU("interface.carbonscope.visible", (pname, pvalue) => {
            interfaceCO2Visible = pvalue;
        });
        EventBus.subU("interface.tempscope.visible", (pname, pvalue) => {
            interfaceTemperatureVisible = pvalue;
        });
        EventBus.subU("interface.humidityscope.visible", (pname, pvalue) => {
            interfaceHumidityVisible = pvalue;
        });
        EventBus.subN("start", (event, payload) => {
            pressure.clear();
            o2.clear();
            co2.clear();
            humidity.clear();
            temperature.clear();
        });
    }

    MultiEffect {
        source: switchItem
        anchors.fill: switchItem
        shadowBlur: 1.0
        shadowEnabled: true
        shadowColor: "#80000000"
        shadowVerticalOffset: 3
        shadowHorizontalOffset: 3
    }

    Rectangle {
        id: switchItem
        y: 10
        x: 10
        width: 940
        height: 50
        color: "#AAAAAA"
        anchors.verticalCenterOffset: 2
        anchors.horizontalCenterOffset: 0
        border.width: 2
        border.color: "black"

        Row {
            width: parent.width - 20
            anchors.horizontalCenter: parent.horizontalCenter
            x: 15
            y: 10
            spacing: 8

            SimpleButton {
                id: co2btn
                width: 175
                label: qsTr("CO<sub>2</sub>")
                height: 30
                onClicked: {
                    root.hideAll();
                    root.resetButtonStatus();
                    if (root.interfaceCO2Visible) {
                        co2btn.toggled = true;
                        co2.show();
                    }
                }
            }

            SimpleButton {
                id: o2btn
                width: 175
                label: qsTr("O<sub>2</sub>")
                height: 30
                onClicked: {
                    root.hideAll();
                    root.resetButtonStatus();
                    if (root.interfaceO2Visible) {
                        o2btn.toggled = true;
                        o2.show();
                    }
                }
            }

            SimpleButton {
                id: pressurebtn
                width: 175
                label: qsTr("Pressure")
                height: 30
                onClicked: {
                    root.hideAll();
                    root.resetButtonStatus();
                    if (root.interfacePressureVisible) {
                        pressurebtn.toggled = true;
                        pressure.show();
                    }
                }
            }

            SimpleButton {
                id: temperaturebtn
                width: 175
                label: qsTr("Temperature")
                height: 30
                onClicked: {
                    root.hideAll();
                    root.resetButtonStatus();
                    if (root.interfaceTemperatureVisible) {
                        temperaturebtn.toggled = true;
                        temperature.show();
                    }
                }
            }

            SimpleButton {
                id: humiditybtn
                width: 175
                label: qsTr("Humidity")
                height: 30
                onClicked: {
                    root.hideAll();
                    root.resetButtonStatus();
                    if (root.interfaceHumidityVisible) {
                        humiditybtn.toggled = true;
                        humidity.show();
                    }
                }
            }
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
        y: 70
        x: 10
        width: 940
        height: 460
        color: "#ffffff"
        anchors.verticalCenterOffset: 2
        anchors.horizontalCenterOffset: 0
        border.width: 2
        border.color: "black"

        LineGraph {
            id: co2
            anchors.fill: parent
            visible: false
            criticalUpperThreshold: 0.8
            criticalLowerThreshold: 0.1
            noncriticalUpperThreshold: 0.6
            noncriticalLowerThreshold: 0.2
            unit: "%"
            measure: "CO2"
            title: qsTr("CO<sub>2</sub>")
            onVisibleChanged: {
                if (!visible)
                    root.resetButtonStatus();
                EventBus.log("userui", JSON.stringify({
                    "key": measure + ".visible",
                    "value": visible
                }));
            }
        }

        LineGraph {
            id: o2
            anchors.fill: parent
            visible: false
            criticalUpperThreshold: 20.5
            criticalLowerThreshold: 19
            noncriticalUpperThreshold: 20.0
            noncriticalLowerThreshold: 19.6
            unit: "%"
            measure: "O2"
            title: qsTr("O<sub>2</sub>")
            onVisibleChanged: {
                if (!visible)
                    root.resetButtonStatus();
                EventBus.log("userui", JSON.stringify({
                    "key": measure + ".visible",
                    "value": visible
                }));
            }
        }

        LineGraph {
            id: pressure
            anchors.fill: parent
            visible: false
            criticalUpperThreshold: 1040
            criticalLowerThreshold: 970
            noncriticalUpperThreshold: 1025
            noncriticalLowerThreshold: 990
            unit: "hPa"
            measure: "Pressure"
            title: qsTr("Pressure")
            onVisibleChanged: {
                if (!visible)
                    root.resetButtonStatus();
                EventBus.log("userui", JSON.stringify({
                    "key": measure + ".visible",
                    "value": visible
                }));
            }
        }

        LineGraph {
            id: temperature
            anchors.fill: parent
            visible: false
            criticalUpperThreshold: 23
            criticalLowerThreshold: 18.5
            noncriticalUpperThreshold: 22
            noncriticalLowerThreshold: 19.5
            unit: "°C"
            measure: "Temperature"
            title: qsTr("Temperature")
            onVisibleChanged: {
                if (!visible)
                    root.resetButtonStatus();
                EventBus.log("userui", JSON.stringify({
                    "key": measure + ".visible",
                    "value": visible
                }));
            }
        }

        LineGraph {
            id: humidity
            anchors.fill: parent
            visible: false
            criticalUpperThreshold: 44
            criticalLowerThreshold: 36.5
            noncriticalUpperThreshold: 42
            noncriticalLowerThreshold: 38
            unit: "%"
            measure: "Humidity"
            title: qsTr("Humidity")
            onVisibleChanged: {
                if (!visible)
                    root.resetButtonStatus();
                EventBus.log("userui", JSON.stringify({
                    "key": measure + ".visible",
                    "value": visible
                }));
            }
        }
    }
}
