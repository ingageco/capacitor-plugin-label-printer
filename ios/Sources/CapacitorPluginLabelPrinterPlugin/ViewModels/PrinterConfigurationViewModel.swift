//
//  PrinterConfigurationViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import Foundation

class PrinterConfigurationViewModel: ObservableObject {
    @Published var printerInfo: IPrinterInfo?
    @Published var itemList: [PrinterSettingItem] = PrinterSettingItem.allCases()
    @Published var configurationSetList: [ConfigurationItemData] = []
    private let printerConfigurationFacade = PrinterConfigurationFacade()

    func fetchPrinterConfigurations(callback: @escaping(String) -> Void ) {
        guard let info = printerInfo else {
            callback(NSLocalizedString("no_select_printer", comment: ""))
            return
        }
        printerConfigurationFacade.fetchPrinterConfiguration(
            printerInfo: info,
            keys: configurationSetList.map({ $0.settingItem }),
            callback: { errorCode, dic in
                var result = errorCode + "\n"
                dic.forEach({ value in
                    let item = PrinterSettingItem.allCases().first(where: { $0.rawValue == value.key })
                    let itemValueList = item?.valueList
                    let itemValue = itemValueList?.isEmpty ?? true ? value.value :
                    itemValueList?.first(where: { $0.itemKey.description == value.value })?.itemValue ?? ""
                    result += (item?.name ?? "") + ": " + itemValue + "\n"
                })
                callback(result)
            }
        )
    }

    func setPrinterConfigurations(callback: @escaping(String) -> Void) {
        guard let info = printerInfo else {
            callback(NSLocalizedString("no_select_printer", comment: ""))
            return
        }
        var dic = [UInt: String]()
        configurationSetList.forEach({ item in
            if let value = item.settingItem.valueList.isEmpty ? item.value : item.settingItem.valueList.first(where: {
                $0.itemValue == item.value
            })?.itemKey.description {
                dic[item.settingItem.rawValue] = value
            }
        })
        printerConfigurationFacade.setPrinterConfiguration(
            printerInfo: info,
            settings: dic,
            callback: { result in
                callback(result)
            })
    }

    func setItemData(key: PrinterSettingItem, value: String) {
        var tempList: [ConfigurationItemData] = []
        tempList.append(contentsOf: configurationSetList)
        guard let index = tempList.firstIndex(where: { $0.settingItem == key }) else { return }
        tempList.remove(at: index)
        tempList.insert(ConfigurationItemData(settingItem: key, value: value), at: index)
        configurationSetList = []
        configurationSetList.append(contentsOf: tempList)
    }
}

class ConfigurationItemData: Hashable {
    static func == (lhs: ConfigurationItemData, rhs: ConfigurationItemData) -> Bool {
        return lhs.settingItem == rhs.settingItem && lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(settingItem)
        hasher.combine(value)
    }

    init(settingItem: PrinterSettingItem, value: String) {
        self.settingItem = settingItem
        self.value = value
    }

    var settingItem: PrinterSettingItem
    var value: String
}

struct ConfigurationSettingData {
    var itemKey: Int
    var itemValue: String
}
