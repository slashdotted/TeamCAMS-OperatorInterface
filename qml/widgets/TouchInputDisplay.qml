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
    property int spacing: 1
    property int digits: 5
    property string baseLCDimage: "qrc:///qml/assets/images/alt_lcd_"
    signal logged

    Rectangle {
        id: main
        color: "#c2ccbd"
        anchors.fill: parent
        anchors.margins: 0
        border.width: 2
        border.color: "black"
        radius: 5
        Repeater {
            id: lcdrepeater
            model: root.digits
            Image {
                source: baseLCDimage + "-.svg"
                width: (root.width - root.spacing * (lcdrepeater.count + 2)) / lcdrepeater.count
                height: parent.height - 2 * root.spacing
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                sourceSize: Qt.size(width, height)
                smooth: true
                x: parent.border.width + root.spacing + index * (width + spacing)
                y: root.spacing

                MouseArea {
                    id: lcddisplayarea
                    anchors.fill: parent
                    onWheel: {
                        if (wheel.angleDelta.y > 0) {
                            var newvalue = root.value + Math.pow(10, root.digits - index - 1);
                            var maxvalue = Math.pow(10, root.digits);
                            if (newvalue < maxvalue) {
                                root.value = newvalue;
                            }
                        } else {
                            var decrement = Math.pow(10, root.digits - index - 1);
                            if (root.value >= decrement) {
                                root.value -= decrement;
                            }
                        }
                    }
                    onClicked: {
                        keyboardinputbox.forceActiveFocus();
                    }
                }
            }
        }
    }

    TextInput {
        id: keyboardinputbox
        anchors.fill: parent
        echoMode: TextInput.NoEcho
        cursorVisible: false
        selectByMouse: false
        onSelectedTextChanged: {
            deselect();
        }
        onCursorPositionChanged: {
            cursorPosition = text.length;
        }
        focus: true
        inputMethodHints: Qt.ImhDigitsOnly
        onTextChanged: {
            if (text.length > 0) {
                if (!text.charAt(text.length - 1).match("[0-9]")) {
                    text = text.slice(0, -1);
                }

                if (text.length > root.digits) {
                    text = text.substr(text.length - root.digits);
                }
                root.value = text;
            }
        }

        onAccepted: {
            focus = false;
            logged(root.value);
        }

        onFocusChanged: {
            if (keyboardinputbox.focus) {
                if (root.value < 0) {
                    root.value = 0;
                }
            } else {
                displayValue(root.value);
            }
        }
    }

    function clear() {
        logInputBox.value = 0;
        logInputBox.focus = false;
        displayValue(-1);
    }

    Component.onCompleted: {
        displayValue(value);
    }

    function pad(n, width, z) {
        z = z || '0';
        n = n + '';
        return;
    }

    function displayValue(val) {
        var j;
        if (val < 0) {
            for (j = 0; j < lcdrepeater.count; j++) {
                lcdrepeater.itemAt(j).source = baseLCDimage + "-.svg";
            }
        } else {
            var v;
            for (j = 0; j < lcdrepeater.count; j++) {
                lcdrepeater.itemAt(j).source = baseLCDimage + "off.svg";
            }
            val = val + '';
            v = val.length >= root.digits ? val : new Array(root.digits - val.length + 1).join('0') + val;
            var pos = 1;
            for (var i = v.length - 1; i >= 0; i--) {
                var c = v.charAt(i);
                lcdrepeater.itemAt(lcdrepeater.count - pos).source = baseLCDimage + "" + c + ".svg";
                pos++;
            }
        }
    }

    Timer {
        id: blinkTimer
        property bool visible: true
        interval: 500
        repeat: true
        running: false
        onTriggered: function () {
            visible = !visible;
            if (visible) {
                displayValue(root.value);
            } else {
                for (var j = 0; j < lcdrepeater.count; j++) {
                    lcdrepeater.itemAt(j).source = baseLCDimage + "off.svg";
                }
            }
        }
    }

    onValueChanged: {
        if (value < 0) {
            value = 0;
        }
        displayValue(value);
        keyboardinputbox.text = value;
    }
}
