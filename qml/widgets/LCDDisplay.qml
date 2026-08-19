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
import "../../"

Item {
    id: root
    property string name: ""
    property bool hidden: true
    property int value: 0
    property int spacing: Math.floor(width / 40)
    property int digits: 6
    property string baseLCDimage: "qrc:///qml/assets/images/alt_lcd_"

    Rectangle {
        id: main
        color: "#c2ccbd"
        anchors.fill: parent
        border.width: 2
        border.color: "black"
        radius: 5
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        Repeater {
            id: lcdrepeater
            model: root.digits
            Image {
                source: baseLCDimage + "off.svg"
                width: (root.width - root.spacing * (lcdrepeater.count + 2)) / lcdrepeater.count
                height: parent.height - 2 * root.spacing
                fillMode: Image.PreserveAspectFit
                sourceSize.width: (root.width - root.spacing * (lcdrepeater.count + 2)) / lcdrepeater.count
                sourceSize.height: parent.height - 2 * root.spacing
                antialiasing: true
                x: parent.border.width + root.spacing + index * (width + spacing)
                y: root.spacing
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            hidden = false;
            displayValue(value);
            hideTimer.restart();
            SoundEffectProxy.press();
            EventBus.log("userui", JSON.stringify({
                "key": root.name + ".visible",
                "value": true
            }));
        }

        onReleased: {
            SoundEffectProxy.release();
        }
    }

    Timer {
        id: hideTimer
        interval: 15000
        repeat: false
        running: false
        onTriggered: function () {
            EventBus.log("userui", JSON.stringify({
                "key": root.name + ".visible",
                "value": true
            }));
            hidden = true;
            displayValue(value);
        }
    }

    Component.onCompleted: {
        displayValue(value);
    }

    function displayValue(val) {
        var v;
        var j;
        if (hidden) {
            for (j = 0; j < lcdrepeater.count; j++) {
                lcdrepeater.itemAt(j).source = baseLCDimage + "-.svg";
            }
        } else {
            for (j = 0; j < lcdrepeater.count; j++) {
                lcdrepeater.itemAt(j).source = baseLCDimage + "off.svg";
            }
            v = Math.floor(val).toString().substring(0, root.digits);
            var pos = 1;
            for (var i = v.length - 1; i >= 0; i--) {
                var c = v.charAt(i);
                lcdrepeater.itemAt(lcdrepeater.count - pos).source = baseLCDimage + "" + c + ".svg";
                pos++;
            }
        }
    }

    onValueChanged: {
        displayValue(value);
    }
}
