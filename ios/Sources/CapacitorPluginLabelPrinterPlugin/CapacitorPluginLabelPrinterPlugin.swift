import Foundation
import Capacitor
import UIKit
#if canImport(BRLMPrinterKit)
import BRLMPrinterKit
#endif

#if canImport(BRPtouchPrinterKit)
import BRPtouchPrinterKit
#endif


@objc(CapacitorPluginLabelPrinterPlugin)
public class CapacitorPluginLabelPrinterPlugin: CAPPlugin {
  
    @objc func discoverBrotherPrinters(_ call: CAPPluginCall) {
        let searchOption = BRLMNetworkSearchOption()
        let search = BRLMPrinterDriverGenerator.search(with: searchOption)
        search.start { (result) in
            if result.error.code != .noError {
                call.reject("Failed to discover printers: \(result.error.localizedDescription)")
                return
            }

            let printers = result.printerList.map { printer in
                return [
                    "modelName": printer.modelName,
                    "ipAddress": printer.ipAddress
                ]
            }

            call.resolve(["printers": printers])
        }
    }
    
    @objc func printToBrotherPrinter(_ call: CAPPluginCall) {
        guard let printerURL = call.getString("printerURL"),
              let imageSource = call.getString("imageSource"),
              let labelSize = call.getString("labelSize") else {
            call.reject("Missing printer URL, image source, or label size")
            return
        }

        let rotate = call.getBool("rotate", false)
        let autoCut = call.getBool("autoCut", true)
        let numCopies = call.getInt("numCopies", 1)

        self.loadImage(from: imageSource) { image in
            guard let image = image else {
                call.reject("Failed to load image")
                return
            }

            var processedImage = image
            
            if rotate {
                processedImage = self.rotateImage(processedImage)
            }

          guard let url = URL(string: printerURL), let channel = BRLMChannel(wifiIPAddress: url.host!) else {
                call.reject("Invalid printer URL")
                return
            }

            guard let printer = BRLMPrinterDriverGenerator.open(channel) else {
                call.reject("Failed to connect to printer")
                return
            }

            let settings = BRLMQLPrintSettings()
            settings.labelSize = self.getBrotherLabelSize(for: labelSize)
            settings.autoCut = autoCut
            settings.numCopies = UInt(numCopies)
            
            guard let printData = processedImage.cgImage else {
                call.reject("Failed to create print data")
                printer.closeConnection()
                return
            }

            let result = printer.printImage(printData, settings: settings)
            if result.error.code != .noError {
                call.reject("Printing failed: \(result.error.localizedDescription)")
                printer.closeConnection()
                return
            }

            call.resolve(["success": true])
            printer.closeConnection()
        }
    }
    
    private func getBrotherLabelSize(for labelSize: String) -> BRLMQLPrintSettingsLabelSize {
        switch labelSize {
        case "62x100mm":
          return .dieCutW62H100
        case "29x62mm":
          return .dieCutW62H29
        default:
            return .dieCutW62H100 // Default size
        }
    }
    
    private func loadImage(from source: String, completion: @escaping (UIImage?) -> Void) {
        if source.hasPrefix("http://") || source.hasPrefix("https://") {
            guard let url = URL(string: source) else {
                completion(nil)
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }.resume()
        } else if let data = Data(base64Encoded: source), let image = UIImage(data: data) {
            completion(image)
        } else {
            completion(nil)
        }
    }

    private func rotateImage(_ image: UIImage) -> UIImage {
        let rotatedSize = CGSize(width: image.size.height, height: image.size.width)
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: .pi / 2)
        image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}
