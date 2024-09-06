# capacitor-plugin-label-printer

Capacitor plugin for printing to Dymo and Brother label printers.

## Install

```bash
npm install capacitor-plugin-label-printer
npx cap sync
```

## API

<docgen-index>

* [`getLabelPrinters()`](#getlabelprinters)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### getLabelPrinters()

```typescript
getLabelPrinters() => Promise<{ selectedPrinter: LabelPrinter; }>
```


Opens a native iOS printer picker dialog filtered for Dymo and Brother label printers.

**Returns:** <code>Promise&lt;{ selectedPrinter: <a href="#labelprinter">LabelPrinter</a>; }&gt;</code>

**Since:** 1.0.0

--------------------


### Interfaces


#### LabelPrinter

| Prop         | Type                |
| ------------ | ------------------- |
| **`name`**   | <code>string</code> |
| **`url`**    | <code>string</code> |
| **`make`**   | <code>string</code> |


</docgen-api>

## Usage

```typescript
import { Plugins } from '@capacitor/core';
import { CapacitorPluginLabelPrinter } from 'capacitor-plugin-label-printer';
async function selectLabelPrinter() {
  try {
    const result = await CapacitorPluginLabelPrinter.getLabelPrinters();
    console.log('Selected label printer:', result.selectedPrinter);
    console.log('Printer make:', result.selectedPrinter.make);
  } catch (error) {
    console.error('Error selecting label printer:', error);
  }
}
```


## Supported Platforms

- iOS

This plugin is designed to work with iOS devices only. It uses the native `UIPrinterPickerController` to present a list of available printers, filtered for Dymo and Brother label printers.

## Notes

- The plugin identifies Dymo and Brother printers based on their display names. This method may not be 100% accurate if printer names are customized.
- For more robust printer identification or additional features, consider integrating with printer-specific SDKs.
- Android support is not currently implemented in this plugin.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT