//
//  PrinterConnectUtil.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/22.
//

import BRLMPrinterKit
import Foundation

class PrinterConnectUtil {

    func fetchCurrentChannel(printerInfo: IPrinterInfo) -> BRLMChannel? {
        if printerInfo is WiFiPrinterInfo, let ipAddress = (printerInfo as? WiFiPrinterInfo)?.ipv4Address {
            return BRLMChannel(wifiIPAddress: ipAddress)
        } else if printerInfo is BluetoothPrinterInfo, let serialNum = (printerInfo as? BluetoothPrinterInfo)?.serialNum {
            return BRLMChannel(bluetoothSerialNumber: serialNum)
        } else if printerInfo is BLEPrinterInfo {
            return BRLMChannel(bleLocalName: printerInfo.modelName)
        } else {
            return nil
        }
    }

    func fetchPrinter(printerInfo: IPrinterInfo) -> BRPtouchPrinter? {
        var interface: CONNECTION_TYPE?
        switch printerInfo.channelType {
        case .bluetoothMFi:
            interface = CONNECTION_TYPE.BLUETOOTH
        case .wiFi:
            interface = CONNECTION_TYPE.WLAN
        case .bluetoothLowEnergy:
            interface = CONNECTION_TYPE.BLE
        @unknown default:
            break
        }
        if let type = interface,
           let printer = BRPtouchPrinter(printerName: printerInfo.fetchPrinterModel()?.sdkModelName, interface: type) {
            let deviceInfo = fetchDeviceInfo(printerInfo: printerInfo)
            switch printerInfo.channelType {
            case .bluetoothMFi:
                printer.setupForBluetoothDevice(withSerialNumber: deviceInfo.strSerialNumber)
            case .wiFi:
                printer.setIPAddress(deviceInfo.strIPAddress)
            case .bluetoothLowEnergy:
                printer.setBLEAdvertiseLocalName(printerInfo.modelName)
            @unknown default:
                break
            }
            return printer
        }
        return nil
    }

    func fetchDeviceInfo(printerInfo: IPrinterInfo) -> BRPtouchDeviceInfo {
        let info = BRPtouchDeviceInfo()
        switch printerInfo.channelType {
        case .bluetoothMFi:
            if let serialNum = (printerInfo as? BluetoothPrinterInfo)?.serialNum {
                info.strSerialNumber = serialNum
            }
        case .wiFi:
            if let ipAddress = (printerInfo as? WiFiPrinterInfo)?.ipv4Address {
                info.strIPAddress = ipAddress
            }
        case .bluetoothLowEnergy:
            break
        @unknown default:
            break
        }
        return info
    }
}
