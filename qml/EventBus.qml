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

Item {
    id: root
    property var notificationConnections: ({})
    property var updateConnections: ({})
    property bool dispatchingEnabled: true
    property var valuesMap: ({})

    // Subscribe to notification
    function subN(event, fun) {
        if (event in notificationConnections) {
            notificationConnections[event].push(fun);
        } else {
            notificationConnections[event] = [fun];
        }
    }

    // Subscribe to update
    function subU(propertyName, fun) {
        if (propertyName in updateConnections) {
            updateConnections[propertyName].push(fun);
        } else {
            updateConnections[propertyName] = [fun];
        }
    }

    function sendLocalNotification(event, payload) {
        Communication.sendLocalNotification(event, payload);
    }

    function sendWebBackendCommand(command, value, payload) {
        Communication.sendWebBackendCommand(command, value, payload);
    }

    function sendCommand(command, value, payload) {
        Communication.sendCommand(command, value, payload);
    }

    function existsStored(propertyName) {
        return propertyName in root.valuesMap;
    }

    function getStored(propertyName) {
        return root.valuesMap[propertyName];
    }

    function getStoredOr(propertyName, defaultValue) {
        if (propertyName in root.valuesMap) {
            return root.valuesMap[propertyName];
        } else {
            return defaultValue;
        }
    }

    function clearStored() {
        root.valuesMap = {};
    }

    function log(tag, message) {
        Communication.log(tag, message);
    }

    function set(name, value) {
        Communication.set(name, value);
    }

    Connections {
        id: connection
        target: Communication

        function onNotificationReceived(event, payload) {
            if (!root.dispatchingEnabled)
                return;
            if (event in root.notificationConnections) {
                let newNotificationConnections = [];
                for (let fun of root.notificationConnections[event].values()) {
                    try {
                        fun(event, payload);
                        newNotificationConnections.push(fun);
                    } catch (e) {
                        // Do nothing
                        console.log(e);
                    }
                }
                if (newNotificationConnections.length > 0) {
                    root.notificationConnections[event] = newNotificationConnections;
                } else {
                    delete root.notificationConnections[event];
                }
            }
        }

        function onUpdateReceived(propertyName, propertyValue) {
            root.valuesMap[propertyName] = propertyValue;
            if (!root.dispatchingEnabled)
                return;
            if (propertyName in root.updateConnections) {
                let newUpdateConnections = [];
                for (let fun of root.updateConnections[propertyName].values()) {
                    try {
                        fun(propertyName, propertyValue);
                        newUpdateConnections.push(fun);
                    } catch (e) {
                        // Do nothing
                        console.log(e);
                    }
                }
                if (newUpdateConnections.length > 0) {
                    root.updateConnections[propertyName] = newUpdateConnections;
                } else {
                    delete root.updateConnections[propertyName];
                }
            }
        }
    }
}
