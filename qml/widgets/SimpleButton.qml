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

Button {
    id: root
    property alias label: root.text
    property int timeout: -1
    property alias toggled: root.highlighted
    height: 45
    width: 100

    palette {
        highlight: "red"
    }

    Timer {
        id: timeouttimer
        property int countdown: 10
        interval: 1000
        running: timeout != -1
        triggeredOnStart: false
        repeat: true
        onTriggered: function () {
            if (countdown == 0) {
                timeouttimer.stop();
                root.clicked();
            }
            countdown -= 1;
        }
    }

    Component.onCompleted: {
        if (timeout != -1) {
            timeouttimer.countdown = timeout;
            timeouttimer.start();
        }
    }
}
