export interface CapacitorPluginLabelPrinterPlugin {
  getLabelPrinters(): Promise<{ selectedPrinter: { name: string; url: string; make: string } }>;
}