//
//  GetDeleteTemplateViewController.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2023/2/8.
//

import SwiftUI
import UIKit

class GetDeleteTemplateViewController: UIViewController {
    private var dataSource = GetDeleteTemplateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = GetDeleteTemplateView(delegate: self, dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = NSLocalizedString("get_delete_templates", comment: "")
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

extension GetDeleteTemplateViewController: GetDeleteTemplateViewDelegate {
    func selectPrinterButtonDidTap() {
        let viewController = PrinterInterfaceViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func showConnectPrinterAlert() {
        let alert = CommonAlertUtil.connectPrinterAlert()
        self.present(alert, animated: true)
    }

    func requestTemplateListDidTap() {
        guard self.showConnectionAlertIfNeeded() else { return }
        let alert = UIAlertController(title: NSLocalizedString("waiting", comment: ""), message: nil, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.global().async {
            let result = self.dataSource.fetchTemplateList()
            DispatchQueue.main.async {
                if let alert = self.presentedViewController as? UIAlertController {
                    alert.dismiss(animated: false) {
                        let viewController = ResultViewController()
                        viewController.dataSource.resultMessage = result.message
                        viewController.dataSource.templateList = result.list
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
    }

    func deleteTemplateDidTap(number: String) {
        guard dataSource.setKeyList(number: number) else { return }
        let alert = UIAlertController(title: NSLocalizedString("waiting", comment: ""), message: nil, preferredStyle: .alert)
        self.present(alert, animated: true) {
            self.dataSource.deleteTemplateList(callback: { result in
                if let alert = self.presentedViewController as? UIAlertController {
                    alert.dismiss(animated: false) {
                        let viewController = ResultViewController()
                        viewController.dataSource.resultMessage = result
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            })
        }
    }
}

extension GetDeleteTemplateViewController: PrinterInfoSaveDelegate {
    func savePrinterInfo(info: IPrinterInfo?) {
        dataSource.printerInfo = info
    }
}
