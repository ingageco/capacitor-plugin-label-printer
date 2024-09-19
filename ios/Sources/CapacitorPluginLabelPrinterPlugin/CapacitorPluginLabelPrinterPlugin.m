#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(CapacitorPluginLabelPrinterPlugin, "CapacitorPluginLabelPrinter",
    CAP_PLUGIN_METHOD(getLabelPrinters, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(printToBrotherPrinter, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(getPrinterInfo, CAPPluginReturnPromise);
)