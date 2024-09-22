//
//  TransferFilesViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/30.
//

import Foundation

class TransferFilesViewModel: ObservableObject {
    @Published var printerInfo: IPrinterInfo?
    @Published var isShowWaitingView: Bool = false
    @Published var isShowCancelingView: Bool = false
    private let transferFacade = TransferFileFacade()

    func transferFile(type: TransferFileType, filePath: URL, callBack: @escaping (String) -> Void) {
        guard let info = printerInfo else {
            callBack(NSLocalizedString("no_select_printer", comment: ""))
            return
        }
        let path = filePath.path
        transferFacade.startTransferFile(info: info, type: type, filePath: path, callback: callBack)
    }
}
