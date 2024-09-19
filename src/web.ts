import { WebPlugin } from '@capacitor/core';

import type { CapacitorPluginLabelPrinterPlugin, PrintToBrotherPrinterOptions, PrinterInfo } from './definitions';

export class CapacitorPluginLabelPrinterWeb extends WebPlugin implements CapacitorPluginLabelPrinterPlugin {
  async getLabelPrinters(): Promise<{ selectedPrinter: { name: string; url: string; make: string } }> {
    throw new Error('Method not implemented for web.');
  }

  async printToBrotherPrinter(options: PrintToBrotherPrinterOptions): Promise<{ success: boolean }> {
    console.log('printToBrotherPrinter', options);
    throw new Error('Method not implemented for web.');
  }

  async getPrinterInfo(options: { printerURL: string }): Promise<PrinterInfo> {
    console.log('getPrinterInfo', options);
    throw new Error('Method not implemented for web.');
  }
}
