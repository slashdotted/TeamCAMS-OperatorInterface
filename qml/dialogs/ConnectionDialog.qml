// TeamCAMS - reborn Cabin Air Management System
// Copyright (C) 2015-2026  Amos Brocco,
//                          Cognitive Ergonomics and Work Psychology Team,
//                          Psychology Department of Fribourg University,
//                          Switzerland / Department of Innovative Technologies
//                          University of Applied Sciences and Arts of Southern
//                          Switzerland, Contact: amos.brocco@supsi.ch
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
import QtQuick
import QtQuick.Controls
import "../widgets"
import "../../"
import TeamCAMSOperatorInterface


/*
******************************************************************************
ConnectionDialog.qml

This dialog is used to let the user log in into an experiment
******************************************************************************
*/
Dialog {
    id: root
    anchors.centerIn: parent
    width: 320
    height: 400
    visible: true
    modal: true
    closePolicy: "NoAutoClose"
    title: qsTr("Enter connection parameters")
    background: Image {
        anchors.fill: parent
        source: "qrc:///qml/assets/images/metal-texture.jpg"
        fillMode: Image.Tile
    }

    contentItem: Column {
        spacing: 5
        Text {
            text: qsTr("Manager UUID")
            font.bold: true
            font.pixelSize: 16
        }

        TextField {
            id: managerUuid
            focus: true
            width: root.width - 22
            text: SettingsManager.managerUuid
            KeyNavigation.tab: experiment
        }

        Text {
            text: qsTr("Experiment")
            font.bold: true
            font.pixelSize: 16
        }

        TextField {
            id: experiment
            width: root.width - 22
            text: SettingsManager.experiment
            KeyNavigation.tab: username
        }

        Text {
            text: qsTr("Username")
            font.bold: true
            font.pixelSize: 16
        }

        TextField {
            id: username
            width: root.width - 22
            text: SettingsManager.username
            KeyNavigation.tab: password
        }

        Text {
            text: qsTr("Password")
            font.bold: true
            font.pixelSize: 16
        }

        TextField {
            id: password
            width: root.width - 22
            text: SettingsManager.password // admin"
            echoMode: "Password"
            KeyNavigation.tab: connect
        }

        Text {
            id: statusMessage
            width: root.width - 22
            height: 19
            color: "#ff0000"
            text: qsTr("")
            font.pixelSize: 12
        }

        SimpleButton {
            id: connect
            width: root.width - 22
            height: 30
            text: qsTr("Connect")
            onClicked: {
                SoundEffectProxy.press()
                root.doConnect()
            }

            KeyNavigation.tab: managerUuid
        }
    }

    ToolBox {
        id: toolbox
    }

    Component.onCompleted: {
        // Register reset event
        EventBus.subN("resetConnectionDialog", (event, payload) => {
                          root.enabled = true
                          connect.enabled = true
                          connect.text = qsTr("Connect")
                      })

        // Fetch connection parameters from url
        if (toolbox.hasParameter("m")) {
            managerUuid.text = toolbox.search("m")
        }
        if (toolbox.hasParameter("u")) {
            username.text = toolbox.search("u")
        }
        if (toolbox.hasParameter("p")) {
            password.text = toolbox.search("p")
        }
        if (toolbox.hasParameter("e")) {
            experiment.text = toolbox.search("e")
        }
        if (toolbox.hasParameter("b")) {
            SettingsManager.brokerUrl = toolbox.search("b")
        }
    }

    onOpened: {
        root.enabled = true
        connect.enabled = true
        connect.text = qsTr("Connect")
        connect.forceActiveFocus()
    }

    function doConnect() {
        root.enabled = false
        connect.text = qsTr("Please wait...")
        statusMessage.text = ""
        SettingsManager.managerUuid = managerUuid.text
        SettingsManager.username = username.text
        SettingsManager.password = password.text
        SettingsManager.experiment = experiment.text
        Communication.connect()
        SettingsManager.autoconnect = false
    }
}
