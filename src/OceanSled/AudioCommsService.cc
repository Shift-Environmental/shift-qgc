#include "QGCApplication.h"
#include "SettingsManager.h"
#include "AppSettings.h"
#include "AudioCommsService.h"

#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>

AudioCommsService::AudioCommsService(QObject* parent)
    : QObject(parent),
    _networkManager(new QNetworkAccessManager(this)),
    _speakerOn(false)
{
    auto* appSettings = qgcApp()->toolbox()->settingsManager()->appSettings();
    Fact* apiUrlFact = appSettings->audioCommsApiUrl();
    QString rawUrl = apiUrlFact->rawValue().toString();

    if (!rawUrl.isEmpty()) {
        _apiBaseUrl = QUrl(rawUrl);
        if (!_apiBaseUrl.isValid()) {
            qWarning() << "AudioCommsService: Invalid audioCommsApiUrl:" << rawUrl;
        }
    }

    getStatus(); // Initialize speaker state
}

void AudioCommsService::getStatus()
{
    QUrl statusUrl = _apiBaseUrl.resolved(QUrl("/status"));
    QNetworkRequest request(statusUrl);

    QNetworkReply* reply = _networkManager->get(request);
    connect(reply, &QNetworkReply::finished, this, [=]() {
        reply->deleteLater();
        if (reply->error() != QNetworkReply::NoError) {
            qWarning() << "AudioCommsService: Failed to get status:" << reply->errorString();
            return;
        }

        const QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        if (!doc.isObject()) {
            qWarning() << "AudioCommsService: Invalid JSON response";
            return;
        }

        const QJsonObject obj = doc.object();
        bool newState = obj["status"].toString() == "unmuted";

        if (newState != _speakerOn) {
            _speakerOn = newState;
            emit speakerOnChanged();
        }
    });
}

void AudioCommsService::muteSpeaker()
{
    _postToApi(QUrl("/mute"));
}

void AudioCommsService::unmuteSpeaker()
{
    _postToApi(QUrl("/unmute"));
}

void AudioCommsService::_postToApi(const QUrl& path)
{
    QUrl url = _apiBaseUrl.resolved(path);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply* reply = _networkManager->post(request, QByteArray());
    connect(reply, &QNetworkReply::finished, this, [=]() {
        bool success = reply->error() == QNetworkReply::NoError;
        QString response = QString::fromUtf8(reply->readAll());

        if (success) {
            if (path.path().contains("unmute"))
                _speakerOn = true;
            else if (path.path().contains("mute"))
                _speakerOn = false;
            emit speakerOnChanged();
        }

        emit speakerToggled(success, response);
        reply->deleteLater();
    });
}
