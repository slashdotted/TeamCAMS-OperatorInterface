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

FocusScope {
    id: root
    width: 180
    height: 30
    property alias text: input.text
    property bool hideInput: false
    signal accepted

    Rectangle {
        id: border
        anchors.centerIn: parent
        anchors.fill: parent
        color: input.activeFocus ? "#ff0000" : "#000000"
        radius: 5
    }

    Rectangle {
        id: background
        width: parent.width - 8
        height: parent.height - 8
        anchors.centerIn: parent
        color: "white"
        radius: 3
    }

    TextInput {
        id: input
        clip: true
        focus: true
        height: parent.height - 8
        width: parent.width - 8
        anchors.centerIn: parent
        color: "#151515"
        selectionColor: "green"
        font.pixelSize: parent.height - 12
        font.bold: true
        echoMode: hideInput ? TextInput.Password : TextInput.Normal
        passwordCharacter: '*'
        onAccepted: root.accepted()
        inputMethodHints: Qt.ImhNoAutoUppercase
    }
}
