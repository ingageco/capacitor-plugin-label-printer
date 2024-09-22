
import { CapacitorPluginLabelPrinter } from 'capacitor-plugin-label-printer';

async function selectPrinter() {
  try {
    const result = await CapacitorPluginLabelPrinter.getPrinters();
    console.log("Selected label printer:", result.selectedPrinter);
    console.log("Printer make:", result.selectedPrinter.make);
    window.selectedPrinter = result.selectedPrinter;
    return result.selectedPrinter;
  } catch (error) {
    console.error("Error selecting label printer:", error);
  }
}

async function getBrotherPrinters() {
  try {
    const result = await CapacitorPluginLabelPrinter.getBrotherPrinters();
    console.log("printers:", result);
    return result;
  } catch (error) {
    console.error("Error getting brother printers:", error);
  }
}
async function getPrinterInfo(printerURL) {
  // try {
  //   const printerInfo = await CapacitorPluginLabelPrinter.getPrinterInfo({
  //     printerURL
  //   });
  //   console.log("Printer Info:", printerInfo);
  //   console.log("Supported Paper Sizes:", printerInfo.supportedPaperSizes);
  //   console.log("Supports Color:", printerInfo.supportsColor);
  //   console.log("Supports Duplex:", printerInfo.supportsDuplex);
  //   return printerInfo;
  // } catch (error) {
  //   console.error("Error getting printer info:", error);
  // }
}
async function printToBrotherPrinter(options) {
  try {
    const result = await CapacitorPluginLabelPrinter.printToBrotherPrinter(options);
    if (result.success) {
      console.log("Printing successful");
    } else {
      console.log("Printing failed");
    }
  } catch (error) {
    console.error("Error printing:", error);
  }
}
window.selectPrinter = selectPrinter;
window.getBrotherPrinters = getBrotherPrinters;

window.printToBrotherPrinter = printToBrotherPrinter;
window.getPrinterInfo = getPrinterInfo;