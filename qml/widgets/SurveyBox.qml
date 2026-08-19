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
import QtQuick.Controls
import "../../"

Rectangle {
    id: root
    width: 860
    height: 540
    color: "#AAAAAA"
    border.width: 2
    border.color: "black"
    property string message: qsTr("Questions")
    property var questions: []
    property int questionsToGo: -1
    signal surveyCompleted

    Component.onCompleted: {
        questionsToGo = questions.length;
    }

    function isCompleted() {
        return questionsToGo == 0;
    }

    function getAnswers() {
        var answers = {};
        for (var i = 0; i < rep.count; i++) {
            var val = rep.itemAt(i).value;
            var qid = root.questions[i].id;
            answers[qid] = val;
        }
        return answers;
    }

    function answerCompleted() {
        if (questionsToGo > 0) {
            questionsToGo -= 1;
        }
        if (isCompleted()) {
            root.surveyCompleted();
        }
    }

    Image {
        anchors.fill: parent
        source: "qrc:///qml/assets/images/metal-texture.jpg"
        fillMode: Image.Tile
    }

    Text {
        id: qbox
        x: 8
        y: 16
        width: 480
        height: 65
        text: root.message
        font.bold: true
        font.pixelSize: 14
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
    }

    ScrollView {
        x: 8
        y: 70
        width: root.width - 16
        height: root.height - 150
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        Column {
            spacing: 10
            Repeater {
                id: rep
                model: root.questions.length

                LikertBox {
                    width: 840
                    height: 105
                }

                onItemAdded: function (index, item) {
                    item.question = root.questions[index].text;
                    item.valueChanged.connect(root.answerCompleted);
                }
            }
        }
    }
}
