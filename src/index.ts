import { registerPlugin } from '@capacitor/core';

import type { CapacitorPluginLabelPrinterPlugin } from './definitions';

const CapacitorPluginLabelPrinter =
  registerPlugin<CapacitorPluginLabelPrinterPlugin>(
    'CapacitorPluginLabelPrinter',
    {
      web: () =>
        import('./web').then(m => new m.CapacitorPluginLabelPrinterWeb()),
    },
  );

export * from './definitions';
export { CapacitorPluginLabelPrinter };
