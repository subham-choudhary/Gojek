
import Foundation

class DataManager {
//    static let shared = DataManager()
//
//    private init() {}
//
    static var contacts: [Contact] {
        get {
            return (UserDefaults.standard.object(forKey: "com.contacts")) as? [Contact] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "com.contacts")
        }
    }
}
