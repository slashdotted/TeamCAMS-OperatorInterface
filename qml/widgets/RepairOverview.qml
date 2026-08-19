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
    id: item1
    width: 840
    height: 300
    property string selectedComponentName: ""

    signal componentSelected(string cname)

    function selected(cname) {
        selectedComponentName = cname;
        componentSelected(cname);
    }

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
        anchors.fill: parent
        color: "#AAAAAA"
        border.width: 2
        border.color: "black"

        Rectangle {
            id: o2tank
            width: 50
            height: 70
            radius: 2
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#ffffff"
                }

                GradientStop {
                    position: 1
                    color: "#000000"
                }
            }
            z: 1
            scale: 1
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.top: parent.top
            anchors.topMargin: 49
            border.width: 1
        }

        Rectangle {
            id: n2tank
            y: 193
            width: 50
            height: 70
            radius: 2
            z: 1
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#ffffff"
                }

                GradientStop {
                    position: 1
                    color: "#000000"
                }
            }
            anchors.left: parent.left
            anchors.leftMargin: 51
            anchors.bottomMargin: 6
            border.width: 1
        }

        SimpleImageButton {
            id: o2tankvalve
            objectName: "o2tankvalve"
            x: 106
            y: 71
            width: 38
            height: 26
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            highlighted: selectedComponentName === objectName
            source: "qrc:///qml/assets/images/valve.svg"
            onClicked: {
                selected(objectName);
            }
        }

        Rectangle {
            id: rectangle1
            x: 97
            y: 79
            width: 221
            height: 9
            color: "#909090"
            border.width: 0
        }

        Rectangle {
            id: rectangle2
            x: 97
            y: 223
            width: 221
            height: 9
            color: "#909090"
            border.width: 0
        }

        SimpleImageButton {
            id: n2tankvalve
            objectName: "n2tankvalve"
            x: 106
            y: 215
            width: 38
            height: 26
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            highlighted: selectedComponentName === objectName
            source: "qrc:///qml/assets/images/valve.svg"
            onClicked: {
                selected(objectName);
            }
        }

        SimpleImageButton {
            id: o2valve
            objectName: "o2valve"
            x: 223
            y: 71
            width: 38
            height: 26
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            highlighted: selectedComponentName === objectName
            source: "qrc:///qml/assets/images/valve.svg"
            onClicked: {
                selected(objectName);
            }
        }

        SimpleImageButton {
            id: n2valve
            objectName: "n2valve"
            x: 223
            y: 215
            width: 38
            height: 26
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            highlighted: selectedComponentName === objectName
            source: "qrc:///qml/assets/images/valve.svg"
            onClicked: {
                selected(objectName);
            }
        }

        Rectangle {
            id: rectangle3
            x: 309
            y: 79
            width: 9
            height: 153
            color: "#909090"
            border.width: 0
        }

        SimpleImageButton {
            id: mixer
            objectName: "mixer"
            x: 297
            y: 139
            width: 33
            height: 33
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            highlighted: selectedComponentName === objectName
            source: "qrc:///qml/assets/images/mixer.svg"
            onClicked: {
                selected(objectName);
            }
        }

        Rectangle {
            id: rectangle4
            x: 324
            y: 151
            width: 158
            height: 9
            color: "#909090"
            border.width: 0
        }

        Rectangle {
            id: o2tank1
            x: -3
            y: 1
            width: 294
            height: 146
            color: "#89916e"
            radius: 7
            z: 1
            anchors.leftMargin: 481
            anchors.left: parent.left
            anchors.top: parent.top
            border.width: 1
            scale: 1
            anchors.topMargin: 86
        }

        Text {
            id: text2
            x: 59
            y: 212
            width: 34
            height: 25
            color: "#ffffff"
            text: qsTr("N<sub>2</sub>")
            z: 1
            font.bold: true
            font.pixelSize: 18
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
        }

        SimpleImageButton {
            id: heater
            objectName: "heater"
            x: 481
            y: 49
            width: 30
            height: 31
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            sourceSize.height: height
            source: "qrc:///qml/assets/images/heater.svg"
            highlighted: selectedComponentName === objectName
            onClicked: {
                selected(objectName);
            }
        }

        SimpleImageButton {
            id: cooler
            objectName: "cooler"
            x: 613
            y: 49
            width: 30
            sourceSize.width: width
            sourceSize.height: height
            height: 31
            source: "qrc:///qml/assets/images/cooler.svg"
            fillMode: Image.PreserveAspectFit
            highlighted: selectedComponentName === objectName
            onClicked: {
                selected(objectName);
            }
        }

        SimpleImageButton {
            id: dehumidifier
            objectName: "dehumidifier"
            x: 745
            y: 49
            width: 30
            height: 31
            source: "qrc:///qml/assets/images/dehumidifier.svg"
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            highlighted: selectedComponentName === objectName
            onClicked: {
                selected(objectName);
            }
        }

        SimpleImageButton {
            id: vent
            objectName: "vent"
            x: 481
            y: 238
            width: 30
            height: 31
            source: "qrc:///qml/assets/images/vent.svg"
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            highlighted: selectedComponentName === objectName
            onClicked: {
                selected(objectName);
            }
        }

        SimpleImageButton {
            id: scrubber
            objectName: "scrubber"
            x: 613
            y: 238
            width: 30
            height: 31
            source: "qrc:///qml/assets/images/scrubber.svg"
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
            highlighted: selectedComponentName === objectName
            onClicked: {
                selected(objectName);
            }
        }

        Text {
            id: text1
            x: 57
            y: 71
            width: 34
            height: 25
            color: "#ffffff"
            text: qsTr("O<sub>2</sub>")
            z: 2
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            font.pixelSize: 18
        }

        Text {
            id: text7
            x: 8
            y: 8
            text: qsTr("Select component for repair")
            font.bold: true
            font.pixelSize: 17
        }
    }
}
