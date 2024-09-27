#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(CapacitorPluginLabelPrinterPlugin, "CapacitorPluginLabelPrinter",
    CAP_PLUGIN_METHOD(getBrotherPrinters, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(cancelPrinterSearch, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(getPrinterStatus, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(printLabel, CAPPluginReturnPromise);
    CAP_PLUGIN_METHOD(printLabels, CAPPluginReturnPromise);
           );
