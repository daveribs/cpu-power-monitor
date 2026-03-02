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

    property int cfg_delayDefault
    property bool cfg_boldDefault
    property string cfg_raplPathDefault

    Kirigami.FormLayout {

        Controls.CheckBox {
            id: bold
            text: "Use Bold Text"
        }

        Controls.SpinBox {
            id: delay

            from: decimalToInt(0.1)
            value: decimalToInt(1.0)
            to: decimalToInt(10)
            stepSize: decimalToInt(0.1)
            editable: true
            Kirigami.FormData.label: "Update Delay"
            hoverEnabled: true

            property int decimals: 1
            property real realValue: value / decimalFactor
            readonly property int decimalFactor: Math.pow(10, decimals)

            function decimalToInt(decimal) {
                return decimal * decimalFactor;
            }

            validator: DoubleValidator {
                bottom: Math.min(delay.from, delay.to)
                top: Math.max(delay.from, delay.to)
                decimals: delay.decimals
                notation: DoubleValidator.StandardNotation
            }

            textFromValue: function (value, locale) {
                return Number(value / decimalFactor).toLocaleString(locale, 'f', delay.decimals);
            }

            valueFromText: function (text, locale) {
                return Math.round(Number.fromLocaleString(locale, text) * decimalFactor);
            }
        }


        Controls.TextField {
            id: raplPathField
            Kirigami.FormData.label: "RAPL path"
            text: cfg_raplPath
            onTextChanged: cfg_raplPath = text
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
