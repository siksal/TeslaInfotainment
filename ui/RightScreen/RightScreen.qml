import QtQuick 2.15
import QtLocation
import QtPositioning
import systemHandler 1.0

Rectangle {
    id: rightScreen

    anchors {
        top: parent.top
        bottom: bottomBar.top
        right: parent.right
    }

    width: parent.width * 2/3

    Plugin {
        id: mapPlugin
        name: "osm"
        PluginParameter { name: "osm.mapping.providersrepository.address"; value: "https://www.example.com/qt-osm-map-providers/" }
        PluginParameter { name: "osm.mapping.highdpi_tiles"; value: true }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(6.6054, 3.2438) // Ayobo
        zoomLevel: 14
        property geoCoordinate startCentroid

        PinchHandler {
            id: pinch
            target: null
            onActiveChanged: if (active) {
                map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
            }
            onScaleChanged: (delta) => {
                map.zoomLevel += Math.log2(delta)
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            onRotationChanged: (delta) => {
                map.bearing -= delta
                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
            }
            grabPermissions: PointerHandler.TakeOverForbidden
        }
        WheelHandler {
            id: wheel
            // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
            // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
            // and we don't yet distinguish mice and trackpads on Wayland either
            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                             ? PointerDevice.Mouse | PointerDevice.TouchPad
                             : PointerDevice.Mouse
            rotationScale: 1/120
            property: "zoomLevel"
        }
        DragHandler {
            id: drag
            target: null
            onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
        }
        Shortcut {
            enabled: map.zoomLevel < map.maximumZoomLevel
            sequence: StandardKey.ZoomIn
            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
        }
        Shortcut {
            enabled: map.zoomLevel > map.minimumZoomLevel
            sequence: StandardKey.ZoomOut
            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
        }
    }

    SystemHandler {
        id: systemHandler
    }

    Image {
        id: lockIcon
        anchors {
            left: parent.left
            top: parent.top
            margins: 20
        }
        width: parent.width / 40
        fillMode: Image.PreserveAspectFit
        source: (systemHandler.carLocked ? "../assets/lock.png" : "../assets/unlock.png")

        MouseArea {
            anchors.fill: parent
            onClicked: systemHandler.setCarLocked(!systemHandler.carLocked)
        }
    }

    Text {
        id: dateTimeDisplay
        anchors {
            left: lockIcon.right
            leftMargin: 20
            bottom: lockIcon.bottom
        }

        font.pixelSize: 15
        color: "#4f4f4f"

        text: systemHandler.currentTime
    }

    Text {
        id: outdoorTemperatureDisplay
        anchors {
            left: dateTimeDisplay.right
            leftMargin: 20
            bottom: lockIcon.bottom
        }

        font.pixelSize: 15
        color: "#4f4f4f"

        text: systemHandler.outdoorTemp + "°F"
    }

    Image {
        id: userIcon
        anchors {
            left: outdoorTemperatureDisplay.right
            top: parent.top
            leftMargin: 20
            topMargin: 22
        }
        width: parent.width / 50
        fillMode: Image.PreserveAspectFit
        source: "../assets/user-icon.png"
    }

    Text {
        id: userNameDisplay
        anchors {
            left: userIcon.right
            leftMargin: 5
            bottom: lockIcon.bottom
        }

        font.pixelSize: 15
        color: "#4f4f4f"

        text: systemHandler.userName
    }
}
