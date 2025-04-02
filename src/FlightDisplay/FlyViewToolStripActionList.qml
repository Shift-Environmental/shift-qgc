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

ToolStripActionList {
    id: _root

    signal displayPreFlightChecklist

    model: [
        ToolStripAction {
            text:           qsTr("Mission")
            iconSource:     "/res/wind-rose.svg"
            onTriggered:    mainWindow.showPlanView()
        },
        ToolStripAction {
            text:           qsTr("Loudspeaker")
            iconSource:     "/res/os_speaker_off.svg"
            // onTriggered:    // TODO: Turn the loudspeaker on/off and update the button state after the two-way comms API says 200 OK
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
