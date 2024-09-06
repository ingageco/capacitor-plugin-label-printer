export interface CapacitorPluginLabelPrinterPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
