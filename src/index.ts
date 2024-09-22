import { registerPlugin } from '@capacitor/core';

export interface CapacitorPluginLabelPrinterPlugin {
  getBrotherPrinters(): Promise<{
    printers: Array<{
      modelName: string;
      ipAddress: string;
    }>
  }>;
  getPrinters(): Promise<{ selectedPrinter: { name: string; url: string; make: string, ipAddress: string } }>;
  printLabel(options: { ipAddress: string, modelName: string, text: string }): Promise<{ success: boolean }>;

}

const CapacitorPluginLabelPrinter = registerPlugin<CapacitorPluginLabelPrinterPlugin>('CapacitorPluginLabelPrinter');

export { CapacitorPluginLabelPrinter };