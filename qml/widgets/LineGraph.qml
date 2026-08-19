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
import "../utils"
import "qrc:///qml/js/Utils.js" as Utils

Canvas {
    id: canvas
    property double criticalUpperThreshold: 20.6
    property double criticalLowerThreshold: 19
    property double noncriticalUpperThreshold: 20.0
    property double noncriticalLowerThreshold: 19.6
    property string unit: "%"
    property string measure: "Oxygen"
    property string title: ""
    clip: true
    property double normalValue: (criticalUpperThreshold + criticalLowerThreshold) / 2
    property real zeroY: height / 2
    property real scaleY: (zeroY - height / 5) / (criticalUpperThreshold - normalValue)

    property int timestamp: 0
    property double value: 0.0

    function push(ts, v) {
        if (ts > 0) {
            timestamp = ts;
            value = v;
        }
    }

    function commit() {
        mdata.push(timestamp, value);
    }

    function clear() {
        mdata.clear();
    }

    function getPlotY(realY) {
        return zeroY - ((realY - normalValue) * scaleY);
    }

    function drawAxes(ctx) {
        ctx.font = "14px sans-serif"; //" sans smallcaps"
        ctx.lineWidth = 1;
        ctx.strokeStyle = '#909090';
        ctx.beginPath();
        ctx.moveTo(0, zeroY);
        ctx.lineTo(width, zeroY);
        ctx.stroke();

        ctx.beginPath();
        ctx.moveTo(0, getPlotY(criticalUpperThreshold));
        ctx.strokeStyle = '#ff0000';
        ctx.fillStyle = '#990000';
        ctx.lineTo(width, getPlotY(criticalUpperThreshold));
        ctx.textAlign = "left";
        ctx.fillText(criticalUpperThreshold + unit, 10, getPlotY(criticalUpperThreshold) - 2);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(0, getPlotY(criticalLowerThreshold));
        ctx.lineTo(width, getPlotY(criticalLowerThreshold));
        ctx.textAlign = "left";
        ctx.fillText(criticalLowerThreshold + unit, 10, getPlotY(criticalLowerThreshold) - 2);
        ctx.stroke();

        ctx.beginPath();
        ctx.moveTo(0, getPlotY(noncriticalUpperThreshold));
        ctx.strokeStyle = '#009900';
        ctx.fillStyle = '#009900';
        ctx.lineTo(width, getPlotY(noncriticalUpperThreshold));
        ctx.textAlign = "left";
        ctx.fillText(noncriticalUpperThreshold + unit, 10, getPlotY(noncriticalUpperThreshold) - 2);
        ctx.stroke();
        ctx.beginPath();
        ctx.moveTo(0, getPlotY(noncriticalLowerThreshold));
        ctx.lineTo(width, getPlotY(noncriticalLowerThreshold));
        ctx.textAlign = "left";
        ctx.fillText(noncriticalLowerThreshold + unit, 10, getPlotY(noncriticalLowerThreshold) - 2);
        ctx.stroke();
    }

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

    function drawMarker(ctx, xpos, val) {
        ctx.font = "14px sans-serif"; //sans" // " sans smallcaps"
        var ts = formatTimestamp(val);
        ctx.beginPath();
        ctx.moveTo(xpos, 25);
        ctx.lineTo(xpos, height - 60);
        ctx.textAlign = "center";
        ctx.fillText(ts, xpos, 18);
        ctx.stroke();
    }

    function plotData(ctx) {
        ctx.strokeStyle = '#000000';
        ctx.fillStyle = '#000000';
        var prevXPosition = width;
        var step = width / 240;
        var prevYPosition = 0;
        for (var i = 0; i < 240; i++) {
            var ts = mdata.timestamp(i);
            if (ts <= 0)
                break;
            var val = mdata.value(i);
            var currentXPosition = prevXPosition - step;
            var currentYPosition = getPlotY(val);
            if (i > 0) {
                ctx.beginPath();
                ctx.moveTo(prevXPosition, prevYPosition);
                ctx.lineTo(currentXPosition, currentYPosition);
                ctx.stroke();
            }
            if (ts % 30 == 0) {
                drawMarker(ctx, currentXPosition, ts);
            }
            prevYPosition = currentYPosition;
            prevXPosition = currentXPosition;
            if (prevXPosition < -100)
                break;
        }
        ctx.clearRect(0, 0, 80, height);
    }

    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);
        plotData(ctx);
        drawAxes(ctx);
        ctx.fillStyle = '#000000';
        ctx.strokeStyle = '#000000';
        ctx.font = "bold 20px sans-serif";
        ctx.textAlign = "center";
        var label = title;
        if (mdata.timestamp(0) >= 0) {
            label = title + " " + String(mdata.value(0).toFixed(2)) + unit;
        }
        graphTitle.text = label;
    }

    Text {
        id: graphTitle
        x: 0
        width: canvas.width
        y: canvas.height - 30
        horizontalAlignment: Text.AlignHCenter
        text: ""
        font.bold: true
        font.pixelSize: 17
        textFormat: Text.RichText
    }

    PlotBuffer {
        id: mdata
        onDataPushed: {
            canvas.requestPaint();
        }
    }

    function show() {
        tvis.show();
    }

    TimedParentVisibility {
        id: tvis
    }
}
