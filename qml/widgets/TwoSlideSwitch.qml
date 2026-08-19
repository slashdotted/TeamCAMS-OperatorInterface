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
import "../.."

Rectangle {
    id: frame
    color: "black"
    border.width: 5
    border.color: "black"
    radius: 5
    state: SettingsManager.messaginginfront ? "Messaging" : "Assistance"
    signal explicitStateChange(string newstate)

    function notifyMessage() {
        if (state !== "Messaging") {
            messagingText.color = "cyan";
        }
    }

    function explicitSetState(s) {
        if (state !== s) {
            SoundEffectProxy.tack();
            state = s;
            if (state === "Messaging") {
                messagingText.color = "white";
            }
            explicitStateChange(s);
        }
    }

    states: [
        State {
            name: "Assistance"
            PropertyChanges {
                target: bt
                x: lOAArea.x
            }
        },
        State {
            name: "Messaging"
            PropertyChanges {
                target: bt
                x: mSGArea.x
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            target: bt
            properties: "x"
            duration: 100
        }
    }

    MouseArea {
        id: lOAArea
        x: frame.border.width
        y: 0
        width: bt.width
        height: parent.height
        enabled: frame.opacity > 0
        onClicked: {
            explicitSetState("Assistance");
        }
        Text {
            anchors.fill: parent
            color: "white"
            font.bold: false
            text: "Assistance".toUpperCase()
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 12
            font.pixelSize: 12
            fontSizeMode: Text.HorizontalFit
        }
    }

    MouseArea {
        id: mSGArea
        x: frame.border.width + bt.width
        y: 0
        width: bt.width
        height: parent.height
        enabled: frame.opacity > 0
        onClicked: {
            explicitSetState("Messaging");
        }
        Text {
            id: messagingText
            anchors.fill: parent
            color: "white"
            font.bold: false
            text: "Messaging".toUpperCase()
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 12
            font.pixelSize: 12
            fontSizeMode: Text.HorizontalFit
        }
    }

    Rectangle {
        id: bt
        x: 2
        height: parent.height - parent.border.width * 2
        y: parent.border.width
        width: (parent.width - 2 * parent.border.width) / 2
        radius: 1
        color: "white"
        Text {
            anchors.fill: parent
            color: "black"
            font.bold: true
            text: frame.state.toString().toUpperCase()
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 12
            font.pixelSize: 12
            fontSizeMode: Text.HorizontalFit
        }
    }
}
