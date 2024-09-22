import { registerPlugin } from '@capacitor/core';

export interface CapacitorPluginLabelPrinterPlugin {
  getBrotherPrinters(): Promise<{
    printers: Array<{
      modelName: string;
      ipAddress: string;
      printerModel: string;
    }>
  }>;
  cancelPrinterSearch(): Promise<void>;
  printLabel(options: {
    ipAddress: string,
    imageUrl: string
  }): Promise<{ success: boolean }>;
  cancelPrinting(): Promise<void>;
}

const CapacitorPluginLabelPrinter = registerPlugin<CapacitorPluginLabelPrinterPlugin>('CapacitorPluginLabelPrinter');

export { CapacitorPluginLabelPrinter };