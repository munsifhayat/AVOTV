import UIKit

struct Constants{
    
    static let appName = "Commec TV"
    
    static let bundleId = "com.app.avotv"
    
    /** BASE URL */
    static let baseURL =  "https://api.commec.tv/api/v1/"  //"http://api.comafrica.tv/api/v1/"

    /** BASE Image URL */
    static let baseImageURL = "https://api.commec.tv/api/v1/"       ///"http://tvapi.idispatch.us/api/v1/"
    
    static let google_API_key = "AIzaSyBivGn5V2g0hbVfoquLKYdR06pysLodmUY"
    
    /** API Request Timeout time */
    static let apiRequestTimeoutInterval = 120
    
    static let USER_DEFAULTS = UserDefaults.standard
    
    static let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    
    static let app_color = #colorLiteral(red: 0.09803921569, green: 0.7098039216, blue: 0.5843137255, alpha: 1)
    
    static let background_color = #colorLiteral(red: 0.2078431373, green: 0.2156862745, blue: 0.2156862745, alpha: 1)
}


struct AppFonts{
    static let Regular = "altehaasgroteskregular"
//    static let Medium = "Roboto-Medium"
//    static let SemiBold = "altehaasgroteskbold"
    static let Bold = "altehaasgroteskbold"
}

struct ValidatorMessages{
    static let RequireField = NSLocalizedString("This field is required", comment: "")
    static let InvalidEmail = NSLocalizedString("Please enter a valid email address", comment: "")
    static let InvalidEmailPhone = NSLocalizedString("Invalid username/mobile no.", comment: "")
    static let ShortPassword = NSLocalizedString("Password should be atleast 6 character long", comment: "")
    static let InvalidPhone = NSLocalizedString("Phone number must be numeric with at", comment: "")
    static let InvalidName = NSLocalizedString("Please enter a valid name", comment: "")
    static let InvalidCurrentAddress = NSLocalizedString("Please enter a valid current address", comment: "")
    static let InvalidPhoneNumber = NSLocalizedString("Please enter a valid mobile number", comment: "")
    static let InvalidZibCode = NSLocalizedString("Please enter a valid zip code", comment: "")
    static let InvalidInvitationCode = NSLocalizedString("Please enter a valid invitation code", comment: "")
    static let ConfirmPassword = NSLocalizedString("Password do not match", comment: "")
    static let MinLength = NSLocalizedString("Invalid Length", comment: "")
    static let MaxLength = NSLocalizedString("Invalid Length", comment: "")
    static let Invalid = NSLocalizedString("Please enter a valid data", comment: "")
}


struct PopupMessage {
    static let FeedbackSent = NSLocalizedString("Thank you! Your message has been sent successfully. We'll get back to you soon.", comment: "")
    static let LateFeature = NSLocalizedString("Not Implemented as yet.", comment: "")

    static let PasswordChanged = NSLocalizedString("An email has been sent to your account with new password.", comment: "")
    static let PasswordChangedSuccess = NSLocalizedString("Password changed successfully.", comment: "")
    static let InternetOffline = NSLocalizedString("Internet connection seems to be offline", comment: "")
    static let Password_Changed_Succesfully = NSLocalizedString("Password changed successfully!", comment: "")
    static let Profile_Changed_Succesfully = NSLocalizedString("Profile updated successfully!", comment: "")
}
