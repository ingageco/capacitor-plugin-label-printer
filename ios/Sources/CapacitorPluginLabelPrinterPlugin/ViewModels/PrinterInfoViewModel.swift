//
//  PrinterInfoViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import Foundation
import UIKit

class PrinterInfoViewModel: ObservableObject {
    @Published var printerInfo: IPrinterInfo?
    private let printerInfoFacade = PrinterInfoFacade()

    func fetchMainFirmVersion() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchMainFirmVersion(printerInfo: info)
    }

    func fetchSerial() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchSerial(printerInfo: info)
    }

    func fetchStatus(callback: @escaping(String) -> Void) {
        guard let info = printerInfo else {
            callback(NSLocalizedString("no_select_printer", comment: ""))
            return
        }
        printerInfoFacade.fetchStatus(printerInfo: info, callback: callback)
    }

    func fetchSystemReport() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchSystemReport(printerInfo: info)
    }

    func fetchMediaVersion() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchMediaVersion(printerInfo: info)
    }

    func fetchBattery() -> String {
        guard let info = printerInfo else {
            return NSLocalizedString("no_select_printer", comment: "")
        }
        return printerInfoFacade.fetchBatteryInfo(printerInfo: info)
    }
}
