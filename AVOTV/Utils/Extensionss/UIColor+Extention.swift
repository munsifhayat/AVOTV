import UIKit

enum Color {
    static let theme = UIColor.init(red: 234/255, green: 199/255, blue: 30/255, alpha: 1.0)
    static let navBar = UIColor.init(red: 23/255, green: 30/255, blue: 39/255, alpha: 1.0)
    static let appGrey = UIColor.init(red: 128/255, green: 131/255, blue: 136/255, alpha: 1.0)
    static let txtUnderline = UIColor.groupTableViewBackground

    static let label = UIColor.CustomColorFromHexaWithAlpha("212121", alpha: 1.0)
    static let labelMedium = UIColor.CustomColorFromHexaWithAlpha("7D7D80", alpha: 1.0)
         static let labelLight = UIColor.CustomColorFromHexaWithAlpha("BEBEBF", alpha: 1.0)
    static let textField = UIColor.black
    static let secondaryColor = UIColor.lightGray
    static let priceColor = UIColor.CustomColorFromHexaWithAlpha("D25A30", alpha: 1.0)

}

extension UIColor {
    
    //Limo
    static var AppColorSecondary : UIColor!{
        get{
            return UIColor.init(red: 240/255, green: 90/255, blue: 40/255, alpha: 1.0)
        }
    }
    
    func AppColorOrange() -> UIColor! {
       return UIColor.init(red: 234/255, green: 66/255, blue: 31/255, alpha: 1.0)
    }
    
    class func CustomColorFromHexaWithAlpha (_ hex:String, alpha:CGFloat) -> UIColor {
       var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt32 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return UIColor.gray }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        }

        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
    class func appTextColorWithAlpha(_ alpha: CGFloat) -> UIColor {
        let hex = "181647"
        return UIColor.CustomColorFromHexaWithAlpha(hex, alpha: alpha)
    }
    
    
    func with(alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}



extension UIColor {
    
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static func colorFromHex(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            
            return UIColor.magenta
        }
        
        var rgb: UInt32 = 0
        Scanner.init(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255,
                            green: CGFloat((rgb & 0x00FF00) >> 8)/255,
                            blue: CGFloat(rgb & 0x0000FF)/255,
                            alpha: 1.0)
    }
    
}



