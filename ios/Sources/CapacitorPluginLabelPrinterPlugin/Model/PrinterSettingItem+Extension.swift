//
//  PrinterSettingItem+Extension.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import Foundation

extension PrinterSettingItem {
    static func allCases() -> [PrinterSettingItem] {
        return [
            .PSI_NET_BOOTMODE, .PSI_NET_INTERFACE, .PSI_NET_USED_IPV6, .PSI_NET_PRIORITY_IPV6, .PSI_NET_IPV4_BOOTMETHOD,
            .PSI_NET_STATIC_IPV4ADDRESS, .PSI_NET_SUBNETMASK, .PSI_NET_GATEWAY, .PSI_NET_DNS_IPV4_BOOTMETHOD,
            .PSI_NET_PRIMARY_DNS_IPV4ADDRESS, .PSI_NET_SECOND_DNS_IPV4ADDRESS, .PSI_NET_IPV6_BOOTMETHOD, .PSI_NET_STATIC_IPV6ADDRESS,
            .PSI_NET_PRIMARY_DNS_IPV6ADDRESS, .PSI_NET_SECOND_DNS_IPV6ADDRESS, .PSI_NET_IPV6ADDRESS_LIST,
            .PSI_NET_COMMUNICATION_MODE, .PSI_NET_SSID, .PSI_NET_CHANNEL, .PSI_NET_AUTHENTICATION_METHOD,
            .PSI_NET_ENCRYPTIONMODE, .PSI_NET_WEPKEY, .PSI_NET_PASSPHRASE, .PSI_NET_USER_ID, .PSI_NET_PASSWORD,
            .PSI_NET_NODENAME, .PSI_WIRELESSDIRECT_KEY_CREATE_MODE, .PSI_WIRELESSDIRECT_SSID, .PSI_WIRELESSDIRECT_NETWORK_KEY,
            .PSI_BT_ISDISCOVERABLE, .PSI_BT_DEVICENAME, .PSI_BT_BOOTMODE, .PSI_PRINTER_POWEROFFTIME, .PSI_PRINTER_POWEROFFTIME_BATTERY,
            .PSI_PRINT_JPEG_HALFTONE, .PSI_PRINT_JPEG_SCALE, .PSI_PRINT_DENSITY, .PSI_PRINT_SPEED, .PSI_BT_AUTO_CONNECTION
        ]
    }
    var name: String {
        switch self {
        case .PSI_NET_BOOTMODE:
            return "PSI_NET_BOOTMODE"
        case .PSI_NET_INTERFACE:
            return "PSI_NET_INTERFACE"
        case .PSI_NET_USED_IPV6:
            return "PSI_NET_USED_IPV6"
        case .PSI_NET_PRIORITY_IPV6:
            return "PSI_NET_PRIORITY_IPV6"
        case .PSI_NET_IPV4_BOOTMETHOD:
            return "PSI_NET_IPV4_BOOTMETHOD"
        case .PSI_NET_STATIC_IPV4ADDRESS:
            return "PSI_NET_STATIC_IPV4ADDRESS"
        case .PSI_NET_SUBNETMASK:
            return "PSI_NET_SUBNETMASK"
        case .PSI_NET_GATEWAY:
            return "PSI_NET_GATEWAY"
        case .PSI_NET_DNS_IPV4_BOOTMETHOD:
            return "PSI_NET_DNS_IPV4_BOOTMETHOD"
        case .PSI_NET_PRIMARY_DNS_IPV4ADDRESS:
            return "PSI_NET_PRIMARY_DNS_IPV4ADDRESS"
        case .PSI_NET_SECOND_DNS_IPV4ADDRESS:
            return "PSI_NET_SECOND_DNS_IPV4ADDRESS"
        case .PSI_NET_IPV6_BOOTMETHOD:
            return "PSI_NET_IPV6_BOOTMETHOD"
        case .PSI_NET_STATIC_IPV6ADDRESS:
            return "PSI_NET_STATIC_IPV6ADDRESS"
        case .PSI_NET_PRIMARY_DNS_IPV6ADDRESS:
            return "PSI_NET_PRIMARY_DNS_IPV6ADDRESS"
        case .PSI_NET_SECOND_DNS_IPV6ADDRESS:
            return "PSI_NET_SECOND_DNS_IPV6ADDRESS"
        case .PSI_NET_IPV6ADDRESS_LIST:
            return "PSI_NET_IPV6ADDRESS_LIST"
        case .PSI_NET_COMMUNICATION_MODE:
            return "PSI_NET_COMMUNICATION_MODE"
        case .PSI_NET_SSID:
            return "PSI_NET_SSID"
        case .PSI_NET_CHANNEL:
            return "PSI_NET_CHANNEL"
        case .PSI_NET_AUTHENTICATION_METHOD:
            return "PSI_NET_AUTHENTICATION_METHOD"
        case .PSI_NET_ENCRYPTIONMODE:
            return "PSI_NET_ENCRYPTIONMODE"
        case .PSI_NET_WEPKEY:
            return "PSI_NET_WEPKEY"
        case .PSI_NET_PASSPHRASE:
            return "PSI_NET_PASSPHRASE"
        case .PSI_NET_USER_ID:
            return "PSI_NET_USER_ID"
        case .PSI_NET_PASSWORD:
            return "PSI_NET_PASSWORD"
        case .PSI_NET_NODENAME:
            return "PSI_NET_NODENAME"
        case .PSI_WIRELESSDIRECT_KEY_CREATE_MODE:
            return "PSI_WIRELESSDIRECT_KEY_CREATE_MODE"
        case .PSI_WIRELESSDIRECT_SSID:
            return "PSI_WIRELESSDIRECT_SSID"
        case .PSI_WIRELESSDIRECT_NETWORK_KEY:
            return "PSI_WIRELESSDIRECT_NETWORK_KEY"
        case .PSI_BT_ISDISCOVERABLE:
            return "PSI_BT_ISDISCOVERABLE"
        case .PSI_BT_DEVICENAME:
            return "PSI_BT_DEVICENAME"
        case .PSI_BT_BOOTMODE:
            return "PSI_BT_BOOTMODE"
        case .PSI_PRINTER_POWEROFFTIME:
            return "PSI_PRINTER_POWEROFFTIME"
        case .PSI_PRINTER_POWEROFFTIME_BATTERY:
            return "PSI_PRINTER_POWEROFFTIME_BATTERY"
        case .PSI_PRINT_JPEG_HALFTONE:
            return "PSI_PRINT_JPEG_HALFTONE"
        case .PSI_PRINT_JPEG_SCALE:
            return "PSI_PRINT_JPEG_SCALE"
        case .PSI_PRINT_DENSITY:
            return "PSI_PRINT_DENSITY"
        case .PSI_PRINT_SPEED:
            return "PSI_PRINT_SPEED"
        case .PSI_BT_POWERSAVEMODE:
            return "PSI_BT_POWERSAVEMODE"
        case .PSI_BT_SSP:
            return "PSI_BT_SSP"
        case .PSI_BT_AUTHMODE:
            return "PSI_BT_AUTHMODE"
        case .PSI_BT_AUTO_CONNECTION:
            return "PSI_BT_AUTO_CONNECTION"
        @unknown default:
            return "unknown"
        }
    }

