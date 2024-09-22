//
//  PrinterInfoFacade.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/28.
//

import BRLMPrinterKit
import Foundation

class PrinterInfoFacade {

    // fetch Printer Firm Version
    func fetchMainFirmVersion(printerInfo: IPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestMainFirmVersion()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch Printer Serial Number
    func fetchSerial(printerInfo: IPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestSerialNumber()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch Printer Status
    func fetchStatus(printerInfo: IPrinterInfo, callback: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: printerInfo) else {
                DispatchQueue.main.async {
                    callback(NSLocalizedString("create_channel_error", comment: ""))
                }
                return
            }
            let generateResult = BRLMPrinterDriverGenerator.open(channel)
            if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
                DispatchQueue.main.async {
                    callback(OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code))
                }
                return
            }
            let driver = generateResult.driver
            let printError = driver?.getPrinterStatus()
            driver?.closeChannel()
            DispatchQueue.main.async {
                callback(self.getStatusDetail(status: printError?.status))
            }
        }
    }

    // fetch Printer Media Version
    func fetchMediaVersion(printerInfo: IPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestMediaVersion()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch Printer System Report
    func fetchSystemReport(printerInfo: IPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestSystemReport()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)
    }

    // fetch Printer Battery Info
    func fetchBatteryInfo(printerInfo: IPrinterInfo) -> String {
        var generateErrorString = ""
        guard let driver = self.generateDriver(printerInfo: printerInfo, errorString: &generateErrorString) else {
            return generateErrorString
        }
        let getError = driver.requestBatteryInfo()
        driver.closeChannel()
        return generateResultString(getPrinterInfoResult: getError)

    }
    
    private func generateDriver(printerInfo: IPrinterInfo, errorString: inout String) -> BRLMPrinterDriver? {
        guard let channel = PrinterConnectUtil().fetchCurrentChannel(printerInfo: printerInfo) else {
            errorString = NSLocalizedString("create_channel_error", comment: "")
            return nil
        }
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        if generateResult.error.code != BRLMOpenChannelErrorCode.noError {
            errorString = OpenChannelErrorModel.fetchChannelErrorCode(error: generateResult.error.code)
            return nil
        }
        guard let  driver = generateResult.driver else {
            errorString = NSLocalizedString("unknown_error", comment: "")
            return nil
        }
        return driver
    }

    private func generateResultString(getPrinterInfoResult: Any) -> String {
        var resultString = NSLocalizedString("unknown_error", comment: "")
        if let result = getPrinterInfoResult as? BRLMRequestPrinterInfoResult<AnyObject> {
            resultString = "\(NSLocalizedString("result", comment: "")) : "
            + "\(RequestPrinterInfoErrorModel.fetchGetPrinterInfoErrorCode(error: result.error.code))\n"
            if let value = result.printerInfo as? String {
                resultString += "\(NSLocalizedString("value", comment: "")) : \(value)"
            } else if let value = result.printerInfo as? BRLMBatteryInfo {
                resultString += "\(NSLocalizedString("battery_charge", comment: "")) : "
                + "\(value.chargeLevel)\n"
                + "\(NSLocalizedString("battery_health", comment: "")) : "
                + "\(value.healthLevel)\n"
                + "\(NSLocalizedString("battery_health_level", comment: "")) : "
                + "\(getBatteryHealthLevelString(healthStatus: value.healthStatus))"
            }
        }

       return resultString
    }
    
    private func getBatteryHealthLevelString(healthStatus: BRLMBatteryInfoHealthStatus) -> String {
        var healthStatusString = ""
        switch healthStatus {
        case .excellent:
            healthStatusString = NSLocalizedString("battery_health_excellent", comment: "")
        case .good:
            healthStatusString = NSLocalizedString("battery_health_good", comment: "")
        case .replaceSoon:
            healthStatusString = NSLocalizedString("battery_health_replace_soon", comment: "")
        case .replaceBattery:
            healthStatusString = NSLocalizedString("battery_health_replace_battery", comment: "")
        case .notInstalled:
            healthStatusString = NSLocalizedString("battery_health_not_installed", comment: "")
        @unknown default:
            healthStatusString = NSLocalizedString("battery_health_not_installed", comment: "")
        }
        return healthStatusString
    }

    private func getStatusDetail(status: BRLMPrinterStatus?) -> String {
        guard let status = status else { return "" }
        let error = "Error: " + PrintErrorModel.fetchPrinterStatusErrorCode(error: status.errorCode) + "\n"
        let model = "Model: " + (PrinterModel.allCases.first(where: { value in
            value.printerModel == status.model
        })?.rawValue ?? "") + "\n"
        let mediaType = "MediaInfo.MediaType: " + PrintErrorModel.fetchMediaTypeName(mediaType: status.mediaInfo?.mediaType) + "\n"
        let mediaBackgroundColor = "MediaInfo.BackgroundColor: " +
        PrintErrorModel.fetchMediaBackgroundColor(color: status.mediaInfo?.backgroundColor) + "\n"
        let mediaInkColor = "MediaInfo.InkColor: " + PrintErrorModel.fetchMediaInkColor(color: status.mediaInfo?.inkColor) + "\n"
        let mediaWidth = "MediaInfo.Width: " +
        (status.mediaInfo?.width_mm == nil ? "none" : String(status.mediaInfo?.width_mm ?? 0)) + "\n"
        let mediaHeight = "MediaInfo.Height: " +
        (status.mediaInfo?.height_mm == nil ? "none" : String(status.mediaInfo?.height_mm ?? 0)) + "\n"
        let mediaIsHeightInfinite = "MediaInfo.IsHeightInfinite: " +
        (status.mediaInfo?.isHeightInfinite == nil ? "none" : String(status.mediaInfo?.isHeightInfinite ?? false)) + "\n"
        var getQLLabelResult: Bool = false
        var getPTLabelResult: Bool = false
        let mediaQLLabelSize = "MediaInfo.QLLabelSize: " +
        PrintErrorModel.fetchQLLabelSize(size: status.mediaInfo?.getQLLabelSize(&getQLLabelResult)) + "\n"
        let mediaPTLabelSize = "MediaInfo.PTLabelSize: " +
        PrintErrorModel.fetchPTLabelSize(size: status.mediaInfo?.getPTLabelSize(&getPTLabelResult)) + "\n"

        let mediaInfo = status.mediaInfo == nil ? "MediaInfo: none\n" :
        (mediaType + mediaBackgroundColor + mediaInkColor + mediaWidth +
         mediaHeight + mediaIsHeightInfinite + mediaQLLabelSize + mediaPTLabelSize)
        let batteryInfo = "BatteryMounted: " +
        PrintErrorModel.fetchPrinterBatteryStatusTernary(ternary: status.batteryStatus?.batteryMounted) + "\n" +
        "Charging: " + PrintErrorModel.fetchPrinterBatteryStatusTernary(ternary: status.batteryStatus?.charging) + "\n" +
        "ChargingLevel(current/max): " + (status.batteryStatus?.chargeLevel.current.description ?? "") + "/" +
        (status.batteryStatus?.chargeLevel.max.description ?? "")
        return model + error + mediaInfo + batteryInfo
    }
}
