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
              let imageUrlString = call.getString("imageUrl"),
              let labelSizeString = call.getString("labelSize"),
              let autoCut = call.getBool("autoCut") else {
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

        // Set label size
        if let labelSize = getLabelSize(from: labelSizeString) {
            printSettings.labelSize = labelSize
        } else {
            call.reject("Invalid label size")
            return
        }

        printSettings.autoCut = autoCut

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
    
    @objc func printLabels(_ call: CAPPluginCall) {
        guard let ipAddress = call.getString("ipAddress"),
              let imageUrlStrings = call.getArray("imageUrls", String.self),
              let labelSizeString = call.getString("labelSize"),
              let autoCut = call.getBool("autoCut") else {
            call.reject("Missing required parameters")
            return
        }

        print("ipAddress: \(ipAddress)")
        print("imageUrlStrings: \(imageUrlStrings)")

        let imageUrls = imageUrlStrings.compactMap { URL(string: $0) }
        
        if imageUrls.count != imageUrlStrings.count {
            call.reject("One or more invalid image URLs")
            return
        }

        print("imageUrls: \(imageUrls)")

        // Create printer info
        let printerInfo = WiFiPrinterInfo()
        printerInfo.ipv4Address = ipAddress

        // Create print settings
        guard let printSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_810W) else {
            call.reject("Failed to create print settings")
            return
        }

        // Set label size
        if let labelSize = getLabelSize(from: labelSizeString) {
            printSettings.labelSize = labelSize
        } else {
            call.reject("Invalid label size")
            return
        }

        printSettings.autoCut = autoCut

        // Initialize PrintImageFacade if not already done
        if printImageFacade == nil {
            printImageFacade = PrintImageFacade()
        }

        // Print the images
        let result = printImageFacade?.printImageWithURLs(info: printerInfo, urls: imageUrls, settings: printSettings)

        if let errorMessage = result, !errorMessage.isEmpty {
            call.reject("Print failed: \(errorMessage)")
        } else {
            call.resolve(["success": true])
        }
    }

    private func getLabelSize(from string: String) -> BRLMQLPrintSettingsLabelSize? {
        switch string {
        case "rollW62":
            return .rollW62
        case "rollW29":
            return .rollW29
        // Add more cases as needed
        default:
            return nil
        }
    }


}
