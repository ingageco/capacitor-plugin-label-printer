//
//  PrinterConfigurationView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import SwiftUI

protocol PrinterConfigurationViewDelegate: AnyObject {
    func selectPrinterButtonDidTap()
    func showConnectPrinterAlert()
    func selectItemDidTap(item: PrinterSettingItem?, value: String?)
    func editItemDidTap(item: PrinterSettingItem, message: String)
    func fetchConfigurations()
    func setButtonDidTap()
    func showEmptyListAlert()
}

struct PrinterConfigurationView: View {
    weak var delegate: PrinterConfigurationViewDelegate?
    @ObservedObject var dataSource: PrinterConfigurationViewModel
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
                ZStack {
                    NavigationLink(destination: PrinterSettingItemListView(
                        delegate: delegate,
                        title: NSLocalizedString("get_configuration", comment: ""),
                        itemList: dataSource.itemList,
                        checkedList: $dataSource.configurationSetList,
                        printerInfo: $dataSource.printerInfo
                    ), label: {
                        EmptyView()
                    }).opacity(0)
                    HStack {
                        Text("get_configuration")
                        Spacer()
                    }
                }

                ZStack {
                    NavigationLink(destination: PrinterSettingItemListView(
                        delegate: delegate,
                        title: NSLocalizedString("set_configuration", comment: ""),
                        itemList: dataSource.itemList,
                        checkedList: $dataSource.configurationSetList,
                        printerInfo: $dataSource.printerInfo
                    ), label: {
                        EmptyView()
                    }).opacity(0)
                    HStack {
                        Text("set_configuration")
                        Spacer()
                    }
                }
            }
            .onAppear(perform: {
                dataSource.configurationSetList = []
            })
        }
    }
}

struct PrinterConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterConfigurationView(dataSource: .init())
    }
}

struct PrinterSettingItemListView: View {
    var delegate: PrinterConfigurationViewDelegate?
    var title: String
    var itemList: [PrinterSettingItem]
    @Binding var checkedList: [ConfigurationItemData]
    @Binding var printerInfo: IPrinterInfo?
    var body: some View {
        List {
            Section {
                ForEach(itemList, id: \.self, content: { value in
                    Button(action: {
                        if checkedList.map({ $0.settingItem }).contains(value) {
                            checkedList.removeAll(where: { $0.settingItem == value })
                        } else {
                            checkedList.append(
                                ConfigurationItemData(settingItem: value, value: NSLocalizedString("text_no_data", comment: ""))
                            )
                        }
                    }, label: {
                        HStack {
                            Text(value.name).foregroundColor(.black)
                            Spacer()
                            if checkedList.map({ $0.settingItem }).contains(value) {
                                Image(systemName: "checkmark")
                            }
                        }
                    })
                })
            }
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
        .navigationBarItems(
            trailing: VStack {
                if printerInfo == nil {
                    Button("next", action: {
                        delegate?.showConnectPrinterAlert()
                    })
                } else if checkedList.isEmpty {
                    Button("next", action: {
                        delegate?.showEmptyListAlert()
                    })
                } else {
                    if title == NSLocalizedString("set_configuration", comment: "") {
                        NavigationLink(destination: ConfigurationsSetView(
                            checkedList: $checkedList,
                            delegate: delegate
                        ), label: {
                            Text("next")
                        })
                    } else {
                        Button("next", action: {
                            delegate?.fetchConfigurations()
                        })
                    }
                }
            }
        )
    }
}

struct ConfigurationsSetView: View {
    @Binding var checkedList: [ConfigurationItemData]
    var delegate: PrinterConfigurationViewDelegate?
    @State var isShowItemSelectView: Bool = false
    @State var selectedItem: ConfigurationItemData?
    var body: some View {
        List {
            Section {
                ForEach(checkedList, id: \.self, content: { value in
                    Button(action: {
                        if !value.settingItem.valueList.isEmpty {
                            selectedItem = value
                            isShowItemSelectView = true
                        } else {
                            delegate?.editItemDidTap(item: value.settingItem, message: value.value)
                        }
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(value.settingItem.name).font(.body).foregroundColor(.black)
                            Text(value.value).font(.footnote).foregroundColor(.gray)
                        }.padding(8)
                    })
                })
            }
        }
        .sheet(isPresented: $isShowItemSelectView, onDismiss: {
            DispatchQueue.main.async {
                isShowItemSelectView = false
            }
        }, content: {
            ConfigItemListView(
                delegate: delegate,
                item: selectedItem?.settingItem,
                itemList: selectedItem?.settingItem.valueList.map({ $0.itemValue }),
                isShow: $isShowItemSelectView
            )
        })
        .navigationBarTitle(Text("set_configuration"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            delegate?.setButtonDidTap()
        }, label: {
            Text("set")
        }))
    }
}

struct ConfigItemListView: View {
    var delegate: PrinterConfigurationViewDelegate?
    var item: PrinterSettingItem?
    var itemList: [String]?
    @Binding var isShow: Bool

    var body: some View {
        NavigationView(content: {
            List(content: {
                Section(content: {
                    ForEach(itemList ?? [], id: \.self, content: { value in
                        Button(value, action: {
                            delegate?.selectItemDidTap(
                                item: item,
                                value: item?.valueList.first(where: { $0.itemValue == value })?.itemValue ?? ""
                            )
                            isShow = false
                        }).foregroundColor(.black)
                    })
                })
            })
            .navigationBarTitle(Text(item?.name ?? ""), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                isShow = false
            }, label: {
                Text("cancel")
            }))
        })
    }
}
