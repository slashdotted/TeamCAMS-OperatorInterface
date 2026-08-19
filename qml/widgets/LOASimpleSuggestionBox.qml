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

ColumnLayout {
    y: 160
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width - 20
    spacing: 4

    property string suggestion1: ""
    property string suggestion2: ""
    property string suggestion3: ""

    Rectangle {
        id: suggestionBox1
        width: parent.width
        height: 50
        border.width: 2
        border.color: "black"
        color: "#999999"
        visible: (suggestion1 != "")

        Text {
            text: suggestion1
            x: 10
            font.pointSize: 16
            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: "blue"

            textFormat: Text.RichText
        }
    }

    Rectangle {
        id: suggestionBox2
        width: parent.width
        height: 50
        border.width: 2
        border.color: "black"
        color: "#999999"
        visible: (suggestion2 != "")

        Text {
            text: suggestion2
            x: 10
            font.pointSize: 16
            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: "blue"

            textFormat: Text.RichText
        }
    }

    Rectangle {
        id: suggestionBox3
        width: parent.width
        height: 50
        border.width: 2
        border.color: "black"
        color: "#999999"
        visible: (suggestion3 != "")

        Text {
            text: suggestion3
            font.pointSize: 16
            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: "blue"

            textFormat: Text.RichText
        }
    }
}
