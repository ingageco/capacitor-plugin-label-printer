//
//  BluetoothPrinterSearcher.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/3/13.
//

import BRLMPrinterKit
import Foundation

class BluetoothPrinterSearcher: IPrinterSearcher {
    func start(callback: @escaping (String?, [IPrinterInfo]?) -> Void) {
        DispatchQueue.global().async {
            let searcher = BRLMPrinterSearcher.startBluetoothSearch()
            let list = searcher.channels.map({
                let info = BluetoothPrinterInfo()
                info.modelName = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeyModelName) as? String ?? ""
                info.serialNum = $0.extraInfo?.value(forKey: BRLMChannelExtraInfoKeySerialNumber) as? String ?? ""
                return info
            })
            DispatchQueue.main.async {
                callback(searcher.error.code.name, list)
            }
        }
    }

    func cancel() {
        // ignore
    }
}
