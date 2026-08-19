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
import QtQuick.Layouts
import "../../"

Item {
    id: root
    width: 820
    height: 100

    signal loaSelected(string loa)

    property string activeLOA: ""
    property bool loa1enabled: false
    property bool loa2enabled: false
    property bool loa3enabled: false
    property bool loa4enabled: false
    property bool loa5enabled: false
    property bool loa6enabled: false

    property bool loa1selectable: true
    property bool loa2selectable: true
    property bool loa3selectable: true
    property bool loa4selectable: true
    property bool loa5selectable: true
    property bool loa6selectable: true

    /*
      a property on the server lists valid loas (ex. LOA1,LOA3,LOA5), lights should be
      turned off for disabled loas, be green for selectable LOA and red for selected (active) LOA
      loa change sends a trigger to the server
      the server checks a property with a list of valid LOAs,
      then updates the active LOA property -> changes the active loa panel here

      */
    function requestLoaChange(lvl) {
        EventBus.sendCommand("trigger", lvl + " select");
        loaSelected(lvl);
    }

    function setLoaStatus(loa, status) {
        switch (loa) {
        case "loa1":
            loa1enabled = status;
            break;
        case "loa2":
            loa2enabled = status;
            break;
        case "loa3":
            loa3enabled = status;
            break;
        case "loa4":
            loa4enabled = status;
            break;
        case "loa5":
            loa5enabled = status;
            break;
        case "loa6":
            loa6enabled = status;
            break;
        }
    }

    Component.onCompleted: {
        EventBus.subU("interface.loa_1.button.enabled", (pname, pvalue) => {
            lamp1.enabled = pvalue;
            root.loa1selectable = pvalue;
        });
        EventBus.subU("interface.loa_2.button.enabled", (pname, pvalue) => {
            lamp2.enabled = pvalue;
            root.loa2selectable = pvalue;
        });
        EventBus.subU("interface.loa_3.button.enabled", (pname, pvalue) => {
            lamp3.enabled = pvalue;
            root.loa3selectable = pvalue;
        });
        EventBus.subU("interface.loa_4.button.enabled", (pname, pvalue) => {
            lamp4.enabled = pvalue;
            root.loa4selectable = pvalue;
        });
        EventBus.subU("interface.loa_5.button.enabled", (pname, pvalue) => {
            lamp5.enabled = pvalue;
            root.loa5selectable = pvalue;
        });
        EventBus.subU("interface.loa_6.button.enabled", (pname, pvalue) => {
            lamp6.enabled = pvalue;
            root.loa6selectable = pvalue;
        });
        EventBus.subU("automation.loa.active", (pname, pvalue) => {
            root.activeLOA = pvalue;
        });
        EventBus.subU("automation.loa.enabled", (pname, pvalue) => {
            root.parseLOAStatus(pvalue);
        });
    }

    function parseLOAStatus(pvalue) {
        var enabled_LOA = pvalue.split(",");
        setLoaStatus("loa1", (enabled_LOA.indexOf("loa1") >= 0));
        setLoaStatus("loa2", (enabled_LOA.indexOf("loa2") >= 0));
        setLoaStatus("loa3", (enabled_LOA.indexOf("loa3") >= 0));
        setLoaStatus("loa4", (enabled_LOA.indexOf("loa4") >= 0));
        setLoaStatus("loa5", (enabled_LOA.indexOf("loa5") >= 0));
        setLoaStatus("loa6", (enabled_LOA.indexOf("loa6") >= 0));
    }

    function setLoaActive(loa) {
        activeLOA = loa;
    }

    GridLayout {
        id: grid
        columns: 6
        anchors.centerIn: parent
        columnSpacing: (parent.width - 600) / columns
        anchors.verticalCenterOffset: 5
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        Item {
            width: 100
            height: 30
            Lamp {
                id: lamp1
                anchors.horizontalCenter: parent.horizontalCenter
                width: 30
                height: 30
                color: root.activeLOA == "loa1" ? "red" : "green"
                active: root.activeLOA == "loa1" || root.loa1enabled
            }
        }

        Item {
            width: 100
            height: 30
            Lamp {
                id: lamp2
                anchors.horizontalCenter: parent.horizontalCenter
                width: 30
                height: 30
                color: root.activeLOA == "loa2" ? "red" : "green"
                active: root.activeLOA == "loa2" || root.loa2enabled
            }
        }

        Item {
            width: 100
            height: 30
            Lamp {
                id: lamp3
                anchors.horizontalCenter: parent.horizontalCenter
                width: 30
                height: 30
                color: root.activeLOA == "loa3" ? "red" : "green"
                active: root.activeLOA == "loa3" || root.loa3enabled
            }
        }

        Item {
            width: 100
            height: 30
            Lamp {
                id: lamp4
                anchors.horizontalCenter: parent.horizontalCenter
                width: 30
                height: 30
                color: root.activeLOA == "loa4" ? "red" : "green"
                active: root.activeLOA == "loa4" || root.loa4enabled
            }
        }

        Item {
            width: 100
            height: 30
            Lamp {
                id: lamp5
                anchors.horizontalCenter: parent.horizontalCenter
                width: 30
                height: 30
                color: root.activeLOA == "loa5" ? "red" : "green"
                active: root.activeLOA == "loa5" || root.loa5enabled
            }
        }

        Item {
            width: 100
            height: 30
            Lamp {
                id: lamp6
                anchors.horizontalCenter: parent.horizontalCenter
                width: 30
                height: 30
                color: root.activeLOA == "loa6" ? "red" : "green"
                active: root.activeLOA == "loa6" || root.loa6enabled
            }
        }

        SimpleButton {
            id: loa1
            enabled: loa1selectable && loa1enabled
            width: 100
            height: 30
            label: qsTr("Level 1")
            onClicked: {
                if (loa1enabled)
                    root.requestLoaChange("loa1");
            }
        }

        SimpleButton {
            id: loa2
            enabled: loa2selectable && loa2enabled
            width: 100
            height: 30
            label: qsTr("Level 2")
            onClicked: {
                if (loa2enabled)
                    root.requestLoaChange("loa2");
            }
        }

        SimpleButton {
            id: loa3
            enabled: loa3selectable && loa3enabled
            width: 100
            height: 30
            label: qsTr("Level 3")
            onClicked: {
                if (loa3enabled)
                    root.requestLoaChange("loa3");
            }
        }

        SimpleButton {
            id: loa4
            enabled: loa4selectable && loa4enabled
            width: 100
            height: 30
            label: qsTr("Level 4")
            onClicked: {
                if (loa4enabled)
                    root.requestLoaChange("loa4");
            }
        }

        SimpleButton {
            id: loa5
            enabled: loa5selectable && loa5enabled
            width: 100
            height: 30
            label: qsTr("Level 5")
            onClicked: {
                if (loa5enabled)
                    root.requestLoaChange("loa5");
            }
        }

        SimpleButton {
            id: loa6
            enabled: loa6selectable && loa6enabled
            width: 100
            height: 30
            label: qsTr("Level 6")
            onClicked: {
                if (loa6enabled)
                    root.requestLoaChange("loa6");
            }
        }
    }
}
