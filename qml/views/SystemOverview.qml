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
import "../utils"
import "qrc:///qml/js/Utils.js" as Utils
import "../../"

Item {
    id: root
    width: 840
    height: 540
    opacity: visible ? 1.0 : 0.0
    property int o2mixerflow: 0
    property int n2mixerflow: 0
    property int mixerflow: o2mixerflow + n2mixerflow
    property bool errorDetected: false
    property string currentLoa: "loa1"
    property bool notifyOnNewMessages: true
    visible: SettingsManager.systemoverviewvisible
    property bool chatVisible: true
    property bool chatIsOpen: false

    onMixerflowChanged: {
        mixerflowdisplay.value = mixerflow;
    }

    Component.onDestruction: {
        // ...
    }

    Component.onCompleted: {
        EventBus.subN("start", (event, payload) => {
            if (!SettingsManager.alternatemessaging) {
                newMessageLamp.active = false;
            }
        });
        EventBus.subN("chat", (event, payload) => {
            if (!SettingsManager.alternatemessaging) {
                if (chatVisible && !chatIsOpen) {
                    // Only notify if the chat is hidden
                    if (notifyOnNewMessages) {
                        newMessageLamp.active = true;
                    }
                    SoundEffectProxy.tone();
                }
            }
        });
        EventBus.subN("messagingBoxVisible", (event, payload) => {
            root.chatIsOpen = true;
            newMessageLamp.active = false;
        });
        EventBus.subN("messagingBoxHidden", (event, payload) => {
            root.chatIsOpen = false;
        });
        EventBus.subU("system.timestamp", (pname, pvalue) => systime.text = Utils.formatTimestamp(pvalue));
        EventBus.subU("automation.loa.active", (pname, pvalue) => currentLoa = pvalue);
        EventBus.subU("system.error.alarm", (pname, pvalue) => {
            if (!errorDetected && pvalue === true && (currentLoa != "loa1")) {
                SoundEffectProxy.alarm();
            }
            errorDetected = pvalue;
        });
        EventBus.subU("components.n2tank.open", (pname, pvalue) => n2tanklamp.active = pvalue);
        EventBus.subU("components.o2tank.open", (pname, pvalue) => o2tanklamp.active = pvalue);
        EventBus.subU("components.o2valve.open", (pname, pvalue) => o2valvelamp.active = pvalue);
        EventBus.subU("components.n2valve.open", (pname, pvalue) => n2valvelamp.active = pvalue);
        EventBus.subU("components.scrubber.running", (pname, pvalue) => scrubberlamp.active = pvalue);
        EventBus.subU("components.vent.running", (pname, pvalue) => ventlamp.active = pvalue);
        EventBus.subU("components.heater.running", (pname, pvalue) => heaterlamp.active = pvalue);
        EventBus.subU("components.cooler.running", (pname, pvalue) => coolerlamp.active = pvalue);
        EventBus.subU("components.dehumidifier.running", (pname, pvalue) => dehumidifierlamp.active = pvalue);
        EventBus.subU("components.o2tank.volume", (pname, pvalue) => o2tankdisplay.value = pvalue);
        EventBus.subU("components.n2tank.volume", (pname, pvalue) => n2tankdisplay.value = pvalue);
        EventBus.subU("components.o2pipetankvalve.flow", (pname, pvalue) => o2pipedisplay.value = pvalue);
        EventBus.subU("components.n2pipetankvalve.flow", (pname, pvalue) => n2pipedisplay.value = pvalue);
        EventBus.subU("components.n2pipevalvemixer.flow", (pname, pvalue) => {
            n2mixerflow = pvalue;
            n2valvedisplay.value = pvalue;
        });
        EventBus.subU("components.o2pipevalvemixer.flow", (pname, pvalue) => {
            o2mixerflow = pvalue;
            o2valvedisplay.value = pvalue;
        });
        EventBus.subU("components.cabin.gradient", (pname, pvalue) => {
            var hn2 = pvalue * 160.0;
            var ho2 = pvalue * 64.0;
            var mn2 = pvalue * 80.0;
            var mo2 = pvalue * 32.0;
            var ln2 = pvalue * 40.0;
            var lo2 = pvalue * 20.0;
            o2_high_target.value = ho2;
            o2_med_target.value = mo2;
            o2_std_target.value = lo2;
            n2_high_target.value = hn2;
            n2_med_target.value = mn2;
            n2_std_target.value = ln2;
        });
        EventBus.subU("interface.oxtankdisplay.visible", (pname, pvalue) => o2tankdisplay.enabled = pvalue);
        EventBus.subU("interface.oxseconddisplay.visible", (pname, pvalue) => o2valvedisplay.enabled = pvalue);
        EventBus.subU("interface.o2pipedisplay.visible", (pname, pvalue) => o2pipedisplay.enabled = pvalue);
        EventBus.subU("interface.n2pipedisplay.visible", (pname, pvalue) => n2pipedisplay.enabled = pvalue);
        EventBus.subU("interface.nitankdisplay.visible", (pname, pvalue) => n2tankdisplay.enabled = pvalue);
        EventBus.subU("interface.niseconddisplay.visible", (pname, pvalue) => n2valvedisplay.enabled = pvalue);
        EventBus.subU("interface.mixerdisplay.visible", (pname, pvalue) => mixerflowdisplay.enabled = pvalue);
        EventBus.subU("interface.cofilterlabel.visible", (pname, pvalue) => scrubberlamp.enabled = pvalue);
        EventBus.subU("interface.coolingmachinelabel.visible", (pname, pvalue) => coolerlamp.enabled = pvalue);
        EventBus.subU("interface.heatingmachinelabel.visible", (pname, pvalue) => heaterlamp.enabled = pvalue);
        EventBus.subU("interface.dehumidlabel.visible", (pname, pvalue) => dehumidifierlamp.enabled = pvalue);
        EventBus.subU("interface.ventlabel.visible", (pname, pvalue) => ventlamp.enabled = pvalue);
        EventBus.subU("interface.masteralarm.visible", (pname, pvalue) => systemalarm.enabled = pvalue);
        EventBus.subU("interface.systemmonitor.visible", (pname, pvalue) => root.visible = pvalue);
        EventBus.subU("interface.chatbox.visible", (pname, pvalue) => chatVisible = pvalue);
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
        y: 10
        width: 820
        height: 530
        color: "#AAAAAA"
        anchors.horizontalCenter: parent.horizontalCenter
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
            anchors.leftMargin: 51
            anchors.top: parent.top
            anchors.topMargin: 91
            border.width: 1
        }

        Rectangle {
            id: n2tank
            y: 235
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
            anchors.bottom: n2tankdisplay.top
            anchors.bottomMargin: 6
            border.width: 1
        }

        LCDDisplay {
            id: o2tankdisplay
            name: "o2tankdisplay"
            width: 107
            height: 31
            anchors.left: parent.left
            anchors.leftMargin: 26
            anchors.top: o2tank.bottom
            anchors.topMargin: -107
        }

        LCDDisplay {
            id: n2tankdisplay
            name: "n2tankdisplay"
            x: 26
            y: 311
            width: 107
            height: 31
            z: 2
        }

        Image {
            id: image1
            x: 107
            y: 113
            width: 38
            height: 26
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            source: "qrc:///qml/assets/images/valve.svg"
        }

        Rectangle {
            id: rectangle1
            x: 98
            y: 121
            width: 221
            height: 9
            color: "#909090"
            border.width: 0
        }

        Rectangle {
            id: rectangle2
            x: 98
            y: 265
            width: 221
            height: 9
            color: "#909090"
            border.width: 0
        }

        Image {
            id: image2
            x: 107
            y: 257
            width: 38
            height: 26
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            source: "qrc:///qml/assets/images/valve.svg"
        }

        Image {
            id: image3
            x: 224
            y: 113
            width: 38
            height: 26
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            source: "qrc:///qml/assets/images/valve.svg"
        }

        Image {
            id: image4
            x: 224
            y: 257
            width: 38
            height: 26
            sourceSize.width: width
            sourceSize.height: height
            z: 1
            source: "qrc:///qml/assets/images/valve.svg"
        }

        Rectangle {
            id: rectangle3
            x: 310
            y: 121
            width: 9
            height: 153
            color: "#909090"
            z: 7
            border.width: 0
        }

        Image {
            id: image5
            x: 298
            y: 181
            width: 33
            height: 33
            sourceSize.width: width
            sourceSize.height: height
            z: 11
            source: "qrc:///qml/assets/images/mixer.svg"
        }

        Rectangle {
            id: rectangle4
            x: 325
            y: 193
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
            anchors.leftMargin: 482
            anchors.left: parent.left
            anchors.top: parent.top
            border.width: 1
            scale: 1
            anchors.topMargin: 128

            Lamp {
                id: systemalarm
                x: 190
                y: 8
                width: 50
                height: 50
                active: errorDetected && (currentLoa != "loa1")
                blink: true
            }

            Text {
                id: text4
                x: 8
                y: 23
                text: qsTr("Failure indicator")
                font.bold: true
                font.pixelSize: 17

                visible: systemalarm.visible
            }
        }

        Text {
            id: text2
            x: 59
            y: 257
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

        Lamp {
            id: o2tanklamp
            x: 111
            y: 137
            width: 30
            height: 30
            color: "green"
        }

        Lamp {
            id: o2valvelamp
            x: 228
            y: 137
            width: 30
            height: 30
            color: "green"
        }

        Lamp {
            id: n2tanklamp
            x: 111
            y: 234
            width: 30
            height: 30
            color: "green"
        }

        Lamp {
            id: n2valvelamp
            x: 228
            y: 234
            width: 30
            height: 30
            color: "green"
        }

        LCDDisplay {
            id: o2valvedisplay
            name: "o2valvedisplay"
            x: -4
            y: 54
            width: 107
            height: 31
            z: 2
            anchors.leftMargin: 262
            anchors.bottomMargin: 445
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }

        Image {
            id: image10
            x: 482
            y: 91
            width: 30
            height: 31
            fillMode: Image.PreserveAspectFit
            sourceSize.width: width
            sourceSize.height: height
            source: "qrc:///qml/assets/images/heater.svg"
        }

        Image {
            id: image11
            x: 614
            y: 91
            width: 30
            sourceSize.width: width
            sourceSize.height: height
            height: 31
            source: "qrc:///qml/assets/images/cooler.svg"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image12
            x: 746
            y: 91
            width: 30
            height: 31
            source: "qrc:///qml/assets/images/dehumidifier.svg"
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image13
            x: 482
            y: 280
            width: 30
            height: 31
            source: "qrc:///qml/assets/images/vent.svg"
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image14
            x: 614
            y: 280
            width: 30
            height: 31
            source: "qrc:///qml/assets/images/scrubber.svg"
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
        }

        Lamp {
            id: heaterlamp
            x: 482
            y: 60
            width: 30
            height: 30
            color: "green"
        }

        Lamp {
            id: ventlamp
            x: 482
            y: 311
            width: 30
            height: 30
            color: "green"
        }

        Lamp {
            id: scrubberlamp
            x: 614
            y: 311
            width: 30
            height: 30
            color: "green"
        }

        Lamp {
            id: coolerlamp
            x: 614
            y: 60
            width: 30
            height: 30
            color: "green"
        }

        Lamp {
            id: dehumidifierlamp
            x: 746
            y: 60
            width: 30
            height: 30
            color: "green"
        }

        LCDDisplay {
            id: n2valvedisplay
            name: "n2valvedisplay"
            x: -10
            y: 311
            width: 107
            height: 31
            z: 2
            anchors.leftMargin: 262
            anchors.bottomMargin: 188
            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }

        LCDDisplay {
            id: mixerflowdisplay
            name: "mixerflowdisplay"
            x: -1
            y: 208
            width: 107
            height: 31
            z: 4
            anchors.leftMargin: 351
            anchors.bottomMargin: 281
            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }

        Rectangle {
            id: rectangle5
            x: 314
            y: 83
            width: 2
            height: 39
            color: "#000000"
        }

        Rectangle {
            id: rectangle7
            x: 76
            y: 83
            width: 2
            height: 39
            color: "#000000"
        }

        Rectangle {
            id: rectangle8
            x: 76
            y: 288
            width: 2
            height: 39
            color: "#000000"
        }

        LCDDisplay {
            id: o2_std_target
            name: "o2stdtargetdisplay"
            x: 27
            y: 421
            width: 107
            height: 31
            anchors.leftMargin: 298
            anchors.left: parent.left
            z: 2
        }

        Text {
            id: text5
            x: 233
            y: 370
            text: qsTr("Target levels")
            font.bold: true
            font.pixelSize: 17
        }

        Text {
            id: text1
            x: 59
            y: 114
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
            text: qsTr("System overview")
            font.bold: true
            font.pixelSize: 17
        }

        LCDDisplay {
            id: n2_high_target
            name: "n2hightargetdisplay"
            x: 291
            y: 475
            width: 107
            height: 31
            anchors.leftMargin: 669
            anchors.left: parent.left
            anchors.bottomMargin: 14
            anchors.bottom: parent.bottom
            z: 2
        }

        LCDDisplay {
            id: n2_med_target
            name: "n2medtargetdisplay"
            x: 164
            y: 475
            width: 107
            height: 31
            anchors.leftMargin: 482
            anchors.left: parent.left
            anchors.bottomMargin: 14
            anchors.bottom: parent.bottom
            z: 2
        }

        LCDDisplay {
            id: n2_std_target
            name: "n2stdtargetdisplay"
            x: 27
            y: 475
            width: 107
            height: 31
            anchors.leftMargin: 298
            anchors.left: parent.left
            anchors.bottomMargin: 14
            anchors.bottom: parent.bottom
            z: 2
        }

        LCDDisplay {
            id: o2_high_target
            name: "o2hightargetdisplay"
            x: 669
            y: 421
            width: 107
            height: 31
            z: 2
        }

        LCDDisplay {
            id: o2_med_target
            name: "o2medtargetdisplay"
            x: 482
            y: 421
            width: 107
            height: 31
            z: 2
        }

        Text {
            id: text6
            x: 233
            y: 427
            text: qsTr("O<sub>2</sub>")
            font.bold: true
            textFormat: Text.RichText
            font.pixelSize: 17
        }

        Text {
            id: text8
            x: 233
            y: 481
            text: qsTr("N<sub>2</sub>")
            textFormat: Text.RichText
            font.pixelSize: 17
            font.bold: true
        }

        Text {
            id: text9
            x: 298
            y: 398
            text: qsTr("Standard")
            textFormat: Text.RichText
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: text10
            x: 482
            y: 398
            text: qsTr("Medium")
            textFormat: Text.RichText
            font.pixelSize: 14
            font.bold: true
        }

        Text {
            id: text11
            x: 669
            y: 398
            text: qsTr("High")
            textFormat: Text.RichText
            font.pixelSize: 14
            font.bold: true
        }

        Image {
            id: image6
            x: 549
            y: 92
            width: 30
            height: 30
            fillMode: Image.PreserveAspectFit
            source: "qrc:///qml/assets/images/temperature.svg"
        }

        Rectangle {
            id: rectangle9
            x: 518
            y: 106
            width: 25
            height: 2
            color: "#000000"
        }

        Text {
            id: systime
            x: 630
            y: 209
            width: 130
            height: 40
            text: qsTr("00:00:00")
            z: 2
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font.bold: true
            font.pixelSize: 32
        }

        Text {
            id: systemTimeTitleLabel
            x: 492
            y: 219
            text: qsTr("System time")
            textFormat: Text.RichText

            font.bold: true
            font.pixelSize: 17
            z: 1
        }

        Rectangle {
            id: rectangle10
            x: 585
            y: 106
            width: 25
            height: 2
            color: "#000000"
        }

        Rectangle {
            id: rectangle6
            x: 314
            y: 274
            width: 2
            height: 39
            color: "#000000"
        }

        Rectangle {
            id: rectangle11
            x: 403
            y: 200
            width: 2
            height: 39
            color: "#000000"
        }

        Lamp {
            id: newMessageLamp
            x: 65
            y: 413
            width: 23
            height: 25
            blink: true
            active: false
            visible: !SettingsManager.alternatemessaging && chatVisible
            color: "blue"
        }

        SimpleImageButton {
            id: chatboxButton
            x: 42
            y: 444
            width: 68
            height: 37
            source: "qrc:///qml/assets/images/chatbox.svg"
            visible: !SettingsManager.alternatemessaging && chatVisible
            onClicked: {
                EventBus.sendLocalNotification("showMessagingDialog");
            }
        }
    }

    LCDDisplay {
        id: o2pipedisplay
        name: "o2pipedisplay"
        x: -4
        y: 64
        width: 107
        height: 31
        visible: false
        anchors.bottom: parent.bottom
        z: 2
        anchors.bottomMargin: 445
        anchors.leftMargin: 153
        anchors.left: parent.left
    }

    LCDDisplay {
        id: n2pipedisplay
        name: "n2pipedisplay"
        x: -13
        y: 321
        width: 107
        height: 31
        visible: false
        anchors.bottom: parent.bottom
        z: 2
        anchors.bottomMargin: 188
        anchors.leftMargin: 153
        anchors.left: parent.left
    }

    Rectangle {
        id: rectangle12
        x: 206
        y: 94
        width: 2
        height: 39
        color: "#000000"
        visible: false
    }

    Rectangle {
        id: rectangle13
        x: 206
        y: 283
        width: 2
        height: 39
        color: "#000000"
        visible: false
    }
}
