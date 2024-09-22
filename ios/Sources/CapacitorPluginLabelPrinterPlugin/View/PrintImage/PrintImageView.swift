//
//  PrintImageView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import SwiftUI

protocol PrintImageViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func printImageWithImageDidTap()
    func printImageWithURLDidTap()
    func printImageWithURLsDidTap()
    func printPRNWithURLDidTap()
    func printPRNWithURLsDidTap()
    func printPRNWithDataDidTap()
}

struct PrintImageView: View {
    weak var delegate: PrintImageViewDelegate?
    @ObservedObject var dataSource: PrintImageViewModel
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
                Text("printer").foregroundColor(.gray)
            })
            Section {
                Button(action: {
                    delegate?.printImageWithImageDidTap()
                }, label: {
                    Text("print_image_with_image")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printImageWithURLDidTap()
                }, label: {
                    Text("print_image_with_URL")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printImageWithURLsDidTap()
                }, label: {
                    Text("print_image_with_URLs")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printPRNWithURLDidTap()
                }, label: {
                    Text("print_PRN_with_URL")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printPRNWithURLsDidTap()
                }, label: {
                    Text("print_PRN_with_URLs")
                }).foregroundColor(.black)
                Button(action: {
                    delegate?.printPRNWithDataDidTap()
                }, label: {
                    Text("print_PRN_with_data")
                }).foregroundColor(.black)
            }
        }
    }
}

struct PrintImageView_Previews: PreviewProvider {
    static var previews: some View {
        PrintImageView(dataSource: .init())
    }
}
