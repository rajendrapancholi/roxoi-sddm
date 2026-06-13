// Components/LoginForm.qml — ROXOI SDDM Theme

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Item {
    id: loginForm

    property bool virtualKeyboardActive: false
    property bool failed: false
    property var stackView
    signal sessionChanged(int session)

    Connections {
        target: sddm
        function onLoginSucceeded() {
            loginForm.failed = false
        }
        function onLoginFailed() {
            loginForm.failed = true
            failedClearTimer.restart()
        }
    }

    Timer {
        id: failedClearTimer
        interval: 2000
        repeat:   false
        onTriggered: loginForm.failed = false
    }

    // All content centered vertically in the panel
    Column {
        id: content
        anchors.centerIn: parent
        width: parent.width - 32   // 16px padding each side (matches HTML padding: 16px)
        spacing: 10                // matches HTML gap: 10px

        // Avatar + Clock (Clock.qml contains avatar, greeting, time, date, sep)
        Clock {
            width: parent.width
        }

        // Input form (labels + fields + button)
        Input {
            id: inputForm
            width: parent.width
            failed: loginForm.failed

            onLoginRequest: {
                loginForm.failed = false
                failedClearTimer.stop()
                sddm.login(username, password, inputForm.currentSession)
            }

            exposeSession.onCurrentIndexChanged: {
                loginForm.sessionChanged(inputForm.currentSession)
            }
        }
        
        // System power buttons
        SystemButtons {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 100
        }

        // Virtual keyboard toggle
        Item {
            width:   parent.width
            height:  root.font.pointSize * 1.8
            visible: config.ForceHideVirtualKeyboardButton != "true"

            Button {
                id: vkbToggle
                anchors.horizontalCenter: parent.horizontalCenter
                hoverEnabled: true

                contentItem: Label {
                    text:           "[ VIRTUAL KEYBOARD ]"
                    font.family:    "Monospace"
                    font.pointSize: root.font.pointSize * 0.55
                    color: vkbToggle.hovered ? "#00ff41" : Qt.rgba(0, 1, 0.25, 0.45)
                    horizontalAlignment: Text.AlignHCenter
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                background: Rectangle {
                    color:        "transparent"
                    border.color: vkbToggle.hovered ? Qt.rgba(0, 1, 0.25, 0.40) : "transparent"
                    border.width: 1
                    radius: 3
                }

                onClicked: {
                    if (inputPanel.active) {
                        inputPanel.active = false
                    } else {
                        inputPanel.active = true
                        inputPanel.item.active = true
                    }
                }
            }
        }
    }
}
