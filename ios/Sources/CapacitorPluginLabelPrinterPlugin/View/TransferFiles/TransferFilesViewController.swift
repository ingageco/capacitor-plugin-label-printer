//
//  TransferFilesViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/1/29.
//

import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers

class TransferFilesViewController: UIViewController {
    private var dataSource = TransferFilesViewModel()
    private var selectPickerCallback: ((URL) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = TransferFilesView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("transfer_files", comment: "")
    }

    func showTransferConfirmAlert(title: String, filePath: String, callback: @escaping () -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: filePath, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("transfer", comment: ""), style: .default, handler: { _ in
            let alertController = UIAlertController(title: NSLocalizedString("waiting", comment: ""),
                                                    message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true)
            callback()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    private func showResult(result: String) {
        if let alert = self.presentedViewController as? UIAlertController {
            alert.dismiss(animated: false) {
                let viewController = ResultViewController()
                viewController.dataSource.resultMessage = result
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    private func showConnectionAlertIfNeeded() -> Bool {
        if dataSource.printerInfo == nil {
            let alert = CommonAlertUtil.connectPrinterAlert()
            self.present(alert, animated: true)
            return false
        }
        return true
    }
}

extension TransferFilesViewController: TransferFilesViewDelegate {
    func selectPrinterButtonDidTap() {
        let viewController = PrinterInterfaceViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func sendFirmDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { url in
            self.showTransferConfirmAlert(title: TransferFileType.FIRM.rawValue, filePath: url.path, callback: {
                self.dataSource.transferFile(
                    type: .FIRM,
                    filePath: FileUtils.copyFileToTemp(urls: [url]).first ?? url,
                    callBack: { result in
                        self.showResult(result: result)
                    }
                )
            })
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func sendTemplateDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { url in
            self.showTransferConfirmAlert(title: TransferFileType.TEMPLATE.rawValue, filePath: url.path, callback: {
                self.dataSource.transferFile(
                    type: .TEMPLATE,
                    filePath: FileUtils.copyFileToTemp(urls: [url]).first ?? url,
                    callBack: { result in
                        self.showResult(result: result)
                    }
                )
            })
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func sendDatabaseDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { url in
            self.showTransferConfirmAlert(title: TransferFileType.DATABASE.rawValue, filePath: url.path, callback: {
                self.dataSource.transferFile(
                    type: .DATABASE,
                    filePath: FileUtils.copyFileToTemp(urls: [url]).first ?? url,
                    callBack: { result in
                        self.showResult(result: result)
                    }
                )
            })
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func sendFileDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { url in
            self.showTransferConfirmAlert(title: TransferFileType.FILE.rawValue, filePath: url.path, callback: {
                self.dataSource.transferFile(
                    type: .FILE,
                    filePath: FileUtils.copyFileToTemp(urls: [url]).first ?? url,
                    callBack: { result in
                        self.showResult(result: result)
                    }
                )
            })
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }
}

extension TransferFilesViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        defer {
            selectPickerCallback = nil
        }
        guard let url = urls.first else { return }
        selectPickerCallback?(url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        selectPickerCallback = nil
    }
}

extension TransferFilesViewController: PrinterInfoSaveDelegate {
    func savePrinterInfo(info: IPrinterInfo?) {
        dataSource.printerInfo = info
    }
}
