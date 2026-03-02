import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils

SimpleKCM {
    id: configItem

    property alias cfg_delay: delay.value
    property alias cfg_bold: bold.checked
    property string cfg_raplPath: raplPathField.text

    Kirigami.FormLayout {

        Controls.CheckBox {
            id: bold
            text: "Use Bold Text"
        }

        Controls.SpinBox {
            id: delay
            Kirigami.FormData.label: "Update interval (ms)"
            from: 100
            to: 10000
            stepSize: 100
        }


        Controls.TextField {
            id: raplPathField
            Kirigami.FormData.label: "RAPL path"
            text: plasmoid.configuration.raplPath
            placeholderText: "/sys/class/powercap/intel-rapl:0/energy_uj"
            onTextChanged: plasmoid.configuration.raplPath = text
        }

        Controls.Button {
            text: "Browse…"
            onClicked: fileDialog.open()
        }

        FileDialog {
            id: fileDialog
            title: "Select RAPL"
            fileMode: FileDialog.OpenFile
            onAccepted: {
                var path = selectedFile.toString()
                path = path.replace("file://", "")
                raplPathField.text = path
            }
        }
    }
}
