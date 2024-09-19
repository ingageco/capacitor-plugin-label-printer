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
* [`printToBrotherPrinter(...)`](#printtobrotherprinter)
* [`getPrinterInfo(...)`](#getprinterinfo)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### getLabelPrinters()

```typescript
getLabelPrinters() => Promise<{ selectedPrinter: { name: string; url: string; make: string; }; }>
```

**Returns:** <code>Promise&lt;{ selectedPrinter: { name: string; url: string; make: string; }; }&gt;</code>

--------------------


### printToBrotherPrinter(...)

```typescript
printToBrotherPrinter(options: { printerURL: string; imageSource: string; labelSize: string; }) => Promise<{ success: boolean; }>
```

| Param         | Type                                                                         |
| ------------- | ---------------------------------------------------------------------------- |
| **`options`** | <code>{ printerURL: string; imageSource: string; labelSize: string; }</code> |

**Returns:** <code>Promise&lt;{ success: boolean; }&gt;</code>

--------------------


### getPrinterInfo(...)

```typescript
getPrinterInfo(options: { printerURL: string; }) => Promise<PrinterInfo>
```

| Param         | Type                                 |
| ------------- | ------------------------------------ |
| **`options`** | <code>{ printerURL: string; }</code> |

**Returns:** <code>Promise&lt;<a href="#printerinfo">PrinterInfo</a>&gt;</code>

--------------------


### Interfaces


#### PrinterInfo

| Prop                      | Type                     |
| ------------------------- | ------------------------ |
| **`name`**                | <code>string</code>      |
| **`url`**                 | <code>string</code>      |
| **`make`**                | <code>string</code>      |
| **`supportedPaperSizes`** | <code>PaperSize[]</code> |
| **`supportsColor`**       | <code>boolean</code>     |
| **`supportsDuplex`**      | <code>boolean</code>     |


#### PaperSize

| Prop               | Type                |
| ------------------ | ------------------- |
| **`width`**        | <code>number</code> |
| **`height`**       | <code>number</code> |
| **`topMargin`**    | <code>number</code> |
| **`leftMargin`**   | <code>number</code> |
| **`bottomMargin`** | <code>number</code> |
| **`rightMargin`**  | <code>number</code> |

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