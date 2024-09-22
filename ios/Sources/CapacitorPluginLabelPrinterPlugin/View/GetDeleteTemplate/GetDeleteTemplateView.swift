//
//  GetDeleteTemplateViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import SwiftUI

protocol GetDeleteTemplateViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func requestTemplateListDidTap()
    func deleteTemplateDidTap(number: String)
    func showConnectPrinterAlert()
}

struct GetDeleteTemplateView: View {
    weak var delegate: GetDeleteTemplateViewDelegate?
    @ObservedObject var dataSource: GetDeleteTemplateViewModel
    @State var isShowDeleteView: Bool = false
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
                    delegate?.requestTemplateListDidTap()
                }, label: {
                    Text("requestTemplateList")
                }).foregroundColor(.black)
                Button(action: {
                    if dataSource.printerInfo == nil {
                        delegate?.showConnectPrinterAlert()
                    } else {
                        isShowDeleteView = true
                    }
                }, label: {
                    Text("delete")
                }).foregroundColor(.black)
                    .sheet(isPresented: $isShowDeleteView, onDismiss: {
                        isShowDeleteView = false
                    }, content: {
                        InputTemplateKeysView(
                            delegate: delegate,
                            isShow: $isShowDeleteView
                        )
                    })
            }
        }
    }
}

struct GetDeleteTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        GetDeleteTemplateView(dataSource: .init())
    }
}

struct InputTemplateKeysView: View {
    var delegate: GetDeleteTemplateViewDelegate?
    @Binding var isShow: Bool
    @State var number: String = ""
    @State var isInputValid: Bool = true
    var body: some View {
        NavigationView(content: {
            VStack(alignment: .leading, content: {
                Text("input_numbers_with_seperated").font(.footnote)
                TextField("", text: $number).textFieldStyle(.roundedBorder)
                if !isInputValid {
                    Text("error_invalidate_input")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                Spacer()
            }).padding(.horizontal, 16).padding(.top, 8)
                .navigationBarTitle(Text("delete"), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        isShow = false
                    }, label: {
                        Text("cancel")
                    }),
                    trailing: Button(action: {
                        guard number.isNumberListString() else {
                            isInputValid = false
                            return
                        }
                        isInputValid = true
                        isShow = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            delegate?.deleteTemplateDidTap(number: number)
                        })
                    }, label: {
                        Text("delete")
                    })
                )
        })
    }
}
