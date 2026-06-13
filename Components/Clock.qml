// Components/Clock.qml — ROXOI SDDM Theme

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Column {
    id: clock
    spacing: 6
    width: parent.width
    
    Item {
        id: logoItem
        anchors.horizontalCenter: parent.horizontalCenter
        width:  root.font.pointSize * 10
        height: root.font.pointSize * 10

        // Outer glow ring
        Rectangle {
            anchors.centerIn: parent
            width:  parent.width
            height: parent.height
            radius: width / 2
            color:  "transparent"
            border.color: "#00ff41"
            border.width: 2
            layer.enabled: true
            layer.effect: Glow {
                radius:            10
                samples:           21
                color:             "#00ff41"
                transparentBorder: true
            }
        }

        // Circular clipped logo image
        Rectangle {
            id: clipMask
            anchors.centerIn: parent
            width:  parent.width  - 8
            height: parent.height - 8
            radius: width / 2
            clip:   true
            color:  "transparent"

            Image {
                anchors.fill: parent
                source:       Qt.resolvedUrl("../Assets/roxoi3d2.png")
                fillMode:     Image.PreserveAspectCrop
                smooth:       true
                mipmap:       true
                asynchronous: true
            }
        }

        // Pulsing glow opacity — same as the old canvas
        SequentialAnimation on opacity {
            loops:   Animation.Infinite
            running: true
            NumberAnimation { to: 0.75; duration: 1800; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.00; duration: 1800; easing.type: Easing.InOutSine }
        }
    }

    // Name + tagline under the logo
    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family:    "Monospace"
        font.pointSize: root.font.pointSize * 3
        font.bold:      true
        color:          "#00ff41"
        opacity:        0.88
        text:           "RAJE PANCHOLI"
        renderType:     Text.QtRendering
    }

    // Greeting
    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        font.family:    "Monospace"
        font.pointSize: root.font.pointSize * 1.2
        color:          "#00ff41"
        opacity:        0.75
        renderType:     Text.QtRendering

        function getGreeting() {
            var h = new Date().getHours()
            if (h >= 5  && h < 12) return "> GOOD_MORNING.exe"
            if (h >= 12 && h < 17) return "> GOOD_AFTERNOON.exe"
            if (h >= 17 && h < 21) return "> GOOD_EVENING.exe"
            return "> GOOD_NIGHT.exe"
        }

        text: getGreeting()

        // Blinking cursor effect
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: true
            PauseAnimation  { duration: 2800 }
            NumberAnimation { to: 0.2; duration: 80 }
            NumberAnimation { to: 0.75; duration: 80 }
            PauseAnimation  { duration: 120 }
            NumberAnimation { to: 0.2; duration: 80 }
            NumberAnimation { to: 0.75; duration: 80 }
        }
    }

    // Time display
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width:  timeLabel.width + 16
        height: timeLabel.height + 4

        Label {
            id: timeLabel
            anchors.centerIn: parent
            font.family:    "Monospace"
            font.pointSize: root.font.pointSize * 3.2
            font.weight:    Font.Bold
            color:          "#00ff41"
            renderType:     Text.QtRendering

            function updateTime() {
                text = new Date().toLocaleTimeString(
                    Qt.locale(config.Locale),
                    config.HourFormat == "long"
                        ? Locale.LongFormat
                        : config.HourFormat !== ""
                            ? config.HourFormat
                            : "HH:mm"
                )
            }
        }
    }

    // Date string
    Label {
        id: dateLabel
        anchors.horizontalCenter: parent.horizontalCenter
        font.family:    "Monospace"
        font.pointSize: root.font.pointSize * 0.62
        color:          "#00ff41"
        opacity:        0.70
        renderType:     Text.QtRendering

        function updateTime() {
            text = new Date().toLocaleDateString(
                Qt.locale(config.Locale),
                config.DateFormat == "short"
                    ? Locale.ShortFormat
                    : config.DateFormat !== ""
                        ? config.DateFormat
                        : Locale.LongFormat
            ).toUpperCase()
        }
    }

    // Separator
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        width:   parent.width * 0.60
        height:  1
        color:   "#00ff41"
        opacity: 0.25

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: true
            NumberAnimation { to: 0.10; duration: 3000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.40; duration: 3000; easing.type: Easing.InOutSine }
        }
    }

    Timer {
        interval: 1000; repeat: true; running: true
        onTriggered: { dateLabel.updateTime(); timeLabel.updateTime() }
    }

    Component.onCompleted: { dateLabel.updateTime(); timeLabel.updateTime() }
}
