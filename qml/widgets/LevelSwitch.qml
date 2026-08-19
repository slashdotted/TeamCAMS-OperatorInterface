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
    color: allowUserChanges ? "black" : "red"
    z: 0
    border.width: 5
    border.color: "black"
    radius: 5
    state: "standard"
    signal explicitStateChange(string newstate)
    property bool allowUserChanges: true

    states: [
        State {
            name: "high"
            PropertyChanges {
                target: bt
                x: onArea.x
            }
        },
        State {
            name: "medium"
            PropertyChanges {
                target: bt
                x: autoArea.x
            }
        },
        State {
            name: "standard"
            PropertyChanges {
                target: bt
                x: offArea.x
            }
        }
    ]

    function getStateLabel(s) {
        if (s === "standard")
            return "std";
        else
            return s;
    }

    function setState(s) {
        if (state !== s) {
            SoundEffectProxy.tack();
            state = s;
        }
    }

    function explicitSetState(s) {
        if (state !== s) {
            SoundEffectProxy.tack();
            state = s;
            explicitStateChange(s);
        }
    }
    transitions: Transition {
        NumberAnimation {
            target: bt
            properties: "x"
            duration: 100
        }
    }

    Rectangle {
        id: bt
        x: 2
        height: parent.height - parent.border.width * 2
        y: parent.border.width
        width: (parent.width - 2 * parent.border.width) / 3
        radius: 1
        color: "white"
        z: 4
        Text {
            anchors.fill: parent
            color: "black"
            font.bold: true
            text: getStateLabel(frame.state.toString()).toUpperCase()
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 12
            font.pixelSize: 12
            fontSizeMode: Text.HorizontalFit
        }
    }

    MouseArea {
        id: offArea
        x: frame.border.width
        y: 0
        width: bt.width
        height: parent.height
        z: 3
        enabled: frame.opacity > 0
        onClicked: {
            if (frame.allowUserChanges)
                frame.explicitSetState("standard");
        }
        Text {
            anchors.fill: parent
            color: "white"
            font.bold: false
            text: getStateLabel("standard").toUpperCase()
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 12
            font.pixelSize: 12
            fontSizeMode: Text.HorizontalFit
        }
    }

    MouseArea {
        id: autoArea
        x: frame.border.width + bt.width
        y: 0
        width: bt.width
        height: parent.height
        z: 3
        enabled: frame.opacity > 0
        onClicked: {
            if (frame.allowUserChanges)
                frame.explicitSetState("medium");
        }
        Text {
            anchors.fill: parent
            color: "white"
            font.bold: false
            text: getStateLabel("medium").toUpperCase()
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 12
            font.pixelSize: 12
            fontSizeMode: Text.HorizontalFit
        }
    }

    MouseArea {
        id: onArea
        x: frame.border.width + 2 * bt.width
        y: 0
        width: bt.width
        height: parent.height
        z: 3
        enabled: frame.opacity > 0
        onClicked: {
            if (frame.allowUserChanges)
                frame.explicitSetState("high");
        }
        Text {
            anchors.fill: parent
            color: "white"
            font.bold: false
            text: getStateLabel("high").toUpperCase()
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: 12
            font.pixelSize: 12
            fontSizeMode: Text.HorizontalFit
        }
    }
}
