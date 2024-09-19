import { registerPlugin } from '@capacitor/core';
import type { CapacitorPluginLabelPrinterPlugin, PrinterInfo, PaperSize } from './definitions';

const CapacitorPluginLabelPrinter = registerPlugin<CapacitorPluginLabelPrinterPlugin>('CapacitorPluginLabelPrinter');

export { CapacitorPluginLabelPrinter, PrinterInfo, PaperSize };