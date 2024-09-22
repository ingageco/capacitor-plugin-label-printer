//
//  TransferFilesView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import SwiftUI

protocol TransferFilesViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func sendFirmDidTap()
    func sendTemplateDidTap()
    func sendDatabaseDidTap()
    func sendFileDidTap()
}

struct TransferFilesView: View {
    weak var delegate: TransferFilesViewDelegate?
    @ObservedObject var dataSource: TransferFilesViewModel
    var body: some View {
        Form {
            Section(content: {
                Button(action: {
                    delegate?.selectPrinterButtonDidTap()
                }, label: {
                    VStack(alignment: .leading) {
                        Text(dataSource.printerInfo?.modelName ?? NSLocalizedString("select_printer_message", comment: ""))
                            .foregroundColor(.black)
                        if dataSource.printerInfo?.channelType == .wiFi {
                            Text((dataSource.printerInfo as? WiFiPrinterInfo)?.ipv4Address ?? "").font(.footnote).foregroundColor(.gray)
                        } else if dataSource.printerInfo?.channelType == .bluetoothMFi {
                            Text((dataSource.printerInfo as? BluetoothPrinterInfo)?.serialNum ?? "").font(.footnote).foregroundColor(.gray)
                        }
                    }
                })
            }, header: {
                Text("Printer").foregroundColor(.gray)
            })
            Section {
                Button(action: {
                    delegate?.sendFirmDidTap()
                }, label: {
                    Text("SendFirm")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.sendTemplateDidTap()
                }, label: {
                    Text("SendTemplate")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.sendDatabaseDidTap()
                }, label: {
                    Text("SendDatabase")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.sendFileDidTap()
                }, label: {
                    Text("SendFile")
                }).foregroundColor(.black)
            }
        }
    }
}

struct TransferFilesView_Previews: PreviewProvider {
    static var previews: some View {
        TransferFilesView(dataSource: .init())
    }
}
