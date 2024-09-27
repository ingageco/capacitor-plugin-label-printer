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
    ipAddress: string;
    imageUrl: string;
    labelSize: string;
    autoCut: boolean;
  }): Promise<{ success: boolean }>;
  printLabels(options: {
    ipAddress: string;
    imageUrls: string[];
    labelSize: string;
    autoCut: boolean;
  }): Promise<{ success: boolean }>;
  cancelPrinting(): Promise<void>;
  getPrinterStatus(ipAddress: string): Promise<{ status: string }>;
}

const CapacitorPluginLabelPrinter = registerPlugin<CapacitorPluginLabelPrinterPlugin>('CapacitorPluginLabelPrinter');

export { CapacitorPluginLabelPrinter };