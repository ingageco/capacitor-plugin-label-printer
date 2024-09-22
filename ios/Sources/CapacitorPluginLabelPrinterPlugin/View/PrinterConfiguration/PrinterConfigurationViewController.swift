//
//  PrinterConfigurationViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/9.
//

import BRLMPrinterKit
import SwiftUI
import UIKit

class PrinterConfigurationViewController: UIViewController {
    private var dataSource = PrinterConfigurationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = PrinterConfigurationView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("printer_config", comment: "")
    }

    private func showWaitingAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("waiting", comment: ""),
                                                message: nil, preferredStyle: .alert)
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
}

extension PrinterConfigurationViewController: PrinterConfigurationViewDelegate {
    func showEmptyListAlert() {
        let alert = UIAlertController(title: NSLocalizedString("error_not_select_configuration", comment: ""),
                                                message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

    func setButtonDidTap() {
        self.showWaitingAlert()
        dataSource.setPrinterConfigurations(callback: { result in
            self.showResult(result: result)
        })
    }

    func fetchConfigurations() {
        self.showWaitingAlert()
        dataSource.fetchPrinterConfigurations(callback: { result in
            self.showResult(result: result)
        })
    }

    func selectPrinterButtonDidTap() {
        let viewController = PrinterInterfaceViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func selectItemDidTap(item: PrinterSettingItem?, value: String?) {
        if let item = item, let value = value {
            dataSource.setItemData(key: item, value: value)
        }
    }

    func showConnectPrinterAlert() {
        let alert = CommonAlertUtil.connectPrinterAlert()
        self.present(alert, animated: true)
    }

    func editItemDidTap(item: PrinterSettingItem, message: String) {
        let valueMessage = message == NSLocalizedString("text_no_data", comment: "") ? "" : message
        let alert = CommonAlertUtil.editAlert(
            title: item.name,
            message: valueMessage,
            keyboardType: .default,
            delegate: nil,
            callback: { value in
                self.dataSource.setItemData(key: item, value: value)
            }
        )
        self.present(alert, animated: true)
    }
}

extension PrinterConfigurationViewController: PrinterInfoSaveDelegate {
    func savePrinterInfo(info: IPrinterInfo?) {
        dataSource.printerInfo = info
    }
}
