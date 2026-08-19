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
import "../widgets"
import "../../"

Item {
    id: frame
    width: 960
    height: 540
    visible: SettingsManager.assistancepanelsvisible

    property string activeLOA: ""
    property bool assistanceVisible: true
    property bool chatVisible: true

    Component.onCompleted: {
        EventBus.subU("automation.loa.active", (pname, pvalue) => {
            activeLOA = pvalue;
        });
        EventBus.subU("interface.assistancebox.visible", (pname, pvalue) => {
            assistanceVisible = pvalue;
        });
        EventBus.subU("interface.chatbox.visible", (pname, pvalue) => {
            chatVisible = pvalue;
        });
        EventBus.subU("interface.messaginginfront.enabled", (pname, pvalue) => {
            if (pvalue) {
                chatloaswitch.explicitSetState("Messaging");
            } else {
                chatloaswitch.explicitSetState("Assistance");
            }
        });
        EventBus.subU("interface.alternatemessaging.visible", (pname, pvalue) => {
            if (!pvalue) {
                messagingbox.visible = false; // Hide messaging box if not in alternate messaging
            }
        });
        EventBus.subN("chat", (event, payload) => {
            if (SettingsManager.alternatemessaging) {
                if (chatVisible) {
                    chatloaswitch.notifyMessage();
                    SoundEffectProxy.tone();
                }
            }
        });
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
        x: 10
        y: 10
        width: 940
        height: 520
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: "black"
        border.width: 2
        color: "#AAAAAA"

        Item {
            width: 930
            height: 510
            anchors.centerIn: parent

            TwoSlideSwitch {
                id: chatloaswitch
                x: 745
                y: 8
                z: 200
                width: 180
                height: 30
                visible: frame.chatVisible && SettingsManager.alternatemessaging && frame.assistanceVisible
                onExplicitStateChange: function (newstate) {
                    if (newstate === "Messaging") {
                        messagingbox.visible = true;
                        EventBus.sendLocalNotification("messagingBoxVisible");
                    } else {
                        messagingbox.visible = false;
                        EventBus.sendLocalNotification("messagingBoxHidden");
                    }
                }
            }

            Rectangle {
                id: messagingbox
                anchors.fill: parent
                color: "#AAAAAA"
                visible: frame.chatVisible && SettingsManager.alternatemessaging && (SettingsManager.messaginginfront || !frame.assistanceVisible)
                z: 99

                Text {
                    id: messagingLabel
                    y: 10
                    x: 4
                    text: qsTr("Team Messaging")
                    color: "black"
                    font.pointSize: 16
                    font.bold: true
                }

                Item {
                    y: 50
                    height: parent.height - 60
                    width: parent.width
                    MessagingBox {
                        anchors.fill: parent
                    }
                }
            }

            LOAInterface {
                id: loa1interface
                anchors.fill: parent
                visible: frame.assistanceVisible && (frame.activeLOA === "loa1")
                afiraName: qsTr("AFIRA-Messages <LOA_1>")
                showError: false
            }

            LOAInterface {
                id: loa2interface
                anchors.fill: parent
                visible: frame.assistanceVisible && (frame.activeLOA === "loa2")
                afiraName: qsTr("AFIRA-Messages <LOA_2>")
                showError: true
                showCancelButton: true
            }

            LOAInterface {
                id: loa3interface
                anchors.fill: parent
                visible: frame.assistanceVisible && (frame.activeLOA === "loa3")
                afiraName: qsTr("AFIRA-Messages <LOA_3>")
                showError: true
                showErrorName: true
                showCancelButton: true
            }

            LOAInterface {
                id: loa4interface
                anchors.fill: parent
                visible: frame.assistanceVisible && (frame.activeLOA === "loa4")
                afiraName: qsTr("AFIRA-Messages <LOA_4>")
                showError: true
                showErrorName: true
                showSuggestions: true
                showCancelButton: true
            }

            LOAInterface {
                id: loa5interface
                anchors.fill: parent
                visible: frame.assistanceVisible && (frame.activeLOA === "loa5")
                afiraName: qsTr("AFIRA-Messages <LOA_5>")
                showError: true
                showErrorName: true
                showAssistedSuggestions: true
                showAssistedControlMessages: true
                showCancelButton: true
                showAcceptButton: true
            }

            LOAInterface {
                id: loa6interface
                anchors.fill: parent
                visible: frame.assistanceVisible && (frame.activeLOA === "loa6")
                afiraName: qsTr("AFIRA-Messages <LOA_6>")
                showError: true
                showErrorName: true
                showAssistedSuggestions: true
                showAssistedControlMessages: true
                showCancelButton: true
                showVetoButton: true
            }
        }
    }
}
