//
//  PrintImageViewModel.swift
//  Brother Print SDK Demo
//
//  Created by Brother Industries, Ltd. on 2022/12/20.
//

import Foundation

class PrintImageViewModel: ObservableObject {
    @Published var printerInfo: IPrinterInfo?
    private let printImageFacade = PrintImageFacade()

    // start print
    func startPrint(
        urls: [URL],
        imageType: ImagePrnType,
        callback: @escaping(String) -> Void
    ) {
        guard let info = printerInfo else {
            return
        }
        DispatchQueue.global().async { [self] in
            var result = ""
            switch imageType {
            case .imageFile, .imageURL, .imageURLs: break
            case .prnFile:
                if let url = urls.first {
                    result = self.printImageFacade.printPRNWithURL(info: info, url: url)
                }
            case .prnFiles:
                result = self.printImageFacade.printPRNWithURLs(info: info, urls: urls)
            case .rawData:
                if let url = urls.first,
                   let data = FileManager.default.contents(atPath: url.path) {
                    result = self.printImageFacade.printPRNWithData(info: info, data: data)
                }
            }
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }

    func cancelPrinting() {
        printImageFacade.cancelPrinting()
    }
}
