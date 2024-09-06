import { CapacitorPluginLabelPrinter } from 'capacitor-plugin-label-printer';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    CapacitorPluginLabelPrinter.echo({ value: inputValue })
}
