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
    Q_PROPERTY(int volume READ volume NOTIFY volumeChanged)

public:
    explicit AudioCommsService(QObject* parent = nullptr);

    Q_INVOKABLE void getStatus();        // Fetch current speaker status
    Q_INVOKABLE void muteSpeaker();      // Explicitly mute the speaker
    Q_INVOKABLE void unmuteSpeaker();    // Explicitly unmute the speaker

    Q_INVOKABLE void volumeUp();            // Increase volume
    Q_INVOKABLE void volumeDown();          // Decrease volume
    Q_INVOKABLE void setVolume(int level);  // Set volume to specific level (1–10)

    bool speakerOn() const { return _speakerOn; }
    int volume() const { return _volume; }

signals:
    void speakerToggled(bool success, const QString& response);
    void speakerOnChanged();
    void volumeChanged(int level);

private:
    QNetworkAccessManager* _networkManager;
    QUrl _apiBaseUrl;

    bool _speakerOn;
    int _volume = -1; // -1 = unknown initially

    void _postToApi(const QUrl& path);
};

#endif // AUDIOCOMMSSERVICE_H
