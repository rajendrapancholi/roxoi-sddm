// Main.qml — ROXOI SDDM Theme · Modern Edition
import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width:  config.ScreenWidth  || Screen.width

    LayoutMirroring.enabled:         config.ForceRightToLeft == "true"
                                     ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    padding:            config.ScreenPadding
    palette.button:     "transparent"
    palette.highlight:  config.AccentColor
    palette.text:       config.MainColor
    palette.buttonText: config.MainColor
    palette.window:     config.BackgroundColor
    font.family:        config.Font
    font.pointSize:     config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    property var hackerQuotes: [
        "> The quieter you become, the more you are able to hear.  — Kali Linux",
        "> Security is not a product, but a process.  — Bruce Schneier",
        "> The only truly secure system is one that is powered off.  — Gene Spafford",
        "> Root access is not a privilege. It's a responsibility.",
        "> sudo make me a sandwich.  — XKCD",
        "> rm -rf /ignorance — execute with caution.",
        "> Information wants to be free.  — Stewart Brand",
        "> Code is poetry. Exploit is art.",
        "> Knowledge is the most powerful weapon.  — Nelson Mandela",
        "> Never trust a computer you can't throw out a window.  — Wozniak",
        "> In a world of locked doors, the person with the key is king.",
        "> Privacy is not a feature — it is a right.",
        "> With great power comes great responsibility.  — Uncle Ben",
        "> Life is too short for proprietary software.",
        "> Hackers don't break systems. They reveal their true shape.",
        "> Curiosity is the engine of achievement.  — Ken Robinson",
        "> Every system is hackable. Every lock has a key.",
        "> The best defense is understanding the offense.",
        "> chmod 777 your mind — open to all, restricted by none.",
        "> There is no patch for human stupidity.",
        "> grep -r 'truth' /reality — no results found.",
        "> Not all those who wander are lost. Some are pentesting.",
        "> Encryption is the right to whisper in a loud world.",
        "> The terminal is my canvas. The command is my brush.",
        "> 0x41414141 — where every exploit begins its journey.",
        "> Don't fear the root. Fear those who misuse it.",
        "> Firewalls are just suggestions to the determined.",
        "> In God we trust. All others we monitor.",
        "> The quietest packets carry the loudest secrets.",
        "> ls -la /secrets — permission denied. Always.",
        "> Any sufficiently advanced bug is indistinguishable from a feature.",
        "> First, do no harm. Then, do no traceable harm.",
        "> We are not criminals. We are cartographers of the digital frontier.",
        "> ping -t existence — waiting for reply...",
        "> A hacker is just a curious mind with root access.",
        "> The best backdoor is the one they built themselves.",
        "> It's not a bug. It's an undocumented feature.",
        "> All your base are belong to us.  — CATS, 2101",
        "> Security through obscurity is not security at all.",
        "> The network is the computer.  — John Gage",
        "> cat /proc/enlightenment — file not found.",
        "> Trust no one. Verify everything. Audit often.",
        "> You can't defend what you don't understand.",
        "> Real hackers don't script. They write the scripts.",
        "> Anonymity is armor. Knowledge is the blade.",
        "> /dev/null — where bad ideas and weak passwords go to die."
    ]

    Item {
        id: sizeHelper
        anchors.fill: parent

        // z:0  Base fill
        Rectangle {
            anchors.fill: parent
            color: "#050f07"
            z: 0
        }

        // z:1  Background image
        Image {
            id: backgroundImage
            anchors.fill: parent
            source:              Qt.resolvedUrl("Backgrounds/Mainbg.png")
            fillMode:            Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignRight
            verticalAlignment:   Image.AlignVCenter
            asynchronous: true; cache: true; mipmap: true
            opacity: 0.85
            z: 1
        }

        // z:7  Oscilloscope signal border
        Canvas {
            id: sigCanvas
            x: sizeHelper.width * 0.45 - 1
            y: 0
            width: 28
            height: sizeHelper.height
            z: 7

            property var  wave:  []
            property real phase: 0
            readonly property int waveCap: 256

            Component.onCompleted: {
                wave.length = waveCap
                for (var i = 0; i < waveCap; i++)
                    wave[i] = Math.random() * 2 - 1
            }

            onPaint: {
                var ctx  = getContext("2d")
                var h    = height
                var wmid = width * 0.5
                var cap  = waveCap

                ctx.clearRect(0, 0, width, h)
                ctx.fillRect(0, 0, width, h)

                ctx.strokeStyle = "#00ff41"
                ctx.lineWidth   = 1.2
                ctx.globalAlpha = 0.75
                ctx.shadowColor = "#00ff41"
                ctx.shadowBlur  = 4
                ctx.beginPath()

                for (var py = 0; py < h; py += 3) {
                    var amp = Math.sin((py * 0.035) + phase) * 4.5 + wave[py % cap] * 2.5
                    if (py === 0) ctx.moveTo(wmid + amp, py)
                    else          ctx.lineTo(wmid + amp, py)
                }
                ctx.stroke()

                ctx.shadowBlur  = 0
                ctx.globalAlpha = 0.18
                ctx.lineWidth   = 1
                var spacing = Math.floor(h / 12)
                for (var t = spacing; t < h; t += spacing) {
                    var tl = (t % (spacing * 3) === 0) ? 7 : 4
                    ctx.beginPath()
                    ctx.moveTo(width - tl, t)
                    ctx.lineTo(width,      t)
                    ctx.stroke()
                }
                ctx.globalAlpha = 1.0
            }

            Timer {
                interval: 66; repeat: true; running: true
                onTriggered: {
                    sigCanvas.phase += 0.09
                    var idx = Math.floor(Math.random() * sigCanvas.waveCap)
                    sigCanvas.wave[idx] = sigCanvas.wave[idx] * 0.85 + (Math.random() * 2 - 1) * 0.5
                    sigCanvas.requestPaint()
                }
            }
        }

        // z:8  Right-edge HUD data strip
        Column {
            anchors.right:          parent.right
            anchors.rightMargin:    18
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10; z: 8; opacity: 0.45

            Repeater {
                model: ListModel {
                    ListElement { label: "SYS";  values: "LINUX;KERNEL;x86_64;POSIX" }
                    ListElement { label: "AUTH"; values: "SDDM;PAM;SHA512;LOCKED" }
                    ListElement { label: "ENC";  values: "AES256;RSA4096;ECDSA;TLS1.3" }
                    ListElement { label: "VPN";  values: "ACTIVE;TUN0;WG;IPSEC" }
                    ListElement { label: "FW";   values: "ENABLED;nftables;DROP;CHAIN" }
                    ListElement { label: "NET";  values: "SECURE;MONITOR;FILTER;IDS" }
                    ListElement { label: "MEM";  values: "OK;ECC;CLEAN;GUARD" }
                    ListElement { label: "PROC"; values: "IDLE;SCHED;NICE;CGROUP" }
                    ListElement { label: "DISK"; values: "EXT4;LUKS;TRIM;FSCK" }
                    ListElement { label: "LOG";  values: "AUDIT;syslog;TRACE;journald" }
                }

                Item {
                    width:  hudLabel.implicitWidth + 8
                    height: hudLabel.implicitHeight

                    property var  vals:    model.values.split(";")
                    property int  vi:      0
                    property bool glitch:  false

                    // Cycle value every ~2.8s, staggered per row
                    Timer {
                        interval: 6000 + (index * 310)
                        repeat: true; running: true
                        onTriggered: {
                            parent.glitch = true
                            glitchOffL.start()
                            parent.vi = (parent.vi + 1) % parent.vals.length
                        }
                    }
                    Timer { id: glitchOffL; interval: 280; onTriggered: parent.glitch = false }

                    Label {
                        id: hudLabel
                        text: model.label + ":" + (parent.glitch
                            ? ["??","##","__",">>","<<","!!"][Math.floor(Math.random()*6)]
                            : parent.vals[parent.vi])
                        font.family:    "Monospace"
                        font.pointSize: root.font.pointSize * 0.9
                        color: parent.glitch ? "#ffff00" : "#00ff41"
                        Behavior on color { ColorAnimation { duration: 80 } }
                    }

                    // Per-row staggered flicker
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite; running: true
                        PauseAnimation  { duration: 3200 + (index * 650) }
                        NumberAnimation { to: 0.12; duration: 70  }
                        NumberAnimation { to: 1.00; duration: 55  }
                        PauseAnimation  { duration: 110            }
                        NumberAnimation { to: 0.12; duration: 55  }
                        NumberAnimation { to: 1.00; duration: 70  }
                    }
                }
            }
        }
        
        // z:8b  Left-edge HUD data strip
        Column {
            anchors.left:           parent.left
            anchors.leftMargin:     18
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10; z: 8; opacity: 0.45

            Repeater {
                model: ListModel {
                    ListElement { label: "CPU";  values: "x86_64;8CORE;3.6GHz;TURBO" }
                    ListElement { label: "GPU";  values: "DRM;KMS;MESA;VULKAN" }
                    ListElement { label: "USR";  values: "ROOT;SUDO;UID:0;WHEEL" }
                    ListElement { label: "PKT";  values: "SNIFF;INJECT;FORGE;RELAY" }
                    ListElement { label: "SSH";  values: "RSA;ED25519;TUNNEL;ALIVE" }
                    ListElement { label: "TOR";  values: "RELAY;BRIDGE;ONION;GUARD" }
                    ListElement { label: "SCAN"; values: "NMAP;XMAS;SYN;STEALTH" }
                    ListElement { label: "EXPL"; values: "0DAY;CVE;RCE;PAYLOAD" }
                    ListElement { label: "HASH"; values: "SHA256;MD5;BLAKE2;ARGON2" }
                    ListElement { label: "CTXT"; values: "SWITCH;FORK;EXEC;SPAWN" }
                }

                Item {
                    width:  hudLabelL.implicitWidth + 8
                    height: hudLabelL.implicitHeight

                    property var  vals:   model.values.split(";")
                    property int  vi:     0
                    property bool glitch: false

                    Timer {
                        interval: 6000 + (index * 310)
                        repeat: true; running: true
                        onTriggered: {
                            parent.glitch = true
                            glitchOffL.start()
                            parent.vi = (parent.vi + 1) % parent.vals.length
                        }
                    }
                    Timer { id: glitchOffL; interval: 280; onTriggered: parent.glitch = false }

                    Label {
                        id: hudLabelL
                        text: model.label + ":" + (parent.glitch
                            ? ["??","##","__",">>","<<","!!"][Math.floor(Math.random()*6)]
                            : parent.vals[parent.vi])
                        font.family:    "Monospace"
                        font.pointSize: root.font.pointSize * 0.9
                        color: parent.glitch ? "#ffff00" : "#00ff41"
                        Behavior on color { ColorAnimation { duration: 80 } }
                    }

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite; running: true
                        PauseAnimation  { duration: 6000 + (index * 720) }
                        NumberAnimation { to: 0.12; duration: 70  }
                        NumberAnimation { to: 1.00; duration: 55  }
                        PauseAnimation  { duration: 110            }
                        NumberAnimation { to: 0.12; duration: 55  }
                        NumberAnimation { to: 1.00; duration: 70  }
                    }
                }
            }
        }

        // z:9  Corner HUD brackets
        Canvas {
            id: cornersCanvas
            anchors.fill: parent; z: 9
            onPaint: {
                var c = getContext("2d"), m = 20, s = 44, gap = 7
                c.clearRect(0, 0, width, height)
                c.lineWidth = 1.5; c.strokeStyle = "#00ff41"; c.globalAlpha = 0.65
                c.beginPath(); c.moveTo(m,m+s);               c.lineTo(m,m);          c.lineTo(m+s,m);          c.stroke()
                c.beginPath(); c.moveTo(width-m-s,m);         c.lineTo(width-m,m);    c.lineTo(width-m,m+s);    c.stroke()
                c.beginPath(); c.moveTo(m,height-m-s);        c.lineTo(m,height-m);   c.lineTo(m+s,height-m);   c.stroke()
                c.beginPath(); c.moveTo(width-m-s,height-m);  c.lineTo(width-m,height-m); c.lineTo(width-m,height-m-s); c.stroke()
                var ii = m+gap, sl = s-gap*2
                c.lineWidth = 0.8; c.globalAlpha = 0.25
                c.beginPath(); c.moveTo(ii,ii+sl);             c.lineTo(ii,ii);            c.lineTo(ii+sl,ii);            c.stroke()
                c.beginPath(); c.moveTo(width-ii-sl,ii);       c.lineTo(width-ii,ii);      c.lineTo(width-ii,ii+sl);      c.stroke()
                c.beginPath(); c.moveTo(ii,height-ii-sl);      c.lineTo(ii,height-ii);     c.lineTo(ii+sl,height-ii);     c.stroke()
                c.beginPath(); c.moveTo(width-ii-sl,height-ii);c.lineTo(width-ii,height-ii);c.lineTo(width-ii,height-ii-sl);c.stroke()
                c.globalAlpha = 0.50; c.fillStyle = "#00ff41"
                var pts = [[m,m],[width-m,m],[m,height-m],[width-m,height-m]]
                for (var p = 0; p < pts.length; p++) {
                    c.beginPath(); c.arc(pts[p][0],pts[p][1],2,0,Math.PI*2); c.fill()
                }
                c.globalAlpha = 1.0
            }
            Component.onCompleted: requestPaint()
        }

        // z:13  Login form — vertically centered in panel
        LoginForm {
            id: form
            anchors.left:           parent.left
            anchors.leftMargin: 200 
            anchors.verticalCenter: parent.verticalCenter

            // nudge down by half the logo+name block height so the
            // combined logo+form reads as one centered stack
            //anchors.verticalCenterOffset: (logoCanvas.height + root.font.pointSize * 3.5) * 0.30

            width:  parent.width * 0.32
            height: implicitHeight   // let content define its own height

            virtualKeyboardActive: virtualKeyboard.state == "visible"
            z: 13
            onSessionChanged: function(idx) {}
        }

        // Virtual keyboard
        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"
            state:  "hidden"
            property bool keyboardActive: item ? item.active : false
            onKeyboardActiveChanged: keyboardActive ? state = "visible" : state = "hidden"
            width: parent.width; z: 13
            function switchState() { state = state == "hidden" ? "visible" : "hidden" }
            states: [
                State {
                    name: "visible"
                    PropertyChanges { target: form;           systemButtonVisibility: false; clockVisibility: false }
                    PropertyChanges { target: virtualKeyboard; y: root.height - virtualKeyboard.height; opacity: 1 }
                },
                State {
                    name: "hidden"
                    PropertyChanges { target: virtualKeyboard; y: root.height - root.height/4; opacity: 0 }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    SequentialAnimation {
                        ScriptAction { script: { virtualKeyboard.item.activated = true; Qt.inputMethod.show() } }
                        ParallelAnimation {
                            NumberAnimation  { target: virtualKeyboard; property: "y"; duration: 100; easing.type: Easing.OutQuad }
                            OpacityAnimator { target: virtualKeyboard;                duration: 100; easing.type: Easing.OutQuad }
                        }
                    }
                },
                Transition {
                    from: "visible"; to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation  { target: virtualKeyboard; property: "y"; duration: 100; easing.type: Easing.InQuad }
                            OpacityAnimator { target: virtualKeyboard;                duration: 100; easing.type: Easing.InQuad }
                        }
                        ScriptAction { script: Qt.inputMethod.hide() }
                    }
                }
            ]
        }

        MouseArea { anchors.fill: parent; onClicked: parent.forceActiveFocus(); z: 5 }

        // z:14  Quote bar
        Item {
            anchors.bottom:           parent.bottom
            anchors.bottomMargin:     16
            anchors.horizontalCenter: parent.horizontalCenter
            width:  parent.width * 0.48
            height: root.font.pointSize * 2.6
            z: 14

            Rectangle {
                anchors.fill: parent; color: Qt.rgba(0, 6/255, 2/255, 0.78)
                radius: 3; border.color: "#00ff41"; border.width: 1; opacity: 0.90
            }
            Rectangle { anchors.left: parent.left;   anchors.leftMargin:  10; anchors.verticalCenter: parent.verticalCenter; width: 2; height: parent.height * 0.45; color: "#00ff41"; opacity: 0.50 }
            Rectangle { anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter; width: 2; height: parent.height * 0.45; color: "#00ff41"; opacity: 0.50 }

            property int qi: Math.floor(Math.random() * root.hackerQuotes.length)

            Label {
                id: quoteLabel
                anchors.centerIn: parent
                width: parent.width - 44
                text:                root.hackerQuotes[parent.qi]
                font.family:         "Monospace"
                font.pointSize:      root.font.pointSize * 0.88
                font.letterSpacing:  0.8
                color:               "#8dffa8"
                elide:               Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                opacity: 0

                SequentialAnimation on opacity {
                    loops: Animation.Infinite; running: true
                    NumberAnimation { to: 0.0; duration: 0 }
                    PauseAnimation  { duration: 500 }
                    NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.OutQuad }
                    PauseAnimation  { duration: 8000 }
                    NumberAnimation { to: 0.0; duration: 800;  easing.type: Easing.InQuad }
                    PauseAnimation  { duration: 200 }
                    ScriptAction    { script: {
                        quoteLabel.parent.qi = (quoteLabel.parent.qi + 1) % root.hackerQuotes.length
                        quoteLabel.text = root.hackerQuotes[quoteLabel.parent.qi]
                    }}
                }
            }
        }

    } // sizeHelper
}
