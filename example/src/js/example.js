import { Plugins } from '@capacitor/core';
import { CapacitorPluginLabelPrinter } from 'capacitor-plugin-label-printer';
async function selectLabelPrinter() {
  try {
    const result = await CapacitorPluginLabelPrinter.getLabelPrinters();
    console.log('Selected label printer:', result.selectedPrinter);
    console.log('Printer make:', result.selectedPrinter.make);
  } catch (error) {
    console.error('Error selecting label printer:', error);
  }
}

window.selectLabelPrinter = selectLabelPrinter;