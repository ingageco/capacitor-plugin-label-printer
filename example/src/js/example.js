import { CapacitorPluginLabelPrinter } from 'capacitor-plugin-label-printer';




async function selectLabelPrinter() {
  try {
    const result = await CapacitorPluginLabelPrinter.getLabelPrinters();
    console.log('Selected label printer:', result.selectedPrinter);
    console.log('Printer make:', result.selectedPrinter.make);

    window.selectedPrinter = result.selectedPrinter;

    return result.selectedPrinter;
    
  } catch (error) {
    console.error('Error selecting label printer:', error);
  }
}


async function getPrinterInfo(printerURL) {
    try {
        const printerInfo = await CapacitorPluginLabelPrinter.getPrinterInfo({
            printerURL: printerURL
        });
        console.log('Printer Info:', printerInfo);
        console.log('Supported Paper Sizes:', printerInfo.supportedPaperSizes);
        console.log('Supports Color:', printerInfo.supportsColor);
        console.log('Supports Duplex:', printerInfo.supportsDuplex);

        return printerInfo;

    } catch (error) {
        console.error('Error getting printer info:', error);
    }
}


async function printToBrotherPrinter(options) {
    try {
        const result = await CapacitorPluginLabelPrinter.printToBrotherPrinter(options);
        if (result.success) {
        console.log('Printing successful');
        } else {
        console.log('Printing failed');
        }
    } catch (error) {
        console.error('Error printing:', error);
    }
}

window.selectLabelPrinter = selectLabelPrinter;
window.printToBrotherPrinter = printToBrotherPrinter;
window.getPrinterInfo = getPrinterInfo;