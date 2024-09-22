//
//  PrinterInfo.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/20.
//

import BRLMPrinterKit
import Foundation

protocol IPrinterInfo: AnyObject {
    var channelType: BRLMChannelType { get set }
    var modelName: String { get set }
    var determinedModel: PrinterModel? { get set }

    func fetchPrinterModel() -> PrinterModel?
    func getListOfWhatPrinterModel() -> [PrinterModel]
}

extension IPrinterInfo {
    func fetchPrinterModel() -> PrinterModel? {
        return determinedModel ?? guessPrinterModels(modelName: modelName).first
    }
    
    func getListOfWhatPrinterModel() -> [PrinterModel] {
        return guessPrinterModels(modelName: modelName)
    }
    
    func guessPrinterModels(modelName: String) -> [PrinterModel] {
        var model: PrinterModel?
        let seriesModelAndResolution: Int = 2
        let separator: String = "_"
        PrinterModel.allCases.forEach {
            if $0.rawValue.components(separatedBy: separator).count == seriesModelAndResolution { // TD-2350D_203など
                return
            }
            if modelName.lowercased().contains($0.rawValue.lowercased()) {
                if $0.rawValue.count >= (model?.rawValue.count ?? 0) {
                    model = $0
                }
            }
        }
        if let model = model {
            return [model]
        }
        
        var models: [PrinterModel] = Array()
        PrinterModel.allCases.forEach {
            var contains = $0.rawValue.components(separatedBy: separator)
            if contains.count == seriesModelAndResolution { // TD-2350D_203など
                _ = contains.popLast()
                if modelName.lowercased().contains(contains.joined(separator: separator).lowercased()) {
                    models.append($0)
                }
            }
        }
        
        return models
    }
}


class WiFiPrinterInfo: IPrinterInfo {
    var channelType: BRLMChannelType = BRLMChannelType.wiFi
    var modelName: String = ""
    var ipv4Address: String = ""
    var determinedModel: PrinterModel?
}

class BluetoothPrinterInfo: IPrinterInfo {
    var channelType: BRLMChannelType = BRLMChannelType.bluetoothMFi
    var modelName: String = ""
    var serialNum: String = ""
    var determinedModel: PrinterModel?
}

class BLEPrinterInfo: IPrinterInfo {
    var channelType: BRLMChannelType = BRLMChannelType.bluetoothLowEnergy
    var modelName: String = ""
    var determinedModel: PrinterModel?
}
