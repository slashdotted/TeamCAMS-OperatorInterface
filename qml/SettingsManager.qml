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
    property string username: ""
    property string password: ""
    property string experiment: ""
    property string managerUuid: ""
    property string brokerUrl: ""
    property bool autoconnect: false
    property bool fullscreen: false
    property bool systemoverviewvisible: true
    property bool graphpanelvisible: true
    property bool repairtaskvisible: true
    property bool transmissioncontrolvisible: true
    property bool n2loggingtaskvisible: true
    property bool devicecontrolvisible: true
    property bool assistancepanelsvisible: true
    property bool surveyvisible: true
    property bool automationnotificationsvisible: true
    property bool tempcontrolaligncenter: true
    property bool showStrengthTitle: true
    property bool showControlDivider: false
    property bool transmissionchecksound: true
    property bool buttonsound: true
    property bool togglesound: true
    property bool alarmsound: true
    property bool loggingsound: true
    property bool messagesound: true
    property bool keepcontrolsvisible: false
    property bool alternatemessaging: false
    property bool messaginginfront: false

    Component.onCompleted: {
        EventBus.subU("interface.fullscreen.enabled", (pname, pvalue) => {
            SettingsManager.fullscreen = pvalue;
        });
        EventBus.subU("interface.alternatemessaging.visible", (pname, pvalue) => {
            SettingsManager.alternatemessaging = pvalue;
        });
        EventBus.subU("interface.controldivider.visible", (pname, pvalue) => {
            SettingsManager.showControlDivider = pvalue;
        });
        EventBus.subU("interface.strengthtitle.visible", (pname, pvalue) => {
            SettingsManager.showStrengthTitle = pvalue;
        });
        EventBus.subU("interface.systemoverview.visible", (pname, pvalue) => {
            SettingsManager.systemoverviewvisible = pvalue;
        });
        EventBus.subU("interface.repairtask.visible", (pname, pvalue) => {
            SettingsManager.repairtaskvisible = pvalue;
        });
        EventBus.subU("interface.transmissioncontrol.visible", (pname, pvalue) => {
            SettingsManager.transmissioncontrolvisible = pvalue;
        });
        EventBus.subU("interface.n2loggingtask.visible", (pname, pvalue) => {
            SettingsManager.n2loggingtaskvisible = pvalue;
        });
        EventBus.subU("interface.devicecontrol.visible", (pname, pvalue) => {
            SettingsManager.devicecontrolvisible = pvalue;
        });
        EventBus.subU("interface.assistancepanel.visible", (pname, pvalue) => {
            SettingsManager.assistancepanelsvisible = pvalue;
        });
        EventBus.subU("interface.survey.visible", (pname, pvalue) => {
            SettingsManager.surveyvisible = pvalue;
        });
        EventBus.subU("interface.automationnotification.visible", (pname, pvalue) => {
            SettingsManager.automationnotificationsvisible = pvalue;
        });
        EventBus.subU("interface.tempcontrolaligncenter.visible", (pname, pvalue) => {
            SettingsManager.tempcontrolaligncenter = pvalue;
        });
        EventBus.subU("interface.transmissionchecksound.enabled", (pname, pvalue) => {
            SettingsManager.transmissionchecksound = pvalue;
        });
        EventBus.subU("interface.buttonsound.enabled", (pname, pvalue) => {
            SettingsManager.buttonsound = pvalue;
        });
        EventBus.subU("interface.togglesound.enabled", (pname, pvalue) => {
            SettingsManager.togglesound = pvalue;
        });
        EventBus.subU("interface.alarmsound.enabled", (pname, pvalue) => {
            SettingsManager.alarmsound = pvalue;
        });
        EventBus.subU("interface.loggingsound.enabled", (pname, pvalue) => {
            SettingsManager.loggingsound = pvalue;
        });
        EventBus.subU("interface.messagesound.enabled", (pname, pvalue) => {
            SettingsManager.messagesound = pvalue;
        });
        EventBus.subU("interface.keepcontrolsvisible.visible", (pname, pvalue) => {
            SettingsManager.keepcontrolsvisible = pvalue;
        });
        EventBus.subU("interface.messaginginfront.enabled", (pname, pvalue) => {
            SettingsManager.messaginginfront = pvalue;
        });
    }
}
