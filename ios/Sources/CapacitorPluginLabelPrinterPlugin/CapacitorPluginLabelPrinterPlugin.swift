import Foundation
import Capacitor
import UIKit

import BRLMPrinterKit

@objc(CapacitorPluginLabelPrinterPlugin)
public class CapacitorPluginLabelPrinterPlugin: CAPPlugin {
    
    @objc func getLabelPrinters(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
            
            printerPicker.present(animated: true) { (printerPicker, userDidSelect, error) in
                if let error = error {
                    call.reject("Error presenting printer picker: \(error.localizedDescription)")
                    return
                }
                
                if userDidSelect {
                    if let selectedPrinter = printerPicker.selectedPrinter {
                        if self.isLabelPrinter(selectedPrinter) {
                            let printerInfo: [String: String] = [
                                "name": selectedPrinter.displayName,
                                "url": selectedPrinter.url.absoluteString,
                                "make": self.getPrinterMake(selectedPrinter)
                            ]
                            call.resolve(["selectedPrinter": printerInfo])
                        } else {
                            call.reject("Selected printer is not a Dymo or Brother label printer")
                        }
                    } else {
                        call.reject("No printer selected")
                    }
                } else {
                    call.reject("User cancelled printer selection")
                }
            }
        }
    }
    
    private func isLabelPrinter(_ printer: UIPrinter) -> Bool {
        let make = getPrinterMake(printer)
        return make == "Dymo" || make == "Brother"
    }
    
    private func getPrinterMake(_ printer: UIPrinter) -> String {
        let name = printer.displayName.lowercased()
        if name.contains("dymo") {
            return "Dymo"
        } else if name.contains("brother") {
            return "Brother"
        } else {
            return "Unknown"
        }
    }
}
