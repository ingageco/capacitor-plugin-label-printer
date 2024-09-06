import Foundation

@objc public class CapacitorPluginLabelPrinter: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
