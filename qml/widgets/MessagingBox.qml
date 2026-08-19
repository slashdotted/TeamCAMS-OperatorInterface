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
import QtQuick.Layouts
import Qt.labs.qmlmodels
import "../../"

Item {
    id: root
    onVisibleChanged: {
        refresh();
        EventBus.log("userui", JSON.stringify({
            "key": "chat.visible",
            "value": visible
        }));
    }

    function updateUserlist(users) {
        userlistmodel.clear();
        if (!users)
            return;
        userlistmodel.append({
            "text": qsTr("Everyone"),
            "recipient": ""
        });
        if (users.length !== 0) {
            for (var i = 0; i < users.length; i++) {
                if (users[i] !== EventBus.getStored("user.alias")) {
                    userlistmodel.append({
                        "text": users[i],
                        "recipient": users[i]
                    });
                }
            }
        }
        userlist.update();
        userlist.currentIndex = 0;
    }

    function sendMessage() {
        if (messageInput.text.trim() !== "") {
            var recipient = userlistmodel.get(userlist.currentIndex).recipient;
            if (userlist.currentIndex === 0) {
                recipient = "";
            }
            EventBus.sendCommand("trigger", "chat", {
                "sender": EventBus.getStored("user.alias"),
                "message": messageInput.text,
                "recipient": recipient
            });
            messageInput.text = "";
        }
    }

    function updateFocus(v) {
        if (v) {
            messageInput.forceActiveFocus();
        } else {
            messageInput.focus = false;
        }
        if (v) {
            chatBox.positionViewAtEnd();
        }
    }

    function refresh() {
        updateUserlist(EventBus.getStored("secondarytasks.messaging.users"));
        userlist.currentIndex = 0;
        chatBox.positionViewAtEnd();
        updateFocus(visible);
    }

    DelegateChooser {
        id: bubbleChooser
        role: "isownmessage"

        DelegateChoice {
            roleValue: true
            OwnMessageBubble {
                width: ListView.view.width
            }
        }
        DelegateChoice {
            roleValue: false
            OtherMessageBubble {
                width: ListView.view.width
            }
        }
    }

    Column {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            width: parent.width - 20
            height: parent.height - pane.height - parent.spacing
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "black"
            ListView {
                id: chatBox
                clip: true
                anchors.fill: parent
                anchors.margins: 10
                verticalLayoutDirection: ListView.TopToBottom
                spacing: 12
                model: Inbox.messageModel
                ScrollBar.vertical: ScrollBar {}
                delegate: bubbleChooser
                onCountChanged: {
                    var newIndex = count - 1; // last index
                    positionViewAtEnd();
                    currentIndex = newIndex;
                }
            }
        }

        Rectangle {
            id: pane
            width: parent.width - 20
            height: 60
            color: "#AAAAAA"
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "black"
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    id: nameLabel
                    text: EventBus.getStoredOr("user.alias", "")
                }

                TextField {
                    id: messageInput
                    Layout.fillWidth: true
                    KeyNavigation.tab: userlist
                    onAccepted: {
                        root.sendMessage();
                    }
                }

                ComboBox {
                    id: userlist
                    textRole: 'text'
                    model: ListModel {
                        id: userlistmodel
                    }
                    Component.onCompleted: {
                        root.updateUserlist(EventBus.getStored("secondarytasks.messaging.users"));
                        currentIndex = 0;
                    }
                    KeyNavigation.tab: sendButton
                    width: 140
                    height: 30
                }

                SimpleButton {
                    id: sendButton
                    width: 80
                    height: 30
                    text: "Send"
                    onClicked: {
                        root.sendMessage();
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        refresh();
        EventBus.subU("secondarytasks.messaging.users", (pname, pvalue) => updateUserlist(pvalue));
        EventBus.subU("user.alias", (pname, pvalue) => nameLabel.text = pvalue);
    }
}
