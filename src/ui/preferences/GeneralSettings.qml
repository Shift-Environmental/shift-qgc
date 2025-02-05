/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0

Rectangle {
    id:                 _root
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    property Fact _savePath:                            QGroundControl.settingsManager.appSettings.savePath
    property Fact _appFontPointSize:                    QGroundControl.settingsManager.appSettings.appFontPointSize
    property Fact _userBrandImageIndoor:                QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor
    property Fact _userBrandImageOutdoor:               QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor
    property Fact _virtualJoystick:                     QGroundControl.settingsManager.appSettings.virtualJoystick
    property Fact _virtualJoystickAutoCenterThrottle:   QGroundControl.settingsManager.appSettings.virtualJoystickAutoCenterThrottle

    property real   _labelWidth:                ScreenTools.defaultFontPixelWidth * 20
    property real   _comboFieldWidth:           ScreenTools.defaultFontPixelWidth * 30
    property real   _valueFieldWidth:           ScreenTools.defaultFontPixelWidth * 10
    property string _mapProvider:               QGroundControl.settingsManager.flightMapSettings.mapProvider.value
    property string _mapType:                   QGroundControl.settingsManager.flightMapSettings.mapType.value
    property Fact   _followTarget:              QGroundControl.settingsManager.appSettings.followTarget
    property real   _panelWidth:                _root.width * _internalWidthRatio
    property real   _margins:                   ScreenTools.defaultFontPixelWidth
    property var    _planViewSettings:          QGroundControl.settingsManager.planViewSettings
    property var    _flyViewSettings:           QGroundControl.settingsManager.flyViewSettings
    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings
    property string _videoSource:               _videoSettings.videoSource.rawValue
    property bool   _isGst:                     QGroundControl.videoManager.isGStreamer
    property bool   _isUDP264:                  _isGst && _videoSource === _videoSettings.udp264VideoSource
    property bool   _isUDP265:                  _isGst && _videoSource === _videoSettings.udp265VideoSource
    property bool   _isRTSP:                    _isGst && _videoSource === _videoSettings.rtspVideoSource
    property bool   _isTCP:                     _isGst && _videoSource === _videoSettings.tcpVideoSource
    property bool   _isMPEGTS:                  _isGst && _videoSource === _videoSettings.mpegtsVideoSource
    property bool   _videoAutoStreamConfig:     QGroundControl.videoManager.autoStreamConfigured
    property bool   _showSaveVideoSettings:     _isGst || _videoAutoStreamConfig
    property bool   _disableAllDataPersistence: QGroundControl.settingsManager.appSettings.disableAllPersistence.rawValue

    property string gpsDisabled: "Disabled"
    property string gpsUdpPort:  "UDP Port"

    readonly property real _internalWidthRatio: 0.8

        QGCFlickable {
            clip:               true
            anchors.fill:       parent
            contentHeight:      outerItem.height
            contentWidth:       outerItem.width

            Item {
                id:     outerItem
                width:  Math.max(_root.width, settingsColumn.width)
                height: settingsColumn.height

                ColumnLayout {
                    id:                         settingsColumn
                    anchors.horizontalCenter:   parent.horizontalCenter

                    QGCLabel {
                        id:         flyViewSectionLabel
                        text:       qsTr("Navigation View")
                        visible:    QGroundControl.settingsManager.flyViewSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: flyViewCol.height + (_margins * 2)
                        Layout.preferredWidth:  flyViewCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                flyViewSectionLabel.visible
                        Layout.fillWidth:       true

                        ColumnLayout {
                            id:                         flyViewCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            spacing:                    _margins

                            // FactCheckBox {
                            //     id:             useCheckList
                            //     text:           qsTr("Use Preflight Checklist")
                            //     fact:           _useChecklist
                            //     visible:        _useChecklist.visible && QGroundControl.corePlugin.options.preFlightChecklistUrl.toString().length

                            //     property Fact _useChecklist: QGroundControl.settingsManager.appSettings.useChecklist
                            // }

                            // FactCheckBox {
                            //     text:           qsTr("Enforce Preflight Checklist")
                            //     fact:           _enforceChecklist
                            //     enabled:        QGroundControl.settingsManager.appSettings.useChecklist.value
                            //     visible:        useCheckList.visible && _enforceChecklist.visible && QGroundControl.corePlugin.options.preFlightChecklistUrl.toString().length

                            //     property Fact _enforceChecklist: QGroundControl.settingsManager.appSettings.enforceChecklist
                            // }

                            FactCheckBox {
                                text:       qsTr("Keep Map Centered On Vehicle")
                                fact:       _keepMapCenteredOnVehicle
                                visible:    _keepMapCenteredOnVehicle.visible

                                property Fact _keepMapCenteredOnVehicle: QGroundControl.settingsManager.flyViewSettings.keepMapCenteredOnVehicle
                            }

                            FactCheckBox {
                                text:       qsTr("Update Home Position")
                                fact:       _updateHomePosition
                                visible:    _updateHomePosition.visible
                                property Fact _updateHomePosition: QGroundControl.settingsManager.flyViewSettings.updateHomePosition
                            }

                            GridLayout {
                                columns: 2

                                QGCLabel {
                                    text:       qsTr("Go To Location Max Distance")
                                    visible:    maxGotoDistanceField.visible
                                }
                                FactTextField {
                                    id:                     maxGotoDistanceField
                                    Layout.preferredWidth:  _valueFieldWidth + 60
                                    visible:                fact.visible
                                    fact:                  _flyViewSettings.maxGoToLocationDistance
                                }
                            }

                            GridLayout {
                                id:         videoGrid
                                columns:    2
                                visible:    _videoSettings.visible

                                QGCLabel {
                                    text:               qsTr("Video Settings")
                                    Layout.columnSpan:  2
                                    Layout.alignment:   Qt.AlignHCenter
                                }

                                QGCLabel {
                                    id:         videoSourceLabel
                                    text:       qsTr("Source")
                                    visible:    !_videoAutoStreamConfig && _videoSettings.videoSource.visible
                                }
                                FactComboBox {
                                    id:                     videoSource
                                    Layout.preferredWidth:  _comboFieldWidth
                                    indexModel:             false
                                    fact:                   _videoSettings.videoSource
                                    visible:                videoSourceLabel.visible
                                }

                                QGCLabel {
                                    id:         udpPortLabel
                                    text:       qsTr("UDP Port")
                                    visible:    !_videoAutoStreamConfig && (_isUDP264 || _isUDP265 || _isMPEGTS) && _videoSettings.udpPort.visible
                                }
                                FactTextField {
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   _videoSettings.udpPort
                                    visible:                udpPortLabel.visible
                                }

                                QGCLabel {
                                    id:         rtspUrlLabel
                                    text:       qsTr("RTSP URL")
                                    visible:    !_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
                                }
                                FactTextField {
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   _videoSettings.rtspUrl
                                    visible:                rtspUrlLabel.visible
                                }

                                QGCLabel {
                                    id:         tcpUrlLabel
                                    text:       qsTr("TCP URL")
                                    visible:    !_videoAutoStreamConfig && _isTCP && _videoSettings.tcpUrl.visible
                                }
                                FactTextField {
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   _videoSettings.tcpUrl
                                    visible:                tcpUrlLabel.visible
                                }

                                QGCLabel {
                                    text:                   qsTr("Aspect Ratio")
                                    visible:                !_videoAutoStreamConfig && _isGst && _videoSettings.aspectRatio.visible
                                }
                                FactTextField {
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   _videoSettings.aspectRatio
                                    visible:                !_videoAutoStreamConfig && _isGst && _videoSettings.aspectRatio.visible
                                }

                                QGCLabel {
                                    id:         videoFileFormatLabel
                                    text:       qsTr("Record File Format")
                                    visible:    _showSaveVideoSettings && _videoSettings.recordingFormat.visible
                                }
                                FactComboBox {
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   _videoSettings.recordingFormat
                                    visible:                videoFileFormatLabel.visible
                                }

                                QGCLabel {
                                    id:         maxSavedVideoStorageLabel
                                    text:       qsTr("Max Storage Usage")
                                    visible:    _showSaveVideoSettings && _videoSettings.maxVideoSize.visible && _videoSettings.enableStorageLimit.value
                                }
                                FactTextField {
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   _videoSettings.maxVideoSize
                                    visible:                _showSaveVideoSettings && _videoSettings.enableStorageLimit.value && maxSavedVideoStorageLabel.visible
                                }

                                QGCLabel {
                                    id:         videoDecodeLabel
                                    text:       qsTr("Video decode priority")
                                    visible:    forceVideoDecoderComboBox.visible
                                }
                                FactComboBox {
                                    id:                     forceVideoDecoderComboBox
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   _videoSettings.forceVideoDecoder
                                    visible:                fact.visible
                                    indexModel:             false
                                }

                                Item { width: 1; height: 1}
                                FactCheckBox {
                                    text:       qsTr("Disable When Disarmed")
                                    fact:       _videoSettings.disableWhenDisarmed
                                    visible:    !_videoAutoStreamConfig && _isGst && fact.visible
                                }

                                Item { width: 1; height: 1}
                                FactCheckBox {
                                    text:       qsTr("Low Latency Mode")
                                    fact:       _videoSettings.lowLatencyMode
                                    visible:    !_videoAutoStreamConfig && _isGst && fact.visible
                                }

                                Item { width: 1; height: 1}
                                FactCheckBox {
                                    text:       qsTr("Auto-Delete Saved Recordings")
                                    fact:       _videoSettings.enableStorageLimit
                                    visible:    _showSaveVideoSettings && fact.visible
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: adsbSectionLabel.visible }
                    QGCLabel {
                        id:         adsbSectionLabel
                        text:       qsTr("AIS Server")
                        visible:    QGroundControl.settingsManager.adsbVehicleManagerSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: adsbGrid.y + adsbGrid.height + _margins
                        Layout.preferredWidth:  adsbGrid.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                adsbSectionLabel.visible
                        Layout.fillWidth:       true
                        GridLayout {
                            id:                         adsbGrid
                            anchors.topMargin:          _margins
                            Layout.fillWidth:           true
                            anchors.horizontalCenter:   parent.horizontalCenter
                            columns:                    2
                            property var  adsbSettings:    QGroundControl.settingsManager.adsbVehicleManagerSettings
                            FactCheckBox {
                                text:                   adsbGrid.adsbSettings.adsbServerConnectEnabled.shortDescription
                                fact:                   adsbGrid.adsbSettings.adsbServerConnectEnabled
                                visible:                adsbGrid.adsbSettings.adsbServerConnectEnabled.visible
                                Layout.columnSpan:      2
                            }
                            QGCLabel {
                                text:               adsbGrid.adsbSettings.adsbServerHostAddress.shortDescription
                                visible:            adsbGrid.adsbSettings.adsbServerHostAddress.visible
                            }
                            FactTextField {
                                fact:                   adsbGrid.adsbSettings.adsbServerHostAddress
                                visible:                adsbGrid.adsbSettings.adsbServerHostAddress.visible
                                Layout.fillWidth:       true
                            }
                            QGCLabel {
                                text:               adsbGrid.adsbSettings.adsbServerPort.shortDescription
                                visible:            adsbGrid.adsbSettings.adsbServerPort.visible
                            }
                            FactTextField {
                                fact:                   adsbGrid.adsbSettings.adsbServerPort
                                visible:                adsbGrid.adsbSettings.adsbServerPort.visible
                                Layout.preferredWidth:  _valueFieldWidth
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: unitsSectionLabel.visible }
                    QGCLabel {
                        id:         unitsSectionLabel
                        text:       qsTr("Units")
                        visible:    QGroundControl.settingsManager.unitsSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: unitsGrid.height + (_margins * 2)
                        Layout.preferredWidth:  unitsGrid.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                miscSectionLabel.visible
                        Layout.fillWidth:       true

                        GridLayout {
                            id:                         unitsGrid
                            anchors.topMargin:          _margins
                            anchors.top:                parent.top
                            Layout.fillWidth:           false
                            anchors.horizontalCenter:   parent.horizontalCenter
                            flow:                       GridLayout.TopToBottom
                            rows:                       4

                            Repeater {
                                model: [ qsTr("Horizontal Distance"), qsTr("Area"), qsTr("Speed"), qsTr("Temperature") ]
                                QGCLabel { text: modelData }
                            }
                            Repeater {
                                model:  [ QGroundControl.settingsManager.unitsSettings.horizontalDistanceUnits, QGroundControl.settingsManager.unitsSettings.areaUnits, QGroundControl.settingsManager.unitsSettings.speedUnits, QGroundControl.settingsManager.unitsSettings.temperatureUnits ]
                                FactComboBox {
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   modelData
                                    indexModel:             false
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: miscSectionLabel.visible }
                    QGCLabel {
                        id:         miscSectionLabel
                        text:       qsTr("Miscellaneous")
                        visible:    QGroundControl.settingsManager.appSettings.visible
                    }
                    Rectangle {
                        Layout.preferredWidth:  Math.max(comboGrid.width, unitsGrid.width) + (_margins * 2)
                        Layout.preferredHeight: (pathRow.visible ? pathRow.y + pathRow.height : unitsGrid.y + unitsGrid.height)  + (_margins * 2)
                        Layout.fillWidth:       true
                        color:                  qgcPal.windowShade
                        visible:                miscSectionLabel.visible

                        Item {
                            id:                 comboGridItem
                            anchors.margins:    _margins
                            anchors.top:        parent.top
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            height:             comboGrid.height

                            GridLayout {
                                id:                         comboGrid
                                anchors.horizontalCenter:   parent.horizontalCenter
                                columns:                    2

                                QGCLabel {
                                    text:           qsTr("Color Scheme")
                                    visible: QGroundControl.settingsManager.appSettings.indoorPalette.visible
                                }
                                FactComboBox {
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   QGroundControl.settingsManager.appSettings.indoorPalette
                                    indexModel:             false
                                    visible:                QGroundControl.settingsManager.appSettings.indoorPalette.visible
                                }

                                QGCLabel {
                                    text:       qsTr("Map Provider")
                                    width:      _labelWidth
                                }

                                QGCComboBox {
                                    id:             mapCombo
                                    model:          QGroundControl.mapEngineManager.mapProviderList
                                    Layout.preferredWidth:  _comboFieldWidth
                                    onActivated: {
                                        _mapProvider = textAt(index)
                                        QGroundControl.settingsManager.flightMapSettings.mapProvider.value=textAt(index)
                                        QGroundControl.settingsManager.flightMapSettings.mapType.value=QGroundControl.mapEngineManager.mapTypeList(textAt(index))[0]
                                    }
                                    Component.onCompleted: {
                                        var index = mapCombo.find(_mapProvider)
                                        if(index < 0) index = 0
                                        mapCombo.currentIndex = index
                                    }
                                }
                                QGCLabel {
                                    text:       qsTr("Map Type")
                                    width:      _labelWidth
                                }
                                QGCComboBox {
                                    id:             mapTypeCombo
                                    model:          QGroundControl.mapEngineManager.mapTypeList(_mapProvider)
                                    Layout.preferredWidth:  _comboFieldWidth
                                    onActivated: {
                                        _mapType = textAt(index)
                                        QGroundControl.settingsManager.flightMapSettings.mapType.value=textAt(index)
                                    }
                                    Component.onCompleted: {
                                        var index = mapTypeCombo.find(_mapType)
                                        if(index < 0) index = 0
                                        mapTypeCombo.currentIndex = index
                                    }
                                }

                                QGCLabel {
                                    text:                           qsTr("UI Scaling")
                                    visible:                        _appFontPointSize.visible
                                    Layout.alignment:               Qt.AlignVCenter
                                }
                                Item {
                                    width:                          _comboFieldWidth
                                    height:                         baseFontEdit.height * 1.5
                                    visible:                        _appFontPointSize.visible
                                    Layout.alignment:               Qt.AlignVCenter
                                    Row {
                                        spacing:                    ScreenTools.defaultFontPixelWidth
                                        anchors.verticalCenter:     parent.verticalCenter
                                        QGCButton {
                                            width:                  height
                                            height:                 baseFontEdit.height * 1.5
                                            text:                   "-"
                                            anchors.verticalCenter: parent.verticalCenter
                                            onClicked: {
                                                if (_appFontPointSize.value > _appFontPointSize.min) {
                                                    _appFontPointSize.value = _appFontPointSize.value - 1
                                                }
                                            }
                                        }
                                        QGCLabel {
                                            id:                     baseFontEdit
                                            width:                  ScreenTools.defaultFontPixelWidth * 6
                                            text:                   (QGroundControl.settingsManager.appSettings.appFontPointSize.value / ScreenTools.platformFontPointSize * 100).toFixed(0) + "%"
                                            horizontalAlignment:    Text.AlignHCenter
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                        Text {

                                        }

                                        QGCButton {
                                            width:                  height
                                            height:                 baseFontEdit.height * 1.5
                                            text:                   "+"
                                            anchors.verticalCenter: parent.verticalCenter
                                            onClicked: {
                                                if (_appFontPointSize.value < _appFontPointSize.max) {
                                                    _appFontPointSize.value = _appFontPointSize.value + 1
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        //-----------------------------------------------------------------
                        //-- Save path
                        RowLayout {
                            id:                 pathRow
                            anchors.margins:    _margins
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            anchors.top:        comboGridItem.bottom
                            visible:            _savePath.visible && !ScreenTools.isMobile

                            QGCLabel { text: qsTr("Load/Save Path") }
                            QGCTextField {
                                Layout.fillWidth:   true
                                readOnly:           true
                                text:               _savePath.rawValue === "" ? qsTr("<not set>") : _savePath.value
                            }
                            QGCButton {
                                text:       qsTr("Browse")
                                onClicked:  savePathBrowseDialog.openForLoad()
                                QGCFileDialog {
                                    id:             savePathBrowseDialog
                                    title:          qsTr("Choose the location to save/load files")
                                    folder:         _savePath.rawValue
                                    selectExisting: true
                                    selectFolder:   true
                                    onAcceptedForLoad: _savePath.rawValue = file
                                }
                            }
                        }
                    }

                    Item { width: 1; height: _margins; visible: telemetryLogSectionLabel.visible }
                    QGCLabel {
                        id:         telemetryLogSectionLabel
                        text:       qsTr("Telemetry Logs")
                        visible:    telemetryRect.visible
                    }
                    Rectangle {
                        id:                     telemetryRect
                        Layout.preferredHeight: loggingCol.height + (_margins * 2)
                        Layout.preferredWidth:  loggingCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        Layout.fillWidth:       true
                        visible:                promptSaveLog._telemetrySave.visible || logIfNotArmed._telemetrySaveNotArmed.visible || promptSaveCsv._saveCsvTelemetry.visible
                        ColumnLayout {
                            id:                         loggingCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            spacing:                    _margins
                            FactCheckBox {
                                id:         promptSaveLog
                                text:       qsTr("Save log after each mission")
                                fact:       _telemetrySave
                                visible:    _telemetrySave.visible
                                enabled:    !_disableAllDataPersistence
                                property Fact _telemetrySave: QGroundControl.settingsManager.appSettings.telemetrySave
                            }
                            FactCheckBox {
                                id:         logIfNotArmed
                                text:       qsTr("Save logs even if vehicle was not armed")
                                fact:       _telemetrySaveNotArmed
                                visible:    _telemetrySaveNotArmed.visible
                                enabled:    promptSaveLog.checked && !_disableAllDataPersistence
                                property Fact _telemetrySaveNotArmed: QGroundControl.settingsManager.appSettings.telemetrySaveNotArmed
                            }
                            FactCheckBox {
                                id:         promptSaveCsv
                                text:       qsTr("Save CSV log of telemetry data")
                                fact:       _saveCsvTelemetry
                                visible:    _saveCsvTelemetry.visible
                                enabled:    !_disableAllDataPersistence
                                property Fact _saveCsvTelemetry: QGroundControl.settingsManager.appSettings.saveCsvTelemetry
                            }
                        }
                    }

                } // settingsColumn
            }
    }
}
