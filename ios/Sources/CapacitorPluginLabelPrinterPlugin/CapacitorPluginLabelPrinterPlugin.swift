import Foundation
import Capacitor
import BRLMPrinterKit

@objc(CapacitorPluginLabelPrinterPlugin)
public class CapacitorPluginLabelPrinterPlugin: CAPPlugin {
    

      
    private var netPrinterSearcher: NetPrinterSearcher?
    private var printImageFacade: PrintImageFacade?

    // ... existing methods ...

    @objc func getBrotherPrinters(_ call: CAPPluginCall) {
        var hasResponded = false
        netPrinterSearcher = NetPrinterSearcher()
        netPrinterSearcher?.start { [weak self] (error, printers) in
            guard let self = self, !hasResponded else { return }
            hasResponded = true
            
            if let error = error {
                call.reject("Printer search failed: \(error)")
            } else if let printers = printers {
                let printerInfoArray = printers.compactMap { printer -> [String: String]? in
                    guard let wifiPrinter = printer as? WiFiPrinterInfo else { return nil }
                    return [
                        "modelName": wifiPrinter.modelName,
                        "ipAddress": wifiPrinter.ipv4Address,
                        "printerModel": wifiPrinter.fetchPrinterModel()?.rawValue ?? "Unknown"
                    ]
                }
                call.resolve(["printers": printerInfoArray])
            } else {
                call.resolve(["printers": []])
            }
            
            // Cancel the search after responding
            self.netPrinterSearcher?.cancel()
            self.netPrinterSearcher = nil
        }
    }

    @objc func cancelPrinterSearch(_ call: CAPPluginCall) {
        netPrinterSearcher?.cancel()
        call.resolve()
    }
    

    @objc func printLabel(_ call: CAPPluginCall) {
        guard let ipAddress = call.getString("ipAddress"),
              let imageUrlString = call.getString("imageUrl") else {
            call.reject("Missing required parameters")
            return
        }

        print("ipAddress: \(ipAddress)")
        print("imageUrlString: \(imageUrlString)")

        guard let imageUrl = URL(string: imageUrlString) else {
            call.reject("Invalid image URL")
            return
        }

        print("imageUrl: \(imageUrl)")

        // Create printer info
        let printerInfo = WiFiPrinterInfo()
        printerInfo.ipv4Address = ipAddress

        // Create print settings
        guard let printSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_810W) else {
            call.reject("Failed to create print settings")
            return
        }

        printSettings.labelSize = .rollW62RB
        printSettings.autoCut = true

        // Initialize PrintImageFacade if not already done
        if printImageFacade == nil {
            printImageFacade = PrintImageFacade()
        }

        // Print the image
        let result = printImageFacade?.printImageWithURL(info: printerInfo, url: imageUrl, settings: printSettings)

        if let errorMessage = result, !errorMessage.isEmpty {
            call.reject("Print failed: \(errorMessage)")
        } else {
            call.resolve(["success": true])
        }
    }

    @objc func cancelPrinting(_ call: CAPPluginCall) {
        printImageFacade?.cancelPrinting()
        call.resolve()
    }
    
    @objc func getPrinterStatus(_ call: CAPPluginCall) {
        guard let ipAddress = call.getString("ipAddress") else {
            call.reject("Missing IP address")
            return
        }

        let printerInfo = WiFiPrinterInfo()
        printerInfo.ipv4Address = ipAddress

        PrinterInfoFacade().fetchStatus(printerInfo: printerInfo) { statusString in
            DispatchQueue.main.async {
                call.resolve(["status": statusString])
            }
        }
    }
    
    
}
