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
    id: contents
    width: 1920
    height: 1080

    Column {
        anchors.fill: parent
        spacing: 0

        Row {
            SystemOverview {
                id: sysoverview
                width: 840
                height: 540
            }

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

        Row {

            LinePlot {
                id: grtabs
                width: 960
                height: 540
            }
            LOAFrame {
                id: loainterface
                width: 960
                height: 540
            }
        }
    }
}
