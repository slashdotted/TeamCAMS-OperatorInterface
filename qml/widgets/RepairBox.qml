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
import QtQuick.Controls
import "../../"

Rectangle {
    id: root
    width: 860
    height: 540
    color: "#AAAAAA"
    border.width: 2
    border.color: "black"

    signal repairRequest(string cname)

    onVisibleChanged: {
        EventBus.log("userui", JSON.stringify({
            "key": "repair.dialog.visible",
            "value": visible
        }));
    }

    Image {
        anchors.fill: parent
        source: "qrc:///qml/assets/images/metal-texture.jpg"
        fillMode: Image.Tile
    }

    RepairOverview {
        id: repairoverview
        x: 8
        y: 8
        width: 840
        height: 300
        onComponentSelected: function (cname) {
            EventBus.log("userui", JSON.stringify({
                "key": cname + ".repair.selected",
                "value": true
            }));
            switch (cname) {
            case "o2tankvalve":
                repairTable.model = null;
                break;
            case "n2tankvalve":
                repairTable.model = null;
                break;
            case "o2valve":
                repairTable.model = o2valve_repairs;
                break;
            case "n2valve":
                repairTable.model = n2valve_repairs;
                break;
            case "mixer":
                repairTable.model = mixer_repairs;
                break;
            case "dehumidifier":
                repairTable.model = dehumidifier_repairs;
                break;
            case "scrubber":
                repairTable.model = scrubber_repairs;
                break;
            case "heater":
                repairTable.model = heater_repairs;
                break;
            case "cooler":
                repairTable.model = cooler_repairs;
                break;
            case "vent":
                repairTable.model = vent_repairs;
                break;
            }
        }
    }

    ListModel {
        id: o2valve_repairs
        ListElement {
            title: qsTr("Repair O<sub>2</sub> valve block")
            trigger: "o2_valve_block_repair"
        }
        ListElement {
            title: qsTr("Repair O<sub>2</sub> valve leak")
            trigger: "o2_valve_leak_repair"
        }
        ListElement {
            title: qsTr("Repair O<sub>2</sub> valve stuck open")
            trigger: "o2_valve_stuck_open_repair"
        }
        ListElement {
            title: qsTr("Repair switch point failure in O<sub>2</sub> control")
            trigger: "o2_switch_point_failure_repair"
        }
    }

    ListModel {
        id: n2valve_repairs
        ListElement {
            title: qsTr("Repair N<sub>2</sub> valve block")
            trigger: "n2_valve_block_repair"
        }
        ListElement {
            title: qsTr("Repair N<sub>2</sub> valve leak")
            trigger: "n2_valve_leak_repair"
        }
        ListElement {
            title: qsTr("Repair N<sub>2</sub> valve stuck open")
            trigger: "n2_valve_stuck_open_repair"
        }
        ListElement {
            title: qsTr("Repair switch point failure in N<sub>2</sub> (pressure) control")
            trigger: "n2_switch_point_failure_repair"
        }
    }

    ListModel {
        id: mixer_repairs
        ListElement {
            title: qsTr("Repair mixer block")
            trigger: "mixer_block_repair"
        }
    }

    ListModel {
        id: dehumidifier_repairs
        ListElement {
            title: qsTr("Repair dehumidifier stuck on")
            trigger: "dehumidifier_stuck_on_repair"
        }
        ListElement {
            title: qsTr("Repair switch point failure in dehumidifier control")
            trigger: "dehumidifier_switch_point_failure_repair"
        }
        ListElement {
            title: qsTr("Repair dehumidifier ineffective")
            trigger: "dehumidifier_ineffective_repair"
        }
    }

    ListModel {
        id: scrubber_repairs
        ListElement {
            title: qsTr("Repair scrubber stuck on")
            trigger: "scrubber_stuck_on_repair"
        }
        ListElement {
            title: qsTr("Repair switch point failure in scrubber control")
            trigger: "scrubber_switch_point_failure_repair"
        }
        ListElement {
            title: qsTr("Repair scrubber ineffective")
            trigger: "scrubber_ineffective_repair"
        }
    }

    ListModel {
        id: vent_repairs
        ListElement {
            title: qsTr("Repair vent stuck on")
            trigger: "vent_stuck_on_repair"
        }
        ListElement {
            title: qsTr("Repair switch point failure in vent control")
            trigger: "vent_switch_point_failure_repair"
        }
        ListElement {
            title: qsTr("Repair vent ineffective")
            trigger: "vent_ineffective_repair"
        }
    }

    ListModel {
        id: heater_repairs
        ListElement {
            title: qsTr("Repair heater stuck on")
            trigger: "heater_stuck_on_repair"
        }
        ListElement {
            title: qsTr("Repair switch point failure in heater control")
            trigger: "heater_switch_point_failure_repair"
        }
        ListElement {
            title: qsTr("Repair heater ineffective")
            trigger: "heater_ineffective_repair"
        }
    }

    ListModel {
        id: cooler_repairs
        ListElement {
            title: qsTr("Repair cooler stuck on")
            trigger: "cooler_stuck_on_repair"
        }
        ListElement {
            title: qsTr("Repair switch point failure in cooler control")
            trigger: "cooler_switch_point_failure_repair"
        }
        ListElement {
            title: qsTr("Repair cooler ineffective")
            trigger: "cooler_ineffective_repair"
        }
    }

    Rectangle {
        id: repairTableBox
        x: 8
        y: 320
        color: "#AAAAAA"
        border.width: 2
        border.color: "black"
        width: 840
        height: 170

        ScrollView {
            anchors.fill: parent
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ListView {
                id: repairTable
                anchors.fill: parent
                topMargin: 5
                bottomMargin: 5
                leftMargin: 5
                rightMargin: 5
                anchors.margins: 5
                delegate: Component {
                    Text {
                        height: 25
                        verticalAlignment: Text.AlignVCenter
                        text: title
                        font.pixelSize: 16
                        font.bold: true

                        width: parent.width - 10
                        MouseArea {
                            anchors.fill: parent
                            onClicked: repairTable.currentIndex = index
                        }
                    }
                }
                highlight: Rectangle {
                    color: 'grey'
                }
                focus: true
            }
        }
    }

    MultiEffect {
        source: repairTableBox
        anchors.fill: repairTableBox
        shadowBlur: 1.0
        shadowEnabled: true
        shadowColor: "#80000000"
        shadowVerticalOffset: 3
        shadowHorizontalOffset: 3
    }

    SimpleButton {
        id: repairButton
        x: parent.width - width - 15
        y: 500
        label: qsTr("Repair")
        height: 30
        width: 100
        visible: repairTable.count > 0 && repairTable.currentIndex >= 0
        onClicked: {
            var componentName = repairTable.model.get(repairTable.currentIndex).trigger;
            repairoverview.selectedComponentName = "";
            repairTable.model = null;
            EventBus.sendCommand("trigger", componentName);
            EventBus.sendLocalNotification("hideRepairDialog");
        }
    }
}
