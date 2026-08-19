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

Item {
    id: root
    property int value: -1
    property alias question: qbox.text

    Text {
        id: qbox
        x: 8
        y: 16
        width: 480
        height: 75
        text: qsTr("Text")
        font.bold: true
        font.pixelSize: 14
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
    }

    Row {
        spacing: 5
        anchors.horizontalCenter: parent.Center
        y: 80
        Repeater {
            id: rep
            model: 7
            Rectangle {
                width: (root.width - 55) / 7
                height: 25
                border.color: "black"
                border.width: 1

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    hoverEnabled: true
                    onHoveredChanged: {
                        for (var i = 0; i <= index; i++) {
                            var bkcolor = containsMouse ? "red" : (root.value >= i ? "green" : "white");
                            rep.itemAt(i).color = bkcolor;
                        }
                    }
                    onClicked: {
                        root.value = index;
                        for (var i = 0; i < rep.count; i++) {
                            var bkcolor = (root.value >= i) ? "green" : "white";
                            rep.itemAt(i).color = bkcolor;
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: index + 1

                    font.bold: true
                }
            }
        }
    }
}
