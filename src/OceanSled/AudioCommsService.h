#ifndef AUDIOCOMMSSERVICE_H
#define AUDIOCOMMSSERVICE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>

class AudioCommsService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool speakerOn READ speakerOn NOTIFY speakerOnChanged)

public:
    explicit AudioCommsService(QObject* parent = nullptr);

    Q_INVOKABLE void getStatus();        // Fetch current speaker status
    Q_INVOKABLE void muteSpeaker();      // Explicitly mute the speaker
    Q_INVOKABLE void unmuteSpeaker();    // Explicitly unmute the speaker

    bool speakerOn() const { return _speakerOn; }

signals:
    void speakerToggled(bool success, const QString& response);
    void speakerOnChanged();

private:
    void _postToApi(const QUrl& path);

    QNetworkAccessManager* _networkManager;
    bool _speakerOn;
    QUrl _apiBaseUrl;
};

#endif // AUDIOCOMMSSERVICE_H
