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
import "../utils"

Item {
    id: root

    property bool errorDetected: false
    property string errorDetectedMessage: ""
    property string afiraName: ""
    property int detectionTime: -1
    property int timeSinceFailure: -1
    property bool showErrorName: false
    property bool showError: false
    property bool showSuggestions: false
    property bool showAssistedSuggestions: false
    property bool showAssistedControlMessages: false
    property bool activationTimeout: false
    property bool controlsVisible: false
    property bool guidanceVisible: false
    property bool showVetoButton: false
    property bool showAcceptButton: false
    property bool showCancelButton: false
    property bool isRepairing: false
    property string loaEndMessage: ""

    onErrorDetectedChanged: {
        if (errorDetected && visible) {
            controlsVisible = true;
            guidanceVisible = true;
            if (showVetoButton) {
                countDownBox.counter = 60;
                countDownTimer.running = true;
                countDownTimer.restart();
            }
        } else {
            countDownTimer.stop();
        }
    }

    onVisibleChanged: {
        if (visible && errorDetected) {
            controlsVisible = true;
            guidanceVisible = true;
            if (showVetoButton) {
                countDownBox.counter = 60;
                countDownTimer.running = true;
                countDownTimer.restart();
            }
        } else if (!visible || !errorDetected) {
            countDownTimer.stop();
        }
    }

    anchors.fill: parent

    Text {
        id: afiraLabel
        y: 10
        x: 4
        text: root.afiraName
        color: "black"
        font.pointSize: 16
        font.bold: true
    }

    Text {
        id: loaEndMessageText
        text: root.loaEndMessage
        font.pointSize: 24
        anchors.centerIn: parent
        textFormat: Text.RichText
        color: "black"
        visible: root.loaEndMessage != ""
        font.bold: true
    }

    Text {
        id: failureMessage
        width: parent.width
        y: 70
        text: root.showErrorName ? qsTr("Failure!") + " " + root.errorDetectedMessage : qsTr("Failure!")
        font.pointSize: 24
        horizontalAlignment: Text.Center
        color: "red"
        visible: root.guidanceVisible && root.showError && root.errorDetected
        font.bold: true
    }

    Text {
        id: timeMessage
        width: parent.width
        y: 110
        text: qsTr("Time since failure occured:")
        font.pointSize: 16
        horizontalAlignment: Text.Center
        color: "red"
        visible: root.guidanceVisible && root.showError && root.errorDetected
    }

    function formatTimestamp(ts) {
        if (ts < 0)
            return "";
        ts = ((ts % (3600 * 24)) + 3600 * 24) % (3600 * 24);
        var hours = Math.floor(ts / 3600);
        var minutes = Math.floor((ts - (hours * 3600)) / 60);
        var seconds = ts - hours * 3600 - minutes * 60;
        var hh = "" + hours;
        var mm = "" + minutes;
        var ss = "" + seconds;
        if (hours < 10) {
            hh = "0" + hh;
        }
        if (minutes < 10) {
            mm = "0" + mm;
        }
        if (seconds < 10) {
            ss = "0" + ss;
        }
        return hh + ":" + mm + ":" + ss;
    }

    LOASimpleSuggestionBox {
        id: simplesuggestionbox
        visible: root.guidanceVisible && root.showError && root.errorDetected && root.showSuggestions
    }

    LOASuggestionBox {
        id: suggestionbox
        visible: root.guidanceVisible && root.showError && root.errorDetected && root.showAssistedSuggestions
    }

    SimpleButton {
        id: acceptButton
        label: qsTr("Accept")
        height: 50
        width: 100
        x: parent.width - 220
        y: parent.height - 60
        visible: !root.isRepairing && root.controlsVisible && root.showAcceptButton && root.errorDetected
        onClicked: {
            EventBus.sendCommand("trigger", "loa accept");
            suggestionbox.start();
            root.controlsVisible = false;
        }
    }

    SimpleButton {
        id: vetoButton
        label: qsTr("Veto")
        height: 50
        width: 100
        x: parent.width - 220
        y: parent.height - 60
        visible: !root.isRepairing && root.controlsVisible && root.showVetoButton && root.errorDetected
        onClicked: {
            EventBus.sendCommand("trigger", "loa veto");
            countDownTimer.stop();
        }
    }

    SimpleButton {
        id: cancelButton
        label: qsTr("Cancel")
        height: 50
        width: 100
        x: parent.width - 110
        y: parent.height - 60
        visible: !root.isRepairing && root.controlsVisible && root.showCancelButton && root.errorDetected
        onClicked: {
            EventBus.sendCommand("trigger", "loa cancel");
            root.controlsVisible = false;
            root.guidanceVisible = false;
            countDownTimer.stop();
        }
    }

    Rectangle {
        id: controlStepMessageBox
        width: parent.width - 20
        height: 50
        y: parent.height - 140
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: "black"
        color: "#999999"
        visible: root.guidanceVisible && root.showAssistedControlMessages && root.errorDetected

        Text {
            id: controlStepMessage
            x: 10
            font.pointSize: 16
            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "black"

            textFormat: Text.RichText
            text: ""
        }
    }

    Text {
        id: controlStepMessageLabel
        visible: root.guidanceVisible && root.showAssistedControlMessages && root.errorDetected
        x: controlStepMessageBox.x
        y: controlStepMessageBox.y - 25
        font.pointSize: 16
        color: "black"
        textFormat: Text.RichText
        text: qsTr("AFIRA Control Interventions:")
    }

    Rectangle {
        id: countDownBox
        width: 500
        height: 50
        x: controlStepMessageBox.x
        y: parent.height - 60
        border.width: 2
        border.color: "black"
        color: "red"
        visible: countDownTimer.running && root.showAssistedControlMessages && root.errorDetected
        property int counter: 60

        Text {
            id: countDownMessage
            x: 10
            font.pointSize: 16
            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: "black"

            textFormat: Text.RichText
            text: qsTr("Countdown until action is implemented: %1 sec").arg(countDownBox.counter)
        }

        SystemTimer {
            id: countDownTimer
            interval: 1000
            repeat: true
            onTriggered: function () {
                countDownBox.counter -= 1;
                if (countDownBox.counter == 0) {
                    countDownTimer.stop();
                    EventBus.sendCommand("trigger", "loa accept");
                    //suggestionbox.start()
                    root.controlsVisible = false;
                }
            }
        }
    }

    Component.onCompleted: {
        EventBus.subN("loa accept", (event, payload) => {
            suggestionbox.start();
            root.controlsVisible = false;
        });
        EventBus.subN("loa veto", (event, payload) => {
            countDownTimer.stop();
        });
        EventBus.subN("loa cancel", (event, payload) => {
            root.controlsVisible = false;
            root.guidanceVisible = false;
            countDownTimer.stop();
        });
        EventBus.subU("system.error.detectiontime", (pname, pvalue) => {
            root.detectionTime = pvalue;
        });
        EventBus.subU("system.timestamp", (pname, pvalue) => {
            var timeSinceFailure = pvalue - root.detectionTime;
            timeMessage.text = qsTr("Time since failure occured: ") + root.formatTimestamp(timeSinceFailure);
        });
        EventBus.subU("system.error.detected", (pname, pvalue) => {
            root.errorDetected = pvalue;
        });
        EventBus.subU("system.error.label", (pname, pvalue) => {
            root.errorDetectedMessage = pvalue;
        });
        EventBus.subU("automation.loa.suggestion.1", (pname, pvalue) => {
            simplesuggestionbox.suggestion1 = pvalue;
            suggestionbox.suggestion1 = pvalue;
        });
        EventBus.subU("automation.loa.suggestion.2", (pname, pvalue) => {
            simplesuggestionbox.suggestion2 = pvalue;
            suggestionbox.suggestion2 = pvalue;
        });
        EventBus.subU("automation.loa.suggestion.3", (pname, pvalue) => {
            simplesuggestionbox.suggestion3 = pvalue;
            suggestionbox.suggestion3 = pvalue;
        });
        EventBus.subU("automation.loa.message", (pname, pvalue) => {
            controlStepMessage.text = pvalue;
        });
        EventBus.subU("automation.loa.endmessage", (pname, pvalue) => {
            root.loaEndMessage = pvalue;
        });
        EventBus.subU("system.repair.label", (pname, pvalue) => {
            root.isRepairing = (pvalue !== "");
        });
    }
}
