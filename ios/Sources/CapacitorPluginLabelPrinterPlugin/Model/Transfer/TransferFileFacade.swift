//
//  TransferFileFacade.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/22.
//

import BRLMPrinterKit
import Foundation

class TransferFileFacade {

    func startTransferFile(info: IPrinterInfo, type: TransferFileType, filePath: String, callback: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            var result = ""
            switch type {
            case .FIRM:
                result = self.transferFirmFile(filePath: filePath, info: info)
            case .TEMPLATE:
                result = self.transferTemplateFile(filePath: filePath, info: info)
            case .DATABASE:
                result = self.transferDatabaseFile(filePath: filePath, info: info)
            case .FILE:
                result = self.transferBinaryFile(filePath: filePath, info: info)
            }
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }

    private func transferFirmFile(filePath: String, info: IPrinterInfo) -> String {
        let printer = PrinterConnectUtil().fetchPrinter(printerInfo: info)
        let startResult = printer?.startCommunication() ?? false
        if !startResult {
            return PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_)
        }
        let result = printer?.sendFirmwareFile([filePath])
        printer?.endCommunication()
        return "\(String(describing: result))"
    }

    private func transferTemplateFile(filePath: String, info: IPrinterInfo) -> String {
        let printer = PrinterConnectUtil().fetchPrinter(printerInfo: info)
        let startResult = printer?.startCommunication() ?? false
        if !startResult {
            return PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_)
        }
        let result = printer?.sendTemplateFile([filePath])
        printer?.endCommunication()
        return "\(String(describing: result))"
    }

    private func transferDatabaseFile(filePath: String, info: IPrinterInfo) -> String {
        let printer = PrinterConnectUtil().fetchPrinter(printerInfo: info)
        let startResult = printer?.startCommunication() ?? false
        if !startResult {
            return PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_)
        }
        let result = printer?.sendDatabase(filePath)
        
        // wait for completion of transfer
        var status: BRPtouchPrinterStatus?
        printer?.getStatus(&status)
        
        printer?.endCommunication()
        return PrintErrorModel.fetchErrorCode(errorCode: result)
    }

    private func transferBinaryFile(filePath: String, info: IPrinterInfo) -> String {
        let printer = PrinterConnectUtil().fetchPrinter(printerInfo: info)
        let startResult = printer?.startCommunication() ?? false
        if !startResult {
            return PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_)
        }
        let result = printer?.sendFile(filePath)
        
        // wait for completion of transfer
        var status: BRPtouchPrinterStatus?
        printer?.getStatus(&status)
        
        printer?.endCommunication()
        return PrintErrorModel.fetchErrorCode(errorCode: result)
    }
}
