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
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: info) else {
            return NSLocalizedString("create_channel_error", comment: "")
        }
        guard let printSettings = settings, let url = url else {
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
        let printError = driver?.printImage(with: url, settings: printSettings)
        driver?.closeChannel()
        cancelRoutine = nil
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
        let printError = driver?.printImage(with: urls, settings: printSettings)
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
