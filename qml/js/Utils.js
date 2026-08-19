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

function formatTimestamp(ts) {
    if (ts < 0)
        return "";
    ts = ((ts % (3600 * 24)) + 3600 * 24) % (3600 * 24);
    var hours = Math.floor(ts / 3600);
    var minutes = Math.floor((ts - (hours * 3600)) / 60);
    var seconds = ts - hours * 3600 - minutes * 60;
    var hh = "" + hours;
    var mm = "" + minutes;
    var ss = "" + seconds;
    if (hours < 10) {
        hh = "0" + hh;
    }
    if (minutes < 10) {
        mm = "0" + mm;
    }
    if (seconds < 10) {
        ss = "0" + ss;
    }
    return hh + ":" + mm + ":" + ss;
}
