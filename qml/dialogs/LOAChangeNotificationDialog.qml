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
import QtQuick.Dialogs
import "../widgets"
import "../../"

Dialog {
    id: root
    anchors.centerIn: parent
    width: 880
    height: 320
    visible: true
    modal: true
    padding: 10
    closePolicy: Popup.NoAutoClose
    title: qsTr("Automation Assistant")
    background: Image {
        anchors.fill: parent
        source: "qrc:///qml/assets/images/metal-texture.jpg"
        fillMode: Image.Tile
    }
    property string message: qsTr("Please increase LOA")
    property alias activeLOA: loaselect.activeLOA
    property string enabledLOAs: ""
    property bool showSelector: false
    property bool showCloseButton: false
    property int buttonTimeout: -1
    footer: DialogButtonBox {
        id: buttons
        standardButtons: Dialog.Close
        visible: showCloseButton
    }

    function updateLoas() {
        var enabled_LOA = enabledLOAs.split(",");
        loaselect.setLoaStatus("loa1", (enabled_LOA.indexOf("loa1") >= 0));
        loaselect.setLoaStatus("loa2", (enabled_LOA.indexOf("loa2") >= 0));
        loaselect.setLoaStatus("loa3", (enabled_LOA.indexOf("loa3") >= 0));
        loaselect.setLoaStatus("loa4", (enabled_LOA.indexOf("loa4") >= 0));
        loaselect.setLoaStatus("loa5", (enabled_LOA.indexOf("loa5") >= 0));
        loaselect.setLoaStatus("loa6", (enabled_LOA.indexOf("loa6") >= 0));
    }

    contentItem: Item {
        anchors.fill: parent
        signal closeRequest

        Image {
            anchors.fill: parent
            source: "qrc:///qml/assets/images/metal-texture.jpg"
            fillMode: Image.Tile
        }

        Text {
            id: text1
            text: root.message
            anchors.leftMargin: 18
            anchors.bottomMargin: 167
            anchors.rightMargin: 18
            anchors.topMargin: 48
            anchors.fill: parent
            font.pixelSize: 16
            font.bold: true
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
        }

        LOASelector {
            id: loaselect
            visible: showSelector
            x: 18
            y: 104
            width: 824
            height: 100

            onLoaSelected: {
                if (showCloseButton) {
                    buttons.standardButton(Dialog.Close).enabled = true;
                }
                EventBus.sendLocalNotification("hideLOAChangeNotificationDialog");
            }
        }
    }
}
