//
//  GetDeleteTemplate.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/28.
//

import BRLMPrinterKit
import Foundation

class TemplateManageFacade {

    // Get TemplateList Form Printer
    func fetchTemplateList(printerInfo: IPrinterInfo) -> (message: String, list: [BRLMPtouchTemplateInfo]) {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: printerInfo) else {
            return (message: NSLocalizedString("create_channel_error", comment: ""), list: [])
        }
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            return (message: OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code), list: [])
        }
        guard let  driver = generateResult.driver else {
            return (message: NSLocalizedString("unknown_error", comment: ""), list: [])
        }
        let result = driver.requestTemplateInfoList()
        if let templateList = result.printerInfo as? [BRLMPtouchTemplateInfo] {
            driver.closeChannel()
            return (message: "\(RequestPrinterInfoErrorModel.fetchGetPrinterInfoErrorCode(error: result.error.code))", list: templateList)
        }
        driver.closeChannel()
        return (message: "\(RequestPrinterInfoErrorModel.fetchGetPrinterInfoErrorCode(error: result.error.code))", list: [])
    }

    // Delete Templates
    func deleteTemplateList(printerInfo: IPrinterInfo, keyList: [Int], callback: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            let printer = PrinterConnectUtil().fetchPrinter(printerInfo: printerInfo)
            let startResult = printer?.startCommunication() ?? false
            if !startResult {
                DispatchQueue.main.async {
                    callback(PrintErrorModel.fetchErrorCode(errorCode: ERROR_COMMUNICATION_ERROR_))
                }
                return
            }
            let result = printer?.removeTemplate(keyList as [NSNumber])
            printer?.endCommunication()
            DispatchQueue.main.async {
                callback(
                    result == RET_TRUE ? "RET_TRUE" : "RET_FALSE"
                )
            }
        }
    }
}
