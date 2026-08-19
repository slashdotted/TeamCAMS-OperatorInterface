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

#include "toolbox.h"
#include <QDebug>
#ifdef Q_OS_WASM
#include <QUrlQuery>
#include <emscripten/val.h>
#endif

ToolBox::ToolBox() : QObject{} {}

QString ToolBox::protocol()
{
#ifdef Q_OS_WASM
    emscripten::val location = emscripten::val::global("location");
    return QString::fromStdString(location["protocol"].as<std::string>());
#else
    return {};
#endif
}

Q_INVOKABLE bool ToolBox::hasParameter(const QString &key) {
#ifdef Q_OS_WASM
  emscripten::val location = emscripten::val::global("location");
  auto s{QString::fromStdString(location["search"].as<std::string>())};
  if (s.startsWith('?')) {
    s = s.removeFirst();
  }
  QUrlQuery query{s};
  return query.hasQueryItem(key);
#else
  return "";
#endif
}

Q_INVOKABLE QString ToolBox::search(const QString &key) {
#ifdef Q_OS_WASM
  emscripten::val location = emscripten::val::global("location");
  auto s{QString::fromStdString(location["search"].as<std::string>())};
  if (s.startsWith('?')) {
    s = s.removeFirst();
  }
  QUrlQuery query{s};
  return query.queryItemValue(key);
#else
  return "";
#endif
}
