
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
import "../dialogs"
import "../.."
import QtQuick

Item {
    ConnectionDialog {
        id: connectionDialog
        visible: false
    }

    MessagingDialog {
        id: messagingDialog
        visible: false
    }

    RepairDialog {
        id: repairDialog
        visible: false
    }

    LOAChangeNotificationDialog {
        id: loaChangeNotificationDialog
        visible: false
    }

    SurveyDialog {
        id: surveyDialog
        visible: false
    }

    Component.onCompleted: {
        EventBus.subN("showConnectionDialog",
                      (event, payload) => connectionDialog.open())
        EventBus.subN("hideConnectionDialog",
                      (event, payload) => connectionDialog.close())
        EventBus.subN("showMessagingDialog",
                      (event, payload) => messagingDialog.open())
        EventBus.subN(
                    "toggleMessagingDialog",
                    (event, payload) => messagingDialog.visible = !messagingDialog.visible)
        EventBus.subN("hideMessagingDialog",
                      (event, payload) => messagingDialog.close())
        EventBus.subN("showRepairDialog",
                      (event, payload) => repairDialog.open())
        EventBus.subN("hideRepairDialog",
                      (event, payload) => repairDialog.close())
        EventBus.subN("showSurveyDialog", (event, payload) => {
                          surveyDialog.survey.message = payload.message
                          surveyDialog.survey.questions = payload.questions
                          surveyDialog.open()
                      })
        EventBus.subN("hideSurveyDialog",
                      (event, payload) => surveyDialog.close())
        EventBus.subN("showPopup",
                      (event, payload) => EventBus.sendWebBackendCommand(
                          "show_popup", payload.url))
        EventBus.subN("showLOAChangeNotificationDialog", (event, payload) => {
                          loaChangeNotificationDialog.message = payload.message
                          loaChangeNotificationDialog.activeLOA = payload.activeLOA
                          loaChangeNotificationDialog.enabledLOAs = payload.enabledLOAs
                          loaChangeNotificationDialog.showSelector = payload.showSelector
                          loaChangeNotificationDialog.showCloseButton = payload.showCloseButton
                          loaChangeNotificationDialog.buttonTimeout = payload.buttonTimeout
                          loaChangeNotificationDialog.updateLoas()
                          loaChangeNotificationDialog.open()
                      })
        EventBus.subN("start", (event, payload) => {
                          messagingDialog.close()
                          repairDialog.close()
                          surveyDialog.close()
                          loaChangeNotificationDialog.close()
                      })
        EventBus.subN("hideLOAChangeNotificationDialog",
                      (event, payload) => loaChangeNotificationDialog.close())
        EventBus.sendLocalNotification("showConnectionDialog", {})
    }
}
