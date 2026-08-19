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

Item {
    id: root
    property bool active: false
    property bool blink: false
    property string color: "red"
    property bool blinkstatus: true

    Rectangle {
        id: circle
        anchors.fill: parent
        anchors.centerIn: parent
        border.color: "black"
        border.width: 2
        anchors.margins: parent.width * 0.15
        color: "#505050"
        radius: parent.width * 0.5
    }

    Image {
        id: led
        anchors.fill: parent
        smooth: true
        source: enabled && active && blinkstatus ? "qrc:///qml/assets/images/lamp_" + parent.color + "_on.png" : "qrc:///qml/assets/images/lamp_" + parent.color + "_off.png"
    }

    MultiEffect {
        source: led
        anchors.fill: root
        shadowBlur: 1.0
        shadowEnabled: true
        shadowColor: "#80000000"
        shadowVerticalOffset: 3
        shadowHorizontalOffset: -3
    }

    Timer {
        id: blinkTimer
        interval: 1000
        running: parent.blink
        triggeredOnStart: true
        repeat: true
        onTriggered: function () {
            parent.blinkstatus = !parent.blinkstatus;
        }
    }

    onBlinkChanged: function () {
        if (blink) {
            blinkTimer.start();
        } else {
            blinkTimer.stop();
            blinkStatus = true;
        }
    }
}
