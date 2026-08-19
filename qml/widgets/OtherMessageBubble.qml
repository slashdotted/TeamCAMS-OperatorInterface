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

Row {
    id: messageItem2
    spacing: 0

    Label {
        id: senderLabel
        height: messageBox.height
        width: Math.min(implicitWidth, parent.width - 100)
        color: "black"
        text: sender
        font.pointSize: 10
        font.bold: true
        verticalAlignment: Text.AlignBottom
        elide: Text.ElideRight
    }

    Canvas {
        width: 24
        height: parent.height

        onPaint: {
            var context = getContext("2d");
            context.beginPath();
            context.moveTo(width, height - 24 - 8);
            context.lineTo(width, height - 8);
            context.lineTo(width - 20, height - 8);
            context.closePath();
            context.fillStyle = recipient === "" ? "lightgrey" : "lightpink";
            context.fill();
        }
    }

    Rectangle {
        id: messageBox
        width: Math.min(messageText.implicitWidth + 24 + messageTime.implicitWidth, 500)
        height: messageText.implicitHeight + 24 + messageTime.implicitHeight
        color: recipient === "" ? "lightgrey" : "lightpink"
        radius: 5

        Component.onCompleted: {}

        Label {
            id: messageText
            text: message
            color: "black"
            anchors.centerIn: parent
            anchors.margins: 12
            anchors.fill: parent
            wrapMode: Label.Wrap
        }

        Label {
            id: messageTime
            text: timestamp
            color: "grey"
            anchors.fill: parent
            anchors.margins: 12
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
            font.pointSize: 8
            wrapMode: Label.Wrap
        }
    }
}
