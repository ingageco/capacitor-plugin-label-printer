//
//  PrinterListViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import BRLMPrinterKit
import Foundation

class PrinterListViewModel: NSObject, ObservableObject {
    @Published var channelType: BRLMChannelType?
    @Published var isSearching: Bool = false
    @Published var itemList: [PrinterItemData] = []
    private var printerInfoList: [IPrinterInfo] = []
    var typeName = ""
    var delegate: PrinterInfoSaveDelegate?
    var printerSearcher: IPrinterSearcher?

    func setChannelType(type: InterfaceType) {
        self.typeName = type.name
        switch type {
        case .network:
            channelType = BRLMChannelType.wiFi
        case .bluetooth:
            channelType = BRLMChannelType.bluetoothMFi
        case .ble:
            channelType = BRLMChannelType.bluetoothLowEnergy
        }
    }

    // Start searching for printers
    func startSearch(callback: @escaping(String) -> Void) {
        printerInfoList = []
        self.refreshPrinterItemList()
        isSearching = true
        let searcher = fetchPrinterSearcher()
        searcher?.start(callback: { error, list in
            if let list = list {
                self.printerInfoList.append(contentsOf: list)
                self.refreshPrinterItemList()
            }
            if let error = error {
                self.isSearching = false
                callback(error)
            }
        })
    }

    // Stop searching for printers
    func stopSearch() {
        isSearching = false
        printerSearcher?.cancel()
    }

    private func fetchPrinterSearcher() -> IPrinterSearcher? {
        guard printerSearcher == nil else { return printerSearcher }
        var target: IPrinterSearcher?
        if let channelType = channelType {
            switch channelType {
            case .bluetoothMFi: target = BluetoothPrinterSearcher()
            case .wiFi: target = NetPrinterSearcher()
            case .bluetoothLowEnergy: target = BLEPrinterSearcher()
            @unknown default:
                break
            }
            printerSearcher = target
        }
        return target
    }

    func refreshPrinterItemList() {
        guard let printerType = channelType else { return }
        itemList = printerInfoList.map({
            switch printerType {
            case .bluetoothMFi:
                return PrinterItemData(
                    printerName: $0.modelName,
                    model: $0.fetchPrinterModel() ?? PrinterModel.defaultPrinter,
                    value: ($0 as? BluetoothPrinterInfo)?.serialNum ?? ""
                )
            case .wiFi:
                return PrinterItemData(
                    printerName: $0.modelName,
                    model: $0.fetchPrinterModel() ?? PrinterModel.defaultPrinter,
                    value: ($0 as? WiFiPrinterInfo)?.ipv4Address ?? ""
                )
            case .bluetoothLowEnergy:
                return PrinterItemData(
                    printerName: $0.modelName,
                    model: $0.fetchPrinterModel() ?? PrinterModel.defaultPrinter,
                    value: ""
                )
            @unknown default:
                return PrinterItemData(
                    printerName: $0.modelName,
                    model: $0.fetchPrinterModel() ?? PrinterModel.defaultPrinter,
                    value: ""
                )
            }
        })
    }
    
    func infoForPrinterItemData(item: PrinterItemData) -> IPrinterInfo? {
        return printerInfoList.first(where: {
            if channelType == .wiFi {
                return $0.fetchPrinterModel() == item.model && ($0 as? WiFiPrinterInfo)?.ipv4Address == item.value
            } else if channelType == .bluetoothMFi {
                return $0.fetchPrinterModel() == item.model && ($0 as? BluetoothPrinterInfo)?.serialNum == item.value
            } else {
                return $0.fetchPrinterModel() == item.model
            }
        })
    }

    func savePrinterInfo(info: IPrinterInfo?) {
        delegate?.savePrinterInfo(info: info)
    }
}

struct PrinterItemData: Hashable {
    var printerName: String
    var model: PrinterModel
    var value: String
}

protocol PrinterInfoSaveDelegate {
    func savePrinterInfo(info: IPrinterInfo?)
}

extension BRLMPrinterSearchErrorCode {
    var name: String {
        switch self {
        case .noError:
            return "noError"
        case .canceled:
            return "canceled"
        case .alreadySearching:
            return "alreadySearching"
        case .unsupported:
            return "unsupported"
        case .unknownError:
            return "unknownError"
        @unknown default:
            return "unknownError"
        }
    }
}
