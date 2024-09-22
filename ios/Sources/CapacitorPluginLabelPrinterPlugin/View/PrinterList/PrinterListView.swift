//
//  PrinterListView.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/10.
//

import BRLMPrinterKit
import SwiftUI

protocol PrinterListViewDelegate: AnyObject {
    func connectPrinter(data: PrinterItemData)
}

struct PrinterListView: View {
    weak var delegate: PrinterListViewDelegate?
    @ObservedObject var dataSource: PrinterListViewModel
    var body: some View {
        VStack {
            if dataSource.itemList.isEmpty {
                // emptyView message
                Text("not_find_data")
            } else {
                Form {
                    Section(content: {
                        ForEach(dataSource.itemList, id: \.self, content: { value in
                            PrinterItemView(
                                value: value,
                                delegate: delegate
                            )
                        })
                    }, header: {
                        Text(dataSource.typeName)
                    })
                }
            }
        }
    }
}

struct PrinterListView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterListView(dataSource: .init())
    }
}

struct PrinterItemView: View {
    var value: PrinterItemData
    var delegate: PrinterListViewDelegate?
    var body: some View {
        Button(action: {
            delegate?.connectPrinter(data: value)
        }, label: {
            VStack(alignment: .leading, content: {
                Text(value.printerName).font(.system(size: 20, design: .default)).foregroundColor(.black)
                Text(value.value).font(.footnote).foregroundColor(.gray)
            })
        })
    }
}
