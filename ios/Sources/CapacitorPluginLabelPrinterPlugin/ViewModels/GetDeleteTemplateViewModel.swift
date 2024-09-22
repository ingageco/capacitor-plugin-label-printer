//
//  GetDeleteTemplateViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import BRLMPrinterKit
import Foundation

class GetDeleteTemplateViewModel: ObservableObject {
    @Published var printerInfo: IPrinterInfo?
    @Published var keyList: [Int] = []
    private let manageTemplatesFacade = TemplateManageFacade()
    
    func fetchTemplateList() -> (message: String, list: [BRLMPtouchTemplateInfo]) {
        guard let info = printerInfo else {
            return (NSLocalizedString("no_select_printer", comment: ""), [])
        }
        return manageTemplatesFacade.fetchTemplateList(printerInfo: info)
    }

    func deleteTemplateList(callback: @escaping (String) -> Void) {
        guard let info = printerInfo else {
            callback(NSLocalizedString("no_select_printer", comment: ""))
            return
        }
        manageTemplatesFacade.deleteTemplateList(printerInfo: info, keyList: keyList, callback: callback)
    }

    func setKeyList(number: String) -> Bool {
        keyList = []
        var result = true
        number.components(separatedBy: ";").forEach({ key in
            if let key = Int(key) {
                keyList.append(key)
            } else {
                result = false
            }
        })
        return result
    }
}