    var valueList: [ConfigurationSettingData] {
        switch self {
        case .PSI_NET_BOOTMODE, .PSI_BT_BOOTMODE:
            return [
                ConfigurationSettingData(itemKey: 0, itemValue: "ON"),
                ConfigurationSettingData(itemKey: 1, itemValue: "OFF"),
                ConfigurationSettingData(itemKey: 2, itemValue: "Keep current state")
            ]
        case .PSI_NET_INTERFACE:
            return [
                ConfigurationSettingData(itemKey: 1, itemValue: "Wireless LAN only"),
                ConfigurationSettingData(itemKey: 2, itemValue: "Wireless Direct only"),
                ConfigurationSettingData(itemKey: 3, itemValue: "Wireless LAN & Wireless Direct")
            ]
        case .PSI_NET_USED_IPV6, .PSI_NET_PRIORITY_IPV6, .PSI_NET_IPV6_BOOTMETHOD,
                .PSI_BT_ISDISCOVERABLE, .PSI_BT_AUTO_CONNECTION, .PSI_PRINT_JPEG_SCALE:
            return [
                ConfigurationSettingData(itemKey: 0, itemValue: "Disable"),
                ConfigurationSettingData(itemKey: 1, itemValue: "Enable")
            ]
        case .PSI_NET_IPV4_BOOTMETHOD:
            return [
                ConfigurationSettingData(itemKey: 0, itemValue: "Auto"),
                ConfigurationSettingData(itemKey: 3, itemValue: "DHCP"),
                ConfigurationSettingData(itemKey: 5, itemValue: "Bootp"),
                ConfigurationSettingData(itemKey: 6, itemValue: "RARP"),
                ConfigurationSettingData(itemKey: 7, itemValue: "Static")
            ]
        case .PSI_NET_STATIC_IPV4ADDRESS, .PSI_NET_SUBNETMASK, .PSI_NET_GATEWAY, .PSI_NET_PRIMARY_DNS_IPV4ADDRESS,
                .PSI_NET_SECOND_DNS_IPV4ADDRESS, .PSI_NET_STATIC_IPV6ADDRESS, .PSI_NET_PRIMARY_DNS_IPV6ADDRESS,
                .PSI_NET_SECOND_DNS_IPV6ADDRESS, .PSI_NET_IPV6ADDRESS_LIST, .PSI_NET_SSID, .PSI_NET_WEPKEY,
                .PSI_NET_PASSPHRASE, .PSI_NET_USER_ID, .PSI_NET_PASSWORD, .PSI_NET_NODENAME, .PSI_WIRELESSDIRECT_SSID,
                .PSI_WIRELESSDIRECT_NETWORK_KEY, .PSI_BT_DEVICENAME, .PSI_PRINTER_POWEROFFTIME, .PSI_PRINTER_POWEROFFTIME_BATTERY:
            return []
        case .PSI_NET_DNS_IPV4_BOOTMETHOD:
            return [
                ConfigurationSettingData(itemKey: 2, itemValue: "Auto"),
                ConfigurationSettingData(itemKey: 1, itemValue: "Static")
            ]
        case .PSI_NET_COMMUNICATION_MODE:
            return [
                ConfigurationSettingData(itemKey: 2, itemValue: "Ad hoc"),
                ConfigurationSettingData(itemKey: 1, itemValue: "Instructure")
            ]
        case .PSI_NET_CHANNEL:
            return [
                ConfigurationSettingData(itemKey: 1, itemValue: "1"),
                ConfigurationSettingData(itemKey: 2, itemValue: "2"),
                ConfigurationSettingData(itemKey: 3, itemValue: "3"),
                ConfigurationSettingData(itemKey: 4, itemValue: "4"),
                ConfigurationSettingData(itemKey: 5, itemValue: "5"),
                ConfigurationSettingData(itemKey: 6, itemValue: "6"),
                ConfigurationSettingData(itemKey: 7, itemValue: "7"),
                ConfigurationSettingData(itemKey: 8, itemValue: "8"),
                ConfigurationSettingData(itemKey: 9, itemValue: "9"),
                ConfigurationSettingData(itemKey: 10, itemValue: "10"),
                ConfigurationSettingData(itemKey: 11, itemValue: "11"),
                ConfigurationSettingData(itemKey: 12, itemValue: "12"),
                ConfigurationSettingData(itemKey: 13, itemValue: "13")
            ]
        case .PSI_NET_AUTHENTICATION_METHOD:
            return [
                ConfigurationSettingData(itemKey: 1, itemValue: "Open System"),
                ConfigurationSettingData(itemKey: 2, itemValue: "Shared Key"),
                ConfigurationSettingData(itemKey: 3, itemValue: "WPA/WPA2-PSK"),
                ConfigurationSettingData(itemKey: 4, itemValue: "LEAP CKIP"),
                ConfigurationSettingData(itemKey: 5, itemValue: "EAP-FAST/NONE"),
                ConfigurationSettingData(itemKey: 6, itemValue: "EAP-FAST/MS-CHAPv2"),
                ConfigurationSettingData(itemKey: 7, itemValue: "EAP-FAST/GTC"),
                ConfigurationSettingData(itemKey: 8, itemValue: "PEAP/MS-CHAPv2"),
                ConfigurationSettingData(itemKey: 9, itemValue: "PEAP/GTC"),
                ConfigurationSettingData(itemKey: 10, itemValue: "EAP-TTLS/MS-CHAP"),
                ConfigurationSettingData(itemKey: 11, itemValue: "EAP-TTLS/MS-CHAPv2"),
                ConfigurationSettingData(itemKey: 12, itemValue: "EAP-TTLS/PAP TKIP"),
                ConfigurationSettingData(itemKey: 13, itemValue: "EAP-TLS"),
                ConfigurationSettingData(itemKey: 18, itemValue: "WPA3-SAE"),
                ConfigurationSettingData(itemKey: 19, itemValue: "WPA/WPA2-PSK/WPA3-SAE")
            ]
        case .PSI_NET_ENCRYPTIONMODE:
            return [
                ConfigurationSettingData(itemKey: 1, itemValue: "None"),
                ConfigurationSettingData(itemKey: 2, itemValue: "WEP"),
                ConfigurationSettingData(itemKey: 8, itemValue: "TKIP+AES"),
                ConfigurationSettingData(itemKey: 4, itemValue: "AES"),
                ConfigurationSettingData(itemKey: 5, itemValue: "CKIP"),
                ConfigurationSettingData(itemKey: 3, itemValue: "TKIP")
            ]
        case .PSI_WIRELESSDIRECT_KEY_CREATE_MODE:
            return [
                ConfigurationSettingData(itemKey: 1, itemValue: "Auto"),
                ConfigurationSettingData(itemKey: 0, itemValue: "Static")
            ]
        case .PSI_PRINT_JPEG_HALFTONE:
            return [
                ConfigurationSettingData(itemKey: 0, itemValue: "Simple Binary"),
                ConfigurationSettingData(itemKey: 1, itemValue: "Error Diffusion")
            ]
        case .PSI_PRINT_DENSITY:
            return [
                ConfigurationSettingData(itemKey: -5, itemValue: "-5"),
                ConfigurationSettingData(itemKey: -4, itemValue: "-4"),
                ConfigurationSettingData(itemKey: -3, itemValue: "-3"),
                ConfigurationSettingData(itemKey: -2, itemValue: "-2"),
                ConfigurationSettingData(itemKey: -1, itemValue: "-1"),
                ConfigurationSettingData(itemKey: 0, itemValue: "0"),
                ConfigurationSettingData(itemKey: 1, itemValue: "1"),
                ConfigurationSettingData(itemKey: 2, itemValue: "2"),
                ConfigurationSettingData(itemKey: 3, itemValue: "3"),
                ConfigurationSettingData(itemKey: 4, itemValue: "4"),
                ConfigurationSettingData(itemKey: 5, itemValue: "5")
            ]
        case .PSI_PRINT_SPEED:
            return [
                ConfigurationSettingData(itemKey: 0, itemValue: "0"),
                ConfigurationSettingData(itemKey: 1, itemValue: "1"),
                ConfigurationSettingData(itemKey: 2, itemValue: "2"),
                ConfigurationSettingData(itemKey: 3, itemValue: "3"),
                ConfigurationSettingData(itemKey: 4, itemValue: "4"),
                ConfigurationSettingData(itemKey: 5, itemValue: "5"),
                ConfigurationSettingData(itemKey: 6, itemValue: "6")
            ]
        case .PSI_BT_POWERSAVEMODE:
            return []
        case .PSI_BT_SSP:
            return []
        case .PSI_BT_AUTHMODE:
            return []
        @unknown default:
            return []
        }
    }
}
