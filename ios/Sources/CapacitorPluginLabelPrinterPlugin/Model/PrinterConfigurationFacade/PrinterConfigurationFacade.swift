//
//  PrinterConfigurationFacade.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/1.
//

import BRLMPrinterKit
import Foundation

class PrinterConfigurationFacade {

    // Get printer configurations
    func fetchPrinterConfiguration(
        printerInfo: IPrinterInfo,
        keys: [PrinterSettingItem],
        callback: @escaping(String, Dictionary<UInt, String>) -> Void
    ) {
        DispatchQueue.global().async {
            guard let printer = PrinterConnectUtil().fetchPrinter(printerInfo: printerInfo) else {
                DispatchQueue.main.async {
                    callback(PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_), Dictionary())
                }
                return
            }
            let startResult = printer.startCommunication()
            if !startResult {
                DispatchQueue.main.async {
                    callback(PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_), Dictionary())
                }
                return
            }
            var configurationDic: NSDictionary?
            let result = printer.getSettings(&configurationDic, require: keys.map({ $0.rawValue }))
            printer.endCommunication()
            DispatchQueue.main.async {
                callback(
                    PrintErrorModel.fetchErrorCode(errorCode: result),
                    configurationDic as? [UInt: String] ?? Dictionary()
                )
            }
        }
    }

    // Set printer configurations
    func setPrinterConfiguration(
        printerInfo: IPrinterInfo,
        settings: [UInt: String],
        callback: @escaping(String) -> Void
    ) {
        DispatchQueue.global().async {
            guard let printer = PrinterConnectUtil().fetchPrinter(printerInfo: printerInfo) else {
                DispatchQueue.main.async {
                    callback(PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_))
                }
                return
            }
            let startResult = printer.startCommunication()
            if !startResult {
                DispatchQueue.main.async {
                    callback(PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_))
                }
                return
            }
            let result = printer.setPrinterSettings(settings)
            printer.endCommunication()
            DispatchQueue.main.async {
                callback(
                    PrintErrorModel.fetchErrorCode(errorCode: result)
                )
            }
        }
    }
}
