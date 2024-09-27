//
//  PrintImageFacade.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/8.
//

import BRLMPrinterKit
import Foundation

class PrintImageFacade {

    private var cancelRoutine: (() -> Void)?

    // print image with CGImage
    func printImageWithImage(info: IPrinterInfo, image: CGImage?, settings: BRLMPrintSettingsProtocol?) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let printSettings = settings, let image = image else {
            return NSLocalizedString("no_print_data", comment: "")
        }
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        let printError = driver?.printImage(with: image, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print image with URL
    func printImageWithURL(info: IPrinterInfo, url: URL?, settings: BRLMPrintSettingsProtocol?) -> String {
        print("Received URL: \(url?.absoluteString ?? "nil")")
        
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        
        guard let printSettings = settings else {
            return NSLocalizedString("no_print_settings", comment: "")
        }
        
        guard let url = url else {
            return NSLocalizedString("no_image_url", comment: "")
        }
        
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        
        print("Attempting to print image from URL: \(url.absoluteString)")
        
        var imageData: Data
        do {
            let (data, response) = try URLSession.shared.syncFetch(from: url)
            guard let mimeType = response.mimeType, mimeType.hasPrefix("image") else {
                print("Invalid MIME type: \(response.mimeType ?? "unknown")")
                return NSLocalizedString("invalid_image_mime_type", comment: "")
            }
            imageData = data
            print("Successfully fetched image data")
        } catch {
            print("Error fetching image data: \(error.localizedDescription)")
            return NSLocalizedString("failed_to_fetch_image_data", comment: "")
        }
        
        // Create a UIImage from the data
        guard let image = UIImage(data: imageData) else {
            print("Failed to create UIImage from data")
            return NSLocalizedString("failed_to_create_image", comment: "")
        }
        
        print("Successfully created UIImage")
        
        // Print the image
        let printError = driver?.printImage(with: image.cgImage!, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
        
        if let error = printError {
            print("Print Error: \(error.code), \(error.allLogs)")
        }
        
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print image with URLs
    func printImageWithURLs(info: IPrinterInfo, urls: [URL]?, settings: BRLMPrintSettingsProtocol?) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let printSettings = settings, let urls = urls else {
            return NSLocalizedString("no_print_data", comment: "")
        }
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        
        var images: [CGImage] = []
        
        for url in urls {
            print("Processing URL: \(url.absoluteString)")
            
            var imageData: Data
            do {
                let (data, response) = try URLSession.shared.syncFetch(from: url)
                guard let mimeType = response.mimeType, mimeType.hasPrefix("image") else {
                    print("Invalid MIME type: \(response.mimeType ?? "unknown")")
                    continue // Skip this URL and move to the next one
                }
                imageData = data
                print("Successfully fetched image data")
            } catch {
                print("Error fetching image data: \(error.localizedDescription)")
                continue // Skip this URL and move to the next one
            }
            
            // Create a UIImage from the data
            guard let image = UIImage(data: imageData), let cgImage = image.cgImage else {
                print("Failed to create UIImage from data")
                continue // Skip this URL and move to the next one
            }
            
            print("Successfully created UIImage")
            images.append(cgImage)
        }
        
        if images.isEmpty {
            return NSLocalizedString("no_valid_images", comment: "")
        }
        
        // Print the images
        var printError: BRLMPrintError?
        for cgImage in images {
            let error = driver?.printImage(with: cgImage, settings: printSettings)
            if let error = error {
                printError = error
                // break // Stop printing if there's an error
            }
        }
        
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print PRN with URL
    func printPRNWithURL(info: IPrinterInfo, url: URL?) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let url = url else {
            return NSLocalizedString("no_print_data", comment: "")
        }
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        let printError = driver?.sendPRNFile(with: url)
        
        // wait for completion of transfer
        driver?.getPrinterStatus()
        
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print PRN with URLs
    func printPRNWithURLs(info: IPrinterInfo, urls: [URL]?) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let urls = urls else {
            return NSLocalizedString("no_print_data", comment: "")
        }
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        let printError = driver?.sendPRNFile(with: urls)
        
        // wait for completion of transfer
        driver?.getPrinterStatus()
        
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // print PRN with Data
    func printPRNWithData(info: IPrinterInfo, data: Data?) -> String {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let data = data else {
            return NSLocalizedString("no_print_data", comment: "")
        }
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
        }
        let driver = generateResult.driver
        cancelRoutine = {
            driver?.cancelPrinting()
        }
        let printError = driver?.sendRawData(data)
        driver?.closeChannel()
        cancelRoutine = nil
        return PrintErrorModel.fetchPrintErrorCode(error: printError?.code) + "\n\n" +
        (printError?.allLogs.map({ $0.errorDescription }).joined(separator: "\n") ?? "")
    }

    // cancel Communication
    func cancelPrinting() {
        DispatchQueue.global().async {
            if let cancelRoutine = self.cancelRoutine {
                cancelRoutine()
            }
            self.cancelRoutine = nil
        }
    }
}

extension URLSession {
    func syncFetch(from url: URL) throws -> (Data, URLResponse) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = self.dataTask(with: url) { (d, r, e) in
            data = d
            response = r
            error = e
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        if let error = error {
            throw error
        }
        
        return (data!, response!)
    }
}
