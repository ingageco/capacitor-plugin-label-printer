import { WebPlugin } from '@capacitor/core';

import type { CapacitorPluginLabelPrinterPlugin } from './definitions';

export class CapacitorPluginLabelPrinterWeb
  extends WebPlugin
  implements CapacitorPluginLabelPrinterPlugin
{
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
