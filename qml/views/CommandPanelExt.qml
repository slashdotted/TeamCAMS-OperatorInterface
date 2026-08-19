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
import "../widgets"
import "../utils"

Item {
    width: 1100
    height: 540

    Row {
        anchors.centerIn: parent

        Column {
            width: 240
            height: 540

            RepairTaskPanel {}

            TransmissionTaskPanel {}

            N2LoggingTaskPanel {}
        }

        Column {
            width: 840
            height: 540

            CommandPanel {
                id: commandpanel
                width: 840
                height: 420
            }

            LOAPanel {
                id: loapanel
                width: 840
                height: 120
            }
        }
    }
}
