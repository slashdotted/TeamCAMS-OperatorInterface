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

#ifndef MQTTPROXY_H
#define MQTTPROXY_H

#include <QObject>
#include <QVariantMap>
#include <QtQml>
#include <memory>

#include "network/mqtt/mqttexperimentclient.h"
#include "network/mqtt/mqtttransport.h"

class MqttProxy : public QObject {
  Q_OBJECT
  QML_ELEMENT

public:
  explicit MqttProxy(QObject *parent = nullptr);
  ~MqttProxy() override;

  Q_INVOKABLE void initialize(const QString &serverUuid);
  Q_INVOKABLE void connectToBroker(const QString &brokerUrl);
  Q_INVOKABLE void connectToExperiment(const QString &experimentUuid,
                                       const QString &username,
                                       const QString &password);
  Q_INVOKABLE void disconnect();
  Q_INVOKABLE void sendMessage(const QVariantMap &payload);

signals:
  void connectedToBroker();
  void disconnectedFromBroker(const QString &reason);
  void disconnectedFromManager(const QString &reason);
  void connected();
  void disconnected(const QString &reason);
  void messageReceived(const QVariantMap &message);
  void statusChanged(const QString &status);

private slots:
  void onStatusChanged(MqttExperimentClient::Status status);

private:
  std::unique_ptr<MqttTransport> m_transport;
  std::unique_ptr<MqttExperimentClient> m_manager;
};

#endif // MQTTPROXY_H
