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

pragma Singleton

import QtQuick
import QtWebSockets
import TeamCAMSOperatorInterface

Item {
    id: root

    // Simulation related events
    signal updateReceived(string pname, var pvalue)
    signal notificationReceived(string event, var payload)

    // Signals
    signal connectedAndReady
    signal disconnectedFromManager

    // Internal connection state
    property string connectionState: "Disconnected"

    // This is used to interact with the page backend
    WebSocket {
        id: socket

        onTextMessageReceived: function (message) {
            var msgObj = JSON.parse(message);
            if (msgObj.type === "popup_close") {
                EventBus.sendCommand("trigger", "popupCompleted", {});
            }
        }
    }

    // This is used to interact with the manager
    MqttProxy {
        id: mqtt

        onConnectedToBroker: function () {
            // Connected to broker, ready to connect to experiment
            mqtt.connectToExperiment(SettingsManager.experiment, SettingsManager.username, SettingsManager.password);
        }

        onDisconnectedFromBroker: function (reason) {
            root.sendLocalNotification("toast", {
                "message": reason
            });
            root.disconnectedFromManager();
            root.sendLocalNotification("showConnectionDialog");
            root.sendLocalNotification("resetConnectionDialog");
            root.sendLocalNotification("end");
        }

        onDisconnectedFromManager: function (reason) {
            root.sendLocalNotification("toast", {
                "message": reason
            });
            root.disconnectedFromManager();
            root.sendLocalNotification("showConnectionDialog");
            root.sendLocalNotification("resetConnectionDialog");
        }

        onStatusChanged: function (status) {
            if (status === "Connected") {
                // We are authenticated with the manager, ask for our current profile data
                root.connectionState = "AlmostConnected";
                mqtt.sendMessage({
                    "type": "control",
                    "key": "squawk",
                    "payload": {}
                });
            } else if (status === "Disconnected") {
                root.connectionState = "Disconnected";
                root.disconnectedFromManager();
            }
        }

        onMessageReceived: function (msg) {
            if (root.connectionState === "Disconnected") {
                // We don't expect anything
                console.error("Unexpected message in disconnected connectionState: " + msg);
            } else if (root.connectionState === "AlmostConnected") {
                if (msg.type === "control") {
                    if (msg.key === "squawk") {
                        root.connectionState = "Authenticated";
                        EventBus.clearStored();
                        root.updateReceived("user.access", msg.payload.type);
                        root.updateReceived("user.alias", msg.payload.alias);
                        root.updateReceived("user.username", msg.payload.username);
                        root.updateReceived("user.experiment", msg.payload.experiment);
                        EventBus.sendLocalNotification("start", {});
                        root.sendCommand("control", "dump");
                        Inbox.messageModel.clear();
                        return;
                    }
                }
            } else if (root.connectionState === "Authenticated") {
                switch (msg.type) {
                case "update":
                    switch (msg.key) {
                    case "system.timestamp":
                        root.updateReceived(msg.key, msg.payload);
                        break;
                    case "secondarytasks.messaging.users":
                        root.updateReceived(msg.key, msg.payload);
                        break;
                    default:
                        root.updateReceived(msg.key, msg.payload);
                    }
                    break;
                case "notify":
                    if (msg.key === "disconnecting") {
                        root.sendLocalNotification("toast", {
                            "message": "Disconnected by the manager"
                        });
                        root.disconnectedFromManager();
                        root.sendLocalNotification("showConnectionDialog");
                        root.sendLocalNotification("resetConnectionDialog");
                        mqtt.disconnect();
                    } else {
                        root.notificationReceived(msg.key, msg.payload);
                    }
                    break;
                case "control":
                    switch (msg.key) {
                    case "login":
                        console.error("Unexpected login reply while authenticated");
                        break;
                    case "access":
                        root.updateReceived("user.access", msg.payload);
                        break;
                    case "alias":
                        root.updateReceived("user.alias", msg.payload);
                        break;
                    case "dump":
                        root.sendLocalNotification("hideConnectionDialog");
                        root.connectedAndReady();
                        break;
                    default:
                        console.error("Invalid controlmessage received " + msg);
                    }
                    break;
                default:
                    console.error("Invalid message received " + msg);
                }
            } else {
                console.error("Invalid connectionState: " + root.connectionState);
            }
        }

        Component.onCompleted: {
            if (toolbox.protocol() === "https:") {
                socket.url = "wss://localhost:8143";
            } else {
                socket.url = "ws://localhost:8143";
            }
            socket.active = true;
        }
    }

    ToolBox {
        id: toolbox
    }

    Component.onCompleted: {
        EventBus.subN("showPopup", (event, payload) => {
            EventBus.sendWebBackendCommand("show_popup", payload.url, {
                "title": payload.title
            });
        });
    }

    function connect() {
        mqtt.initialize(SettingsManager.managerUuid);
        mqtt.connectToBroker(SettingsManager.brokerUrl);
    }

    // Sends a generic command to the manager
    function sendCommand(command, value, payload) {
        if (connectionState !== "Authenticated")
            return;
        if (payload === undefined) {
            payload = {};
        }
        let req = {
            "type": command,
            "key": value,
            "payload": payload
        };
        mqtt.sendMessage(req);
    }

    // Sends a generic command to the web backend
    function sendWebBackendCommand(command, value, payload) {
        if (connectionState !== "Authenticated")
            return;
        if (payload === undefined) {
            payload = {};
        }
        let req = {
            "type": command,
            "key": value,
            "payload": payload
        };
        socket.sendTextMessage(JSON.stringify(req));
    }

    function log(tag, message) {
        if (connectionState !== "Authenticated")
            return;
        let req = {
            "type": "control",
            "key": "log",
            "payload": {
                "tag": tag,
                "message": message
            }
        };
        mqtt.sendMessage(req);
    }

    function set(name, value) {
        if (connectionState !== "Authenticated")
            return;
        let req = {
            "type": "update",
            "key": name,
            "payload": value
        };
        mqtt.sendMessage(req);
    }

    function sendLocalNotification(event, payload) {
        notificationReceived(event, payload);
    }
}
