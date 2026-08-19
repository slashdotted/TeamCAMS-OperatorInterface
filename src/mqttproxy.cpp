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

#include "mqttproxy.h"

#include <QJsonDocument>
#include <QJsonObject>

MqttProxy::MqttProxy(QObject *parent) : QObject(parent) {}

MqttProxy::~MqttProxy() = default;

void MqttProxy::initialize(const QString &serverUuid) {
    qDebug() << "[MqttProxy] Initializing proxy with server uuid " << serverUuid;
    m_manager.reset();
    m_transport.reset();

    m_transport = std::make_unique<MqttTransport>(serverUuid);
    m_manager = std::make_unique<MqttExperimentClient>(m_transport.get());

    connect(m_manager.get(),
            &MqttExperimentClient::messageReceived,
            [this](const QJsonObject &obj) { emit messageReceived(obj.toVariantMap()); });

    connect(m_transport.get(), &MqttTransport::connected, this, &MqttProxy::connectedToBroker);
    connect(m_transport.get(),
            &MqttTransport::disconnected,
            this,
            &MqttProxy::disconnectedFromBroker);
    connect(m_manager.get(),
            &MqttExperimentClient::disconnected,
            this,
            &MqttProxy::disconnectedFromManager);

    connect(m_manager.get(),
            &MqttExperimentClient::statusChanged,
            this,
            &MqttProxy::onStatusChanged);
}

void MqttProxy::connectToBroker(const QString &brokerUrl)
{
    qDebug() << "[MqttProxy] Connect to broker" << brokerUrl;
    if (!m_manager)
        return;
    QUrl url{brokerUrl};
    QString hostWithPath = url.host() + url.path();
    // TODO: handle username and password
    qDebug() << "[MqttProxy] Connecting to MqttTransport" << hostWithPath << url.port()
             << url.scheme();
    m_transport->connectToBroker(hostWithPath,
                                 static_cast<quint16>(url.port()),
                                 url.scheme() == "wss" ? MqttSecurityMode::Secure
                                                       : MqttSecurityMode::Unsecure);
}

void MqttProxy::connectToExperiment(const QString &experimentUuid,
                                    const QString &username,
                                    const QString &password) {
  m_manager->connectToExperiment(experimentUuid, username, password);
}

void MqttProxy::disconnect() {
  if (!m_manager)
    return;

  m_manager->disconnect();
}

void MqttProxy::sendMessage(const QVariantMap &payload) {
  if (!m_manager)
    return;

  auto msg = QJsonObject::fromVariantMap(payload);
  m_manager->send(msg);
}

void MqttProxy::onStatusChanged(MqttExperimentClient::Status status) {
  switch (status) {
  case MqttExperimentClient::Status::Disconnected:
    emit statusChanged("Disconnected");
    break;
  case MqttExperimentClient::Status::Connecting:
    emit statusChanged("Connecting");
    break;
  case MqttExperimentClient::Status::WaitingChallenge:
    emit statusChanged("WaitingChallenge");
    break;
  case MqttExperimentClient::Status::WaitingChallengeAck:
    emit statusChanged("WaitingChallengeAck");
    break;
  case MqttExperimentClient::Status::Connected:
    emit statusChanged("Connected");
    break;
  }
}
