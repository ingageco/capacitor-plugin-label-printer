import Foundation
import Capacitor
import BRLMPrinterKit

@objc(CapacitorPluginLabelPrinterPlugin)
public class CapacitorPluginLabelPrinterPlugin: CAPPlugin {
    

      
    private var netPrinterSearcher: NetPrinterSearcher?

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
    
   @objc func getPrinters(_ call: CAPPluginCall) {
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
                            let ipAddress = self.extractIPAddress(from: selectedPrinter.url)
                            let printerInfo: [String: String] = [
                                "name": selectedPrinter.displayName,
                                "url": selectedPrinter.url.absoluteString,
                                "make": self.getPrinterMake(selectedPrinter),
                                "ipAddress": ipAddress ?? "Unknown"
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

    @objc func printLabel(_ call: CAPPluginCall) {
        guard let ipAddress = call.getString("ipAddress"),
              let imageUrlString = call.getString("imageUrl") else {
            call.reject("Missing required parameters")
            return
        }

        guard let imageUrl = URL(string: imageUrlString) else {
            call.reject("Invalid image URL")
            return
        }

        // Create a channel
        let channel = BRLMChannel(wifiIPAddress: ipAddress)

        let generateResult = BRLMPrinterDriverGenerator.open(channel)

        guard let printerDriver = generateResult.driver else {
            call.reject("Failed to connect to printer: \(generateResult.error.description)")
            return
        }

        // Create print settings
        guard let printSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_810W) else {
            call.reject("Failed to create print settings")
            return
        }

        printSettings.labelSize = .dieCutW62H100
        printSettings.autoCut = true

        // Print the image
        let printError = printerDriver.printImage(with: imageUrl, settings: printSettings)

        if printError.code != .noError {
            call.reject("Print failed: \(printError.description)")
        } else {
            call.resolve(["success": true])
        }

        printerDriver.closeChannel()
    }
 
    private func createLabelWithText(_ text: String) -> Data {
        // This is a very basic example. You might need to create more complex labels
        // depending on your requirements and the capabilities of the Brother SDK.
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.text = text
        label.textAlignment = .center
        label.backgroundColor = .white

        UIGraphicsBeginImageContext(label.bounds.size)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image?.pngData() ?? Data()
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

    private func extractIPAddress(from url: URL) -> String? {
        // Check if the host component is an IP address
        if let host = url.host, host.contains(".") {
            let components = host.components(separatedBy: ".")
            if components.count == 4, components.allSatisfy({ Int($0) != nil }) {
                return host
            }
        }
        
        // If not found in host, check the path components
        let pathComponents = url.pathComponents
        for component in pathComponents {
            let parts = component.components(separatedBy: ".")
            if parts.count == 4, parts.allSatisfy({ Int($0) != nil }) {
                return component
            }
        }
        
        return nil
    }


    
}
