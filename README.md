# capacitor-plugin-label-printer

Capacitor plugin for printing to Dymo and Brother label printers.

## Install

```bash
npm install capacitor-plugin-label-printer
npx cap sync
```

## API

<docgen-index>

* [`getBrotherPrinters()`](#getbrotherprinters)
* [`cancelPrinterSearch()`](#cancelprintersearch)
* [`printLabel(...)`](#printlabel)
* [`printLabels(...)`](#printlabels)
* [`cancelPrinting()`](#cancelprinting)
* [`getPrinterStatus(...)`](#getprinterstatus)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### getBrotherPrinters()

```typescript
getBrotherPrinters() => Promise<{ printers: Array<{ modelName: string; ipAddress: string; printerModel: string; }>; }>
```

**Returns:** <code>Promise&lt;{ printers: { modelName: string; ipAddress: string; printerModel: string; }[]; }&gt;</code>

--------------------


### cancelPrinterSearch()

```typescript
cancelPrinterSearch() => Promise<void>
```

--------------------


### printLabel(...)

```typescript
printLabel(ipAddress: string, imageUrl: string) => Promise<{ success: boolean; }>
```

| Param           | Type                |
| --------------- | ------------------- |
| **`ipAddress`** | <code>string</code> |
| **`imageUrl`**  | <code>string</code> |

**Returns:** <code>Promise&lt;{ success: boolean; }&gt;</code>

--------------------


### printLabels(...)

```typescript
printLabels(ipAddress: string, imageUrls: string[]) => Promise<{ success: boolean; }>
```

| Param           | Type                  |
| --------------- | --------------------- |
| **`ipAddress`** | <code>string</code>   |
| **`imageUrls`** | <code>string[]</code> |

**Returns:** <code>Promise&lt;{ success: boolean; }&gt;</code>

--------------------


### cancelPrinting()

```typescript
cancelPrinting() => Promise<void>
```

--------------------


### getPrinterStatus(...)

```typescript
getPrinterStatus(ipAddress: string) => Promise<{ status: string; }>
```

| Param           | Type                |
| --------------- | ------------------- |
| **`ipAddress`** | <code>string</code> |

**Returns:** <code>Promise&lt;{ status: string; }&gt;</code>

--------------------


### Interfaces


#### Array

| Prop         | Type                | Description                                                                                            |
| ------------ | ------------------- | ------------------------------------------------------------------------------------------------------ |
| **`length`** | <code>number</code> | Gets or sets the length of the array. This is a number one higher than the highest index in the array. |

| Method             | Signature                                                                                                                     | Description                                                                                                                                                                                                                                 |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **toString**       | () =&gt; string                                                                                                               | Returns a string representation of an array.                                                                                                                                                                                                |
| **toLocaleString** | () =&gt; string                                                                                                               | Returns a string representation of an array. The elements are converted to string using their toLocalString methods.                                                                                                                        |
| **pop**            | () =&gt; T \| undefined                                                                                                       | Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.                                                                                                          |
| **push**           | (...items: T[]) =&gt; number                                                                                                  | Appends new elements to the end of an array, and returns the new length of the array.                                                                                                                                                       |
| **concat**         | (...items: <a href="#concatarray">ConcatArray</a>&lt;T&gt;[]) =&gt; T[]                                                       | Combines two or more arrays. This method returns a new array without modifying any existing arrays.                                                                                                                                         |
| **concat**         | (...items: (T \| <a href="#concatarray">ConcatArray</a>&lt;T&gt;)[]) =&gt; T[]                                                | Combines two or more arrays. This method returns a new array without modifying any existing arrays.                                                                                                                                         |
| **join**           | (separator?: string \| undefined) =&gt; string                                                                                | Adds all the elements of an array into a string, separated by the specified separator string.                                                                                                                                               |
| **reverse**        | () =&gt; T[]                                                                                                                  | Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.                                                                                                                        |
| **shift**          | () =&gt; T \| undefined                                                                                                       | Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.                                                                                                         |
| **slice**          | (start?: number \| undefined, end?: number \| undefined) =&gt; T[]                                                            | Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 refers to the second to last element of the array.                           |
| **sort**           | (compareFn?: ((a: T, b: T) =&gt; number) \| undefined) =&gt; this                                                             | Sorts an array in place. This method mutates the array and returns a reference to the same array.                                                                                                                                           |
| **splice**         | (start: number, deleteCount?: number \| undefined) =&gt; T[]                                                                  | Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.                                                                                                                      |
| **splice**         | (start: number, deleteCount: number, ...items: T[]) =&gt; T[]                                                                 | Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.                                                                                                                      |
| **unshift**        | (...items: T[]) =&gt; number                                                                                                  | Inserts new elements at the start of an array, and returns the new length of the array.                                                                                                                                                     |
| **indexOf**        | (searchElement: T, fromIndex?: number \| undefined) =&gt; number                                                              | Returns the index of the first occurrence of a value in an array, or -1 if it is not present.                                                                                                                                               |
| **lastIndexOf**    | (searchElement: T, fromIndex?: number \| undefined) =&gt; number                                                              | Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.                                                                                                                                      |
| **every**          | &lt;S extends T&gt;(predicate: (value: T, index: number, array: T[]) =&gt; value is S, thisArg?: any) =&gt; this is S[]       | Determines whether all the members of an array satisfy the specified test.                                                                                                                                                                  |
| **every**          | (predicate: (value: T, index: number, array: T[]) =&gt; unknown, thisArg?: any) =&gt; boolean                                 | Determines whether all the members of an array satisfy the specified test.                                                                                                                                                                  |
| **some**           | (predicate: (value: T, index: number, array: T[]) =&gt; unknown, thisArg?: any) =&gt; boolean                                 | Determines whether the specified callback function returns true for any element of an array.                                                                                                                                                |
| **forEach**        | (callbackfn: (value: T, index: number, array: T[]) =&gt; void, thisArg?: any) =&gt; void                                      | Performs the specified action for each element in an array.                                                                                                                                                                                 |
| **map**            | &lt;U&gt;(callbackfn: (value: T, index: number, array: T[]) =&gt; U, thisArg?: any) =&gt; U[]                                 | Calls a defined callback function on each element of an array, and returns an array that contains the results.                                                                                                                              |
| **filter**         | &lt;S extends T&gt;(predicate: (value: T, index: number, array: T[]) =&gt; value is S, thisArg?: any) =&gt; S[]               | Returns the elements of an array that meet the condition specified in a callback function.                                                                                                                                                  |
| **filter**         | (predicate: (value: T, index: number, array: T[]) =&gt; unknown, thisArg?: any) =&gt; T[]                                     | Returns the elements of an array that meet the condition specified in a callback function.                                                                                                                                                  |
| **reduce**         | (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array: T[]) =&gt; T) =&gt; T                           | Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as an argument in the next call to the callback function.                      |
| **reduce**         | (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array: T[]) =&gt; T, initialValue: T) =&gt; T          |                                                                                                                                                                                                                                             |
| **reduce**         | &lt;U&gt;(callbackfn: (previousValue: U, currentValue: T, currentIndex: number, array: T[]) =&gt; U, initialValue: U) =&gt; U | Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as an argument in the next call to the callback function.                      |
| **reduceRight**    | (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array: T[]) =&gt; T) =&gt; T                           | Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result, and is provided as an argument in the next call to the callback function. |
| **reduceRight**    | (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array: T[]) =&gt; T, initialValue: T) =&gt; T          |                                                                                                                                                                                                                                             |
| **reduceRight**    | &lt;U&gt;(callbackfn: (previousValue: U, currentValue: T, currentIndex: number, array: T[]) =&gt; U, initialValue: U) =&gt; U | Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result, and is provided as an argument in the next call to the callback function. |


#### ConcatArray

| Prop         | Type                |
| ------------ | ------------------- |
| **`length`** | <code>number</code> |

| Method    | Signature                                                          |
| --------- | ------------------------------------------------------------------ |
| **join**  | (separator?: string \| undefined) =&gt; string                     |
| **slice** | (start?: number \| undefined, end?: number \| undefined) =&gt; T[] |

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