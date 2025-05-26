/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQml.Models 2.12

import QGroundControl           1.0
import QGroundControl.Controls  1.0
import QGroundControl.SettingsManager 1.0

ToolStripActionList {
    id: _root

    signal displayPreFlightChecklist    
    property var appSettings: QGroundControl.settingsManager.appSettings

    model: [
        ToolStripAction {
            text:           qsTr("Mission")
            iconSource:     "/res/wind-rose.svg"
            onTriggered:    mainWindow.showPlanView()
        },

        ToolStripAction {
            visible: appSettings.audioCommsEnabled.value
            text:       qsTr("Speaker")
            iconSource: AudioCommsService.speakerOn ? "/res/os_speaker_on.svg" : "/res/os_speaker_off.svg"
            iconColor: AudioCommsService.speakerOn ? "lightgreen" : "white"
            onTriggered: if (AudioCommsService.speakerOn) {
                AudioCommsService.muteSpeaker()
            } else {
                AudioCommsService.unmuteSpeaker()
            }
        },

        ToolStripAction {
            visible: appSettings.audioCommsEnabled.value
            iconSource: "/res/volume-plus.svg"
            onTriggered: AudioCommsService.volumeUp()
            enabled: AudioCommsService.volume < 10
        },

        ToolStripAction {
            visible: appSettings.audioCommsEnabled.value
            iconSource: "/res/volume-minus.svg"
            onTriggered: AudioCommsService.volumeDown()
            enabled: AudioCommsService.volume > 0
        },

        PreFlightCheckListShowAction { onTriggered: displayPreFlightChecklist() },
        // GuidedActionTakeoff { },
        // GuidedActionLand { },
        // GuidedActionRTL { },
        GuidedActionPause { },
        GuidedActionActionList { },
        GuidedActionGripper { }
    ]
}
