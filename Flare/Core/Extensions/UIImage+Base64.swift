import UIKit

extension UIImage {
    static func fromBase64(_ base64String: String) -> UIImage? {
        let cleanString: String
        if base64String.hasPrefix("data:image") {
            let components = base64String.components(separatedBy: ",")
            if components.count > 1 {
                cleanString = components[1]
            } else {
                return nil
            }
        } else {
            cleanString = base64String
        }
        
        guard let data = Data(base64Encoded: cleanString) else { return nil }
        return UIImage(data: data)
    }
}
