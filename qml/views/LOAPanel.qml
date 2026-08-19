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
    width: 840
    height: 120
    visible: SettingsManager.assistancepanelsvisible

    Component.onCompleted: {
        EventBus.subU("interface.assistanceselector.visible", (pname, pvalue) => {
            loaSelector.visible = pvalue;
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
        width: root.width - 20 //820
        height: 110
        color: "#AAAAAA"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 5
        border.width: 2
        border.color: "black"

        Text {
            id: loaSelectorLabel
            x: 8
            y: 8
            text: qsTr("Assistance")
            font.pixelSize: 17
            font.bold: true
        }

        LOASelector {
            id: loaSelector
            anchors.centerIn: parent
            width: parent.width - 10
            height: 80
        }
    }
}
