//
//  PrintImageViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import BRLMPrinterKit
import SwiftUI
import UIKit
import UniformTypeIdentifiers

class PrintImageViewController: UIViewController, UINavigationControllerDelegate {
    private var dataSource = PrintImageViewModel()
    private var selectPickerCallback: (([URL]) -> Void)?
    let cancelAlert = CommonAlertUtil.cancelingAlert()
    var waitAlert: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrintImageView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("print_image", comment: "")
        waitAlert = CommonAlertUtil.waitingAlert {
            self.dataSource.cancelPrinting()
            self.present(self.cancelAlert, animated: true)
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

extension PrintImageViewController: PrintImageViewDelegate {
    func selectPrinterButtonDidTap() {
        let viewController = PrinterInterfaceViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func printImageWithImageDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    func printImageWithURLDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            let viewController = PrintSettingsViewController()
            viewController.dataSource.printerInfo = self.dataSource.printerInfo
            viewController.dataSource.imageURLs = FileUtils.copyFileToTemp(urls: urls)
            viewController.dataSource.imageType = .imageURL
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let type = UTType("public.image") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [type], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func printImageWithURLsDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            let viewController = PrintSettingsViewController()
            viewController.dataSource.printerInfo = self.dataSource.printerInfo
            viewController.dataSource.imageURLs = FileUtils.copyFileToTemp(urls: urls)
            viewController.dataSource.imageType = .imageURLs
            self.navigationController?.pushViewController(viewController, animated: true)
        }

        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let type = UTType("public.image") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [type], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        }
        picker?.delegate = self
        picker?.allowsMultipleSelection = true
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func printPRNWithURLDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            if let alert = self.waitAlert {
                self.present(alert, animated: true)
            }
            self.dataSource.startPrint(urls: urls, imageType: .prnFile, callback: { result in
                if let alert = self.presentedViewController as? UIAlertController {
                    alert.dismiss(animated: false) {
                        let viewController = ResultViewController()
                        viewController.dataSource.resultMessage = result
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            })
        }

        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let type = UTType("com.brother.sdkdemo.prn") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [type], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["com.brother.sdkdemo.prn"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func printPRNWithURLsDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            if let alert = self.waitAlert {
                self.present(alert, animated: true)
            }
            self.dataSource.startPrint(urls: urls, imageType: .prnFiles, callback: { result in
                if let alert = self.presentedViewController as? UIAlertController {
                    alert.dismiss(animated: false) {
                        let viewController = ResultViewController()
                        viewController.dataSource.resultMessage = result
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            })
        }

        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let type = UTType("com.brother.sdkdemo.prn") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [type], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["com.brother.sdkdemo.prn"], in: .import)
        }
        picker?.allowsMultipleSelection = true
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func printPRNWithDataDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        selectPickerCallback = { urls in
            if let alert = self.waitAlert {
                self.present(alert, animated: true)
            }
            self.dataSource.startPrint(urls: urls, imageType: .rawData, callback: { result in
                if let alert = self.presentedViewController as? UIAlertController {
                    alert.dismiss(animated: false) {
                        let viewController = ResultViewController()
                        viewController.dataSource.resultMessage = result
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            })
        }

        var picker: UIDocumentPickerViewController?
        if #available(iOS 14.0, *) {
            if let typeBIN = UTType(filenameExtension: "bin"), let typePRN = UTType("com.brother.sdkdemo.prn") {
                picker = UIDocumentPickerViewController(forOpeningContentTypes: [typePRN, typeBIN], asCopy: true)
            }
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.archive", "com.brother.sdkdemo.prn"], in: .import)
        }
        picker?.delegate = self
        if let picker = picker {
            self.present(picker, animated: true, completion: nil)
        }
    }
}

extension PrintImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        let viewController = PrintSettingsViewController()
        viewController.dataSource.printerInfo = dataSource.printerInfo
        viewController.dataSource.image = image
        viewController.dataSource.imageType = .imageFile
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PrintImageViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        defer {
            selectPickerCallback = nil
        }
        selectPickerCallback?(urls)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        selectPickerCallback = nil
    }
}

extension PrintImageViewController: PrinterInfoSaveDelegate {
    func savePrinterInfo(info: IPrinterInfo?) {
        dataSource.printerInfo = info
    }
}
