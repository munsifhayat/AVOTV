import Foundation
import UIKit

class Utility {
    
    func roundAndFormatFloat(floatToReturn : Float, numDecimalPlaces: Int) -> String{
        
        let formattedNumber = String(format: "%.\(numDecimalPlaces)f", floatToReturn)
        return formattedNumber
        
    }
    
    static func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    
    static func creditCardNumberCheck(range: NSRange) -> Bool{
        return range.location > 15 ? false : true
    }
    
    static func creditCardCVVCheck(range: NSRange) -> Bool{
        return range.location > 3 ? false : true
    }
    
    static func creditCardExpiryCheck(textField: UITextField, range: NSRange, string: String) -> Bool{
        
        if range.location == 0 &&  string != ""  {
            if Int(string)! > 1{
                textField.text = "0" + string + "/"
                return false
            }
            
        }
        
        
        
        if range.location == 1 && string != "" {
            let val = textField.text! + string
            let intVal = Int(val)!
            
            if intVal > 12 || intVal < 1{
                return false
            }
        }
        
        
        
        if range.length > 0 {
            return true
        }
        if string == "" {
            return false
        }
        if range.location > 4 {
            return false
        }
        var originalText = textField.text
        let replacementText = string.replacingOccurrences(of: " ", with: "")
        
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacementText)) {
            return false
        }
        
        if range.location == 2 {
            originalText?.append("/")
            textField.text = originalText
        }
        return true
        
    }
    
    static func topViewController(base: UIViewController? = (Constants.APP_DELEGATE).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    
    static func showAlert(title:String?, message:String?, buttonTitle: String? = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(buttonTitle!, comment: ""), style: .default) { _ in
            //Update status bar style
            Utility.topViewController()!.setNeedsStatusBarAppearanceUpdate()
        })
        
        alert.modalPresentationCapturesStatusBarAppearance = true
        Utility.topViewController()!.present(alert, animated: true){}
    }
    
    static func showAlert(title:String?, message:String?, buttonTitle: String? = "Ok", okTapped:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(buttonTitle!, comment: ""), style: .default) { _ in
            okTapped()
        })
        alert.modalPresentationCapturesStatusBarAppearance = true
        Utility.topViewController()!.present(alert, animated: true){}
    }
    
    static func showAlert(title:String?, message:String?, button1Title: String? = "No", noTapped:@escaping ()->(),  button2Title: String? = "Yes", yesTapped:@escaping ()->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(button1Title!, comment: ""), style: .destructive) { _ in
            noTapped()
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(button2Title!, comment: ""), style: .default) { _ in
            yesTapped()
        })
        
        alert.modalPresentationCapturesStatusBarAppearance = true
        Utility.topViewController()!.present(alert, animated: true){}
    }
    
    static func showAlert(title:String?, message:String?, button1Title: String? = "No", noTapped:@escaping ()->(),  button2Title: String? = "Yes", yesTapped:@escaping ()->(),  button3Title: String? = "Cancel", cancelTapped:@escaping ()->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(button1Title!, comment: ""), style: .default) { _ in
            noTapped()
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(button2Title!, comment: ""), style: .default) { _ in
            yesTapped()
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(button3Title!, comment: ""), style: .default) { _ in
            cancelTapped()
        })
        
        alert.modalPresentationCapturesStatusBarAppearance = true
        Utility.topViewController()!.present(alert, animated: true){}
    }
    
    static func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        
        let addAction = UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        })
        addAction.isEnabled = false
        alert.addAction(addAction)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

        // adding the notification observer here
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[0],
                                               queue: OperationQueue.main) { (notification) -> Void in
                                                
                                                if let tf =  alert.textFields?.first{
                                                    addAction.isEnabled = !tf.text!.isEmpty
                                                }
        }
        
        alert.modalPresentationCapturesStatusBarAppearance = true
        Utility.topViewController()!.present(alert, animated: true, completion: nil)
    }
    
    static func resizeImage(image: UIImage,  targetSize: CGFloat) -> UIImage {
        
        guard (image.size.width > 1024 || image.size.height > 1024) else {
            return image;
        }
        
        var newRect: CGRect = CGRect.zero;
        
        if(image.size.width > image.size.height) {
            newRect.size = CGSize(width: targetSize, height: targetSize * (image.size.height / image.size.width))
        } else {
            newRect.size = CGSize(width: targetSize * (image.size.width / image.size.height), height: targetSize)
        }
        
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 1.0)
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    class func dateToString(date:Date) -> String{
        let formatter = DateFormatter()
        // initially set the format
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myDate = formatter.string(from: date) // string date
        
        return myDate
    }
    
    class func utcToLocal(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: dateFormatter.string(from: date))
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: dt!)
        
    }
    
    static func stringToDate (_ str: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: str)
        return date!
    }
    
    static func formatDate(dateString: String, currentFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat //Your date format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        var date = dateFormatter.date(from: dateString)
        
        if (date == nil)
        {
            dateFormatter.locale = Locale(identifier: "ar_OM_POSIX")
            date = dateFormatter.date(from: dateString)
        }
        
        //if still nil due to some reason
        //return current date to avoid crash
        if date == nil
        {
            //logger
            return Date()
        }
        
        return date!
    }
    
    static func formatDateWithZeroGMT(date: Date, toDateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.string(from: date)
    }
    
    static func formatStringDateWithZeroGMT(strDate: String, toDateFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: strDate)!
    }
    
    static func getDateFrom(_ datestring:String,setLocaleIdentifier:Bool? = false)->Date {
        
        let dateFormat = ["dd MM, yyyy",
                          "MMM-yyyy",
                          "yyyy-MM-dd",
                          "yyyy-12",
                          "dd-MMM-yyyy",
                          "yyyyMMdd",
                          "yyyy/MM/dd",
                          "dd MMM yyyy",
                          "yyyy/mm/dd",
                          "yyyy-MM-dd HH:mm:ss",
                          "yyyy-MM-dd HH:mm:ss Z",
                          "yyyy-MM-dd HH:mm:ss K",
                          "yyyy-MM-dd HH:mm:ss ZZ",
                          "yyyy/MM/dd hh:mm a",
                          "MM/dd/yyyy",
                          "MM/dd/yyyy HH:mm:ss Z",
                          "MM/dd/yy HH:mm",
                          "MM/dd/yy hh:mm",
                          "MMM dd hh:mm a",
                          "h:mm a",
                          "hh:mm a",
                          "dd-MMM-yyyy","dd-MM-yyyy",
                          "yyyy/MM/dd HH:mm:ss Z",
                          "yyyy/MM/dd h:mm a",
                          "MM/dd/yyyy h:mm a",
                          "yyyy-MM-dd h:mm a",
                          "yyyy-MM-dd'T'hh:mm:ss",
                          "yyy-MM-dd HH:mmZ",// 1969-12-31 16:00-0800
                          "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd HH:mmZ",// 1970-01-01 00:00+0000
            "yyyy-MM-dd HH:mm:ss.SSSZ",// 1969-12-31 16:00:00.000-0800
            "yyyy-MM-dd HH:mm:ss.SSSZ",// 1970-01-01 00:00:00.000+0000
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",// 1969-12-31T16:00:00.000-0800
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy/MM/dd h a",
            "yyyy-MM-dd'T'HH:mm:ss","dd MMM, yyyy","HH:mm", "hh:mm:ss", "yyyy-MM-dd HH:mm:ss", "EEE, MMM dd","MM/dd/yyyy hh:mm:ss a", "yyyy-MM-dd HH:mm:a", "dd-MMM-yyyy hh:mm a","yyyy-MM-dd'T'HH:mm:ss","yyyy-MM-dd'T'HH:mm:ss.SS","yyyy-MM-dd'T'HH:mm:ss.SSS"]
        
        
        if let dateString : String = datestring as String? {
            let dateFormatter : DateFormatter = DateFormatter()
            if setLocaleIdentifier ?? false {
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            }
            
            for format in dateFormat {
                
                dateFormatter.dateFormat =  format
                if let date = dateFormatter.date(from: dateString) {
                    return (date as NSDate) as Date
                }
                
            }
        }
        return Date()
    }
    
    class func getFormattedDateString(_ date:Date, format:String)->String {
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = format//"dd-MM-yyyy"
        let myString = formatter.string(from: date)
        
        return myString
        
    }
    
    static func getFormattedDateString(_ dateString:String, format:String)->String {
        let date = getDateFrom(dateString)
        return getFormattedDateString(date, format: format)
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

}

extension UIAlertController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
