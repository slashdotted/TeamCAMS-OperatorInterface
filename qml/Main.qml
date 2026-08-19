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
import QtQuick.Window
import QtQuick.Controls

import "views"
import "utils"
import "qrc:///qml/js/Utils.js" as Utils

Window {
    id: root

    property string authuser
    property variant layouts: ["Contents.qml", "Contents.qml", "Contents.qml", "SystemOverview.qml", "CommandPanel.qml", "LOAFrame.qml", "LOAPanel.qml", "LOAPanelExt.qml", "CommandPanelExt.qml", "LinePlot.qml", "RepairTaskPanel.qml", "N2LoggingTaskPanel.qml", "TransmissionTaskPanel.qml"]
    property bool chatboxAccessible: true
    property string simstate

    visible: true
    //visibility: SettingsManager.fullscreen ? "FullScreen" : Window.Windowed
    title: SettingsManager.alternatemessaging ? "TeamCAMS Client (F11 Toggle Fullscreen) " + authuser + simstate : "TeamCAMS Client (F11 Toggle Fullscreen, F4 Messaging, F6 Exit) " + authuser + simstate
    color: "#000000"
    //flags: SettingsManager.fullscreen ? Qt.FramelessWindowHint | Qt.Window : Qt.Window
    width: 960
    height: 540

    Image {
        anchors.fill: parent
        source: "qrc:///qml/assets/images/metal-texture.jpg"
        fillMode: Image.Tile
    }

    ToolTip {
        id: notificationToast

        x: (parent.width - width) / 2
        y: parent.height - height - 40

        timeout: 5000

        contentItem: Text {
            text: notificationToast.text
            color: "white"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
        }

        background: Rectangle {
            color: "#323232"
            radius: 8
            border.color: "#444444"
        }
    }

    function showNotification(message) {
        notificationToast.text = message;
        notificationToast.open(); // Mostra il toast e fa partire il timer del timeout
    }

    Shortcut {
        sequence: "F11"
        onActivated: function () {
            SettingsManager.fullscreen = !SettingsManager.fullscreen;
            if (root.visibility == Window.Maximized) {
                root.visibility = "FullScreen";
            } else {
                root.visibility = Window.Maximized;
            }
        }
    }

    Shortcut {
        sequence: "F2"
        onActivated: function () {
            EventBus.sendLocalNotification("showOverlay", {
                "urls": ["file://./tutorial/targetlevels_highlight.png_pm.png"]
            });
        }
    }

    Shortcut {
        sequence: "F3"
        onActivated: {
            EventBus.sendLocalNotification("showWebDialog", {
                "url": "http://www.syscall.org"
            });
        }
    }

    Shortcut {
        sequence: "F1"
        onActivated: {
            EventBus.sendLocalNotification("showAboutDialog");
        }
    }

    Shortcut {
        sequence: "F4"
        onActivated: {
            if (!SettingsManager.alternatemessaging) {
                EventBus.sendLocalNotification("toggleMessagingDialog");
            }
        }
    }

    Shortcut {
        sequence: "F6"
        onActivated: {
            EventBus.log("userui", JSON.stringify({
                "key": "client.running",
                "value": false
            }));
            Qt.quit();
        }
    }

    GenericLayout {
        id: contents
        property double scaleFactor: Math.min(parent.width / width, parent.height / height)
        transform: Scale {
            xScale: contents.scaleFactor
            yScale: contents.scaleFactor
            origin.x: contents.width / 2
            origin.y: contents.height / 2
        }
        anchors.centerIn: parent
        componentName: "Contents.qml"
    }

    DialogProxy {
        id: dialogProxy
        property double scaleFactor: Math.min(root.width / 1920, root.height / 1080)

        /*transform: Scale {  xScale: dialogProxy.scaleFactor
                            yScale: dialogProxy.scaleFactor
                            origin.x: 960
                            origin.y: 540
                         }*/
        anchors.centerIn: parent
    }

    Component.onCompleted: {
        var items = ["Contents.qml", "SystemOverview.qml", "CommandPanel.qml", "LOAFrame.qml", "LOAPanel.qml", "LOAPanelExt.qml", "CommandPanelExt.qml", "LinePlot.qml", "RepairTaskPanel.qml", "N2LoggingTaskPanel.qml", "TransmissionTaskPanel.qml"];
        //var layout = SettingsManager.layout

        /*if (layout > 0 && layout < items.length) {
            contents.componentName = items[layout]
            Qt.inputMethod.hide()
        }*/
        // Register event bus callbacks
        EventBus.subN("toast", (event, payload) => {
            root.showNotification(payload.message);
        });

        EventBus.subN("chat", (event, payload) => {
            if (payload.recipient === "" || payload.sender === EventBus.getStored("user.alias") || payload.recipient === EventBus.getStored("user.alias")) {
                Inbox.messageModel.append({
                    "sender": payload.sender,
                    "timestamp": Utils.formatTimestamp(EventBus.getStored("system.timestamp")),
                    "message": payload.message,
                    "recipient": payload.recipient,
                    "isownmessage": payload.sender === EventBus.getStored("user.alias")
                });
                EventBus.sendLocalNotification("incomingChatMessage", payload);
            }
        });

        EventBus.subN("start", (event, payload) => {
            Inbox.messageModel.clear();
            root.authuser = " - Connected as: " + EventBus.getStored("user.username") + " (" + EventBus.getStored("user.alias") + ")";
        });
        EventBus.subN("end", (event, payload) => {
            root.authuser = "";
        });
        EventBus.subU("user.access", (pname, pvalue) => {
            if (pvalue < 0) {
                contents.componentName = root.layouts[1];
            } else if (pvalue === 13) {
                contents.componentName = "DisabledUI.qml";
            } else {
                contents.componentName = root.layouts[pvalue];
            }
        });
        EventBus.subU("user.alias", (pname, pvalue) => {
            root.authuser = " - Connected as: " + EventBus.getStored("user.username") + " (" + EventBus.getStored("user.alias") + ")";
        });
        EventBus.subU("system.state", (pname, pvalue) => {
            root.simstate = " [" + pvalue + "]";
        });
        EventBus.subU("interface.chatbox.visible", (pname, pvalue) => {
            root.chatboxAccessible = pvalue;
        });
    }
}
