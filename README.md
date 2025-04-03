# Setup Notes

-  git clone --recursive --j8 [git@github.com](mailto:git@github.com):Shift-Environmental/shift-qgc.git
-  Install gStreamer 1.18.1
   -  [Index of /data/pkg/windows/1.18.1/msvc](https://gstreamer.freedesktop.org/data/pkg/windows/)
-  Install Visual Studio
-  Install QT Creator with Qt 5.x
   -  See "QGroundControl Installation Instructions" section below for a copy of relevant sections of the [qgc-dev-guide getting-started README](https://github.com/mavlink/qgc-dev-guide/blob/master/en/getting_started/README.md) from Dec 2023, when the recommended copy was QGC 5.x

# QGroundControl Ground Control Station

[![Releases](https://img.shields.io/github/release/mavlink/QGroundControl.svg)](https://github.com/mavlink/QGroundControl/releases)

_QGroundControl_ (QGC) is an intuitive and powerful ground control station (GCS) for UAVs.

The primary goal of QGC is ease of use for both first time and professional users.
It provides full flight control and mission planning for any MAVLink enabled drone, and vehicle setup for both PX4 and ArduPilot powered UAVs. Instructions for _using QGroundControl_ are provided in the [User Manual](https://docs.qgroundcontrol.com/en/) (you may not need them because the UI is very intuitive!)

All the code is open-source, so you can contribute and evolve it as you want.
The [Developer Guide](https://dev.qgroundcontrol.com/en/) explains how to [build](https://dev.qgroundcontrol.com/en/getting_started/) and extend QGC.

Key Links:

-  [Website](http://qgroundcontrol.com) (qgroundcontrol.com)
-  [User Manual](https://docs.qgroundcontrol.com/en/)
-  [Developer Guide](https://dev.qgroundcontrol.com/en/)
-  [Discussion/Support](https://docs.qgroundcontrol.com/en/Support/Support.html)
-  [Contributing](https://dev.qgroundcontrol.com/en/contribute/)
-  [License](https://github.com/mavlink/qgroundcontrol/blob/master/COPYING.md)

# QGroundControl Installation Instructions

-  _These instructions are for Windows._
-  **Required Qt Version:** 5.15.2

## Install Visual Studio

-  The Windows compiler can be found here: [Visual Studio 2019 compiler](https://visualstudio.microsoft.com/vs/older-downloads/) (64 bit)
-  _Note:_ Original QGC installation instructions for 5.x versions requested Visual Studio version 2019- The newest version of Visual Studio will work instead.
-  When installing, select *Desktop development with C++* as shown below.
   [![Visual Studio 2019 - Select Desktop Environment with C++](https://github.com/mavlink/qgc-dev-guide/raw/master/assets/getting_started/visual_studio_select_features.png)](https://github.com/mavlink/qgc-dev-guide/blob/master/assets/getting_started/visual_studio_select_features.png)

> **Note** Visual Studio is ONLY used to get the compiler. Actually building *QGroundControl* should be done using [Qt Creator](https://github.com/mavlink/qgc-dev-guide/blob/master/en/getting_started/README.md#qt-creator).

## Install Qt

You **need to install Qt as described below** instead of using pre-built packages from say, a Linux distribution, because *QGroundControl* needs access to private Qt headers.

To install Qt:

1. Download and run the [Qt Online Installer](http://www.qt.io/download-open-source)
2. On "Installation options", unselect "Qt x.x for desktop development", and select "Custom Installation" instead.
3. On the "Customize" tab, click "Show" in the top bar and select "Archive". Click "Yes" to warning popup, view them anyway.
4. Expand the "Qt" dropdown, and then select version 5.15.2 to expand the drop down for that. Not all components are needed. Select the following:
   -  Qt:
      -  Qt 5.15.2:
         -  _MSVC 2019 64 bit_
         -  _Qt Charts_
5. Expand the "Qt Creator" tab at the bottom of the list, and select to install the latest Qt Creator (16.0.0 at the time of writing this).
   -  Qt Creator:
      -  Qt Creator 16.0.0
6. Select Next, and continue through the installation process to download QGC and Qt Creator.

   [![Screenshot-2025-04-03-142320.png](https://i.postimg.cc/7PfVbHPY/Screenshot-2025-04-03-142320.png)](https://postimg.cc/rz2WPLtv)

   _Qt Online Installer Screenshot Example_

## Building using Qt Creator

1. Launch *Qt Creator*
2. In the top menu, select "File" > "Open Project or Folder"
3. Navigate to the local shift-qgc repository, and open **qgroundcontrol.pro**.
   This will use qmake to build the project.
4. Wait for the project to compile.
5. There will be messages outputted under the "General Message" tab. This is normal.
   [![image.png](https://i.postimg.cc/Vk1n9mwt/image.png)](https://postimg.cc/fJ2VD4JW)
6. Build using the "hammer" (or "play") icons in the bottom left hand corner.
7. Screenshot demonstrating build icons, and project details to compare & ensure is correct.
   [![Screenshot-2025-04-03-145030.png](https://i.postimg.cc/3rmktVnF/Screenshot-2025-04-03-145030.png)](https://postimg.cc/Lh44XCdJ)
