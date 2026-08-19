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

    property string readytogo: qsTr("ready to go")
    property string initiated: qsTr("initiated")
    property string done: qsTr("done")

    property int step: 0

    onSuggestion1Changed: {
        reset();
    }

    Timer {
        id: stepTimer
        interval: 1000
        triggeredOnStart: true
        repeat: true
        onTriggered: function () {
            switch (step) {
            case 0:
                suggestionBox1StateLabel.text = initiated;
                break;
            case 1:
                suggestionBox1StateLabel.text = done;
                suggestionBox2StateLabel.text = initiated;
                break;
            case 2:
                suggestionBox2StateLabel.text = done;
                suggestionBox3StateLabel.text = initiated;
                break;
            case 3:
                suggestionBox3StateLabel.text = done;
                break;
            default:
                stepTimer.stop();
            }
            step += 1;
        }
    }

    function start() {
        if (!stepTimer.running) {
            step = 0;
            stepTimer.start();
        }
    }

    function reset() {
        suggestionBox1StateLabel.text = readytogo;
        suggestionBox2StateLabel.text = readytogo;
        suggestionBox3StateLabel.text = readytogo;
    }

    RowLayout {
        visible: (suggestion1 != "")
        spacing: 10

        Rectangle {
            id: suggestionBox1state
            width: 130
            height: 50
            border.width: 2
            border.color: "black"
            color: "yellow"

            Text {
                id: suggestionBox1StateLabel
                x: 10
                font.pointSize: 16
                anchors.centerIn: parent
                width: parent.width - 10
                height: parent.height - 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "blue"

                textFormat: Text.RichText
            }
        }

        Rectangle {
            id: suggestionBox1
            Layout.fillWidth: true
            height: 50
            border.width: 2
            border.color: "black"
            color: "#999999"

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
    }

    RowLayout {
        visible: (suggestion2 != "")
        spacing: 10

        Rectangle {
            id: suggestionBox2state
            width: 130
            height: 50
            border.width: 2
            border.color: "black"
            color: "yellow"

            Text {
                id: suggestionBox2StateLabel
                x: 10
                font.pointSize: 16
                anchors.centerIn: parent
                width: parent.width - 10
                height: parent.height - 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "blue"

                textFormat: Text.RichText
            }
        }

        Rectangle {
            id: suggestionBox2
            Layout.fillWidth: true
            height: 50
            border.width: 2
            border.color: "black"
            color: "#999999"

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
    }

    RowLayout {
        visible: (suggestion3 != "")
        spacing: 10

        Rectangle {
            id: suggestionBox3state
            width: 130
            height: 50
            border.width: 2
            border.color: "black"
            color: "yellow"

            Text {
                id: suggestionBox3StateLabel
                x: 10
                font.pointSize: 16
                anchors.centerIn: parent
                width: parent.width - 10
                height: parent.height - 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "blue"

                textFormat: Text.RichText
            }
        }

        Rectangle {
            id: suggestionBox3
            Layout.fillWidth: true
            height: 50
            border.width: 2
            border.color: "black"
            color: "#999999"

            Text {
                text: suggestion3
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
    }
}
