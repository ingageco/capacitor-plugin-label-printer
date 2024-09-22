//
//  PrinterModelListViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import BRLMPrinterKit
import BRLMPrinterKit.BRLMPrinterModelSpec
import Foundation

class PrinterModelListViewModel: ObservableObject {
    var type: ModelListType = .spec
    @Published var printerModelList: [String] = PrinterModel.allCases.map({ $0.rawValue }).sorted()

    func fetchModelSpec(modelName: String) -> String {
        guard let printerModel = PrinterModel(modelName: modelName) else { return "" }
        let modelSpec = BRLMPrinterModelSpec(printerModel: printerModel.printerModel)
        return NSLocalizedString("spec_xdpi", comment: "") + ": \(modelSpec.xdpi)" + "\n" +
        NSLocalizedString("spec_ydpi", comment: "") + ": \(modelSpec.ydpi)"
    }
}
