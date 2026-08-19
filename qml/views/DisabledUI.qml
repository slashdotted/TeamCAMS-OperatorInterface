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
import QtQuick.Controls
import QtQuick.Effects
import "../widgets"
import "../utils"

Item {
    id: frame
    width: 960
    height: 540

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
        x: 10
        y: 10
        width: 940
        height: 520
        anchors.horizontalCenter: parent.Center
        border.color: "black"
        border.width: 2
        color: "#AAAAAA"

        Item {
            id: item1
            width: 930
            height: 510
            anchors.centerIn: parent

            Rectangle {
                id: messagingbox
                anchors.fill: parent
                color: "#AAAAAA"
                visible: false
                z: 99
            }

            Text {
                id: text1
                x: 445
                y: 220

                text: qsTr("You have been suspended")
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 35
            }
        }
    }
}
