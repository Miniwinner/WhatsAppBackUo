import Foundation

func locApp(for key: String) -> String {
    return NSLocalizedString(key, tableName: "Localizable", bundle: .main, value: "", comment: "")
}

