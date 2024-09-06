package com.ingageco.capacitorpluginlabelprinter;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "CapacitorPluginLabelPrinter")
public class CapacitorPluginLabelPrinterPlugin extends Plugin {

    private CapacitorPluginLabelPrinter implementation = new CapacitorPluginLabelPrinter();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }
}
