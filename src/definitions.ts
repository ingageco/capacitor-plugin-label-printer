export interface CapacitorPluginLabelPrinterPlugin {
  getLabelPrinters(): Promise<{ selectedPrinter: { name: string; url: string; make: string } }>;
  printToBrotherPrinter(options: PrintToBrotherPrinterOptions): Promise<{ success: boolean }>;
  getPrinterInfo(options: { printerURL: string }): Promise<PrinterInfo>;
}

export interface PrintToBrotherPrinterOptions {
  printerURL: string;
  imageSource: string;
  labelSize: "62x100mm" | "29x62mm";
  rotate?: boolean;
}

export interface PrinterInfo {
  name: string;
  url: string;
  make: string;
  supportedPaperSizes: PaperSize[];
  supportsColor: boolean;
  supportsDuplex: boolean;
}

export interface PaperSize {
  width: number;
  height: number;
  topMargin: number;
  leftMargin: number;
  bottomMargin: number;
  rightMargin: number;
}