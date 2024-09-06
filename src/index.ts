import { registerPlugin } from '@capacitor/core';

export interface CapacitorPluginLabelPrinterPlugin {
  getLabelPrinters(): Promise<{ selectedPrinter: { name: string; url: string; make: string } }>;
}

const CapacitorPluginLabelPrinter = registerPlugin<CapacitorPluginLabelPrinterPlugin>('CapacitorPluginLabelPrinter');

export { CapacitorPluginLabelPrinter };