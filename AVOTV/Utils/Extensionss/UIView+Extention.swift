
import UIKit
import SDWebImage

extension UIViewController{
    
    func redirect(vc: Any){
        let vc = UIViewController.init(nibName: (vc as! UIViewController).nibName, bundle: nil)
        Utility.topViewController()?.navigationController?.pushViewController((vc ), animated: true)
    }
}


extension UIImage{
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
    
    func resizeImage(newWidth: CGFloat) -> UIImage? {

        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func resize(withPercentage percentage: CGFloat) -> UIImage? {
        let newRect = CGRect(origin: .zero, size: CGSize(width: size.width*percentage, height: size.height*percentage))
        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 1)
        self.draw(in: newRect)
        defer {UIGraphicsEndImageContext()}
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizeTo(MB: Double) -> UIImage? {
        guard let fileSize = self.pngData()?.count else {return nil}
        let fileSizeInMB = Double(fileSize)/(1000.0*1000.0)//form bytes to MB
        let percentage = MB/fileSizeInMB
        return resize(withPercentage: CGFloat(percentage))
    }
    
    func toBase64(_ imageData:Data) -> String? {
        
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func base64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImageView {
    
    func setImage(url: String?, placeholder: UIImage? = nil) {
        if let u = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url != "" {
            self.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            self.sd_setImage(with: URL(string: u), placeholderImage: placeholder, completed: {
                (image, error, cacheType, url) in
                
                UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations:
                    {
                        self.image = image
                })
                { (completed) in
                    
                }
                if error != nil {
                    self.image = placeholder
                }
            })
        } else {
            self.image = placeholder
        }
    }
    
    func rotate(duration:Int = 5) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 3)
        rotation.duration = CFTimeInterval(duration)
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func addTapGesture(){
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        // add it to the image view;
        self.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        self.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
    }
    
}

class RoundView: UIImageView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var borderWidthh: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    override func layoutSubviews() {
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
        
    }
}


extension UIAlertController {
    func show() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let win = UIWindow(frame: UIScreen.main.bounds)
            let vc = UIViewController()
            vc.view.backgroundColor = .clear
            win.rootViewController = vc
            win.windowLevel = UIWindow.Level.alert + 1
            win.makeKeyAndVisible()
            vc.present(self, animated: true, completion: nil)
        }
    }
}


extension UIView {
    
    func shake(duration: TimeInterval = 0.3, shakeCount: Float = 6, xValue: CGFloat = 12, yValue: CGFloat = 0){
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /* SHADOW */
    @IBInspectable var shadowColor:UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var shadowOpacity:Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
            
        }
    }
    
    @IBInspectable var shadowOffset:CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    @IBInspectable var shadowRadius:CGFloat {
        set {
            layer.shadowRadius = newValue
            
        }
        get {
            return layer.shadowRadius
        }
    }
    
    
    @IBInspectable var drop_Shadow:Bool {
        set {
            if newValue {
                addShadow(radius: layer.cornerRadius)
            }
        }
        get{
            return true
        }
    }
    
    
    func roundView() {
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
    }
    
    func CurveCorner() -> Void {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    func borderView() -> Void {
        layer.borderWidth = 1
        layer.borderColor = UIColor(red:240/255, green:240/255, blue:240/255, alpha: 1).cgColor
    }
    
    
    func layoutIfNeeded(_ animated: Bool, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            }, completion: { (_) in
                completion?()
            })
        } else {
            self.layoutIfNeeded()
            completion?()
        }
    }
    
}

extension UIView {
    
    func addShadow(color: UIColor? = .black, opacity: Float = 0.3, offSet: CGSize? = CGSize(width: 0, height: 0.1), radius: CGFloat = 5, scale: Bool = true){
        
        layer.masksToBounds = false
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet!
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor? = .gray, opacity: Float = 0.3, offSet: CGSize? = CGSize(width: -1, height: 0.5), radius: CGFloat = 5, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color?.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet!
        layer.shadowRadius = radius
        
        let boun = CGRect.init(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width, height: self.bounds.size.height - 30)

        layer.shadowPath = UIBezierPath(rect: boun).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1.2
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension UIView {
    
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}


extension UISearchBar {

    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            // Fallback on earlier versions
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}


extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}



extension CAShapeLayer {
    func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
    }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func setBadge(text: String?, withOffsetFromTopRight offset: CGPoint = CGPoint.zero, andColor color:UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 11)
    {
        badgeLayer?.removeFromSuperlayer()
        
        if (text == nil || text == "" || text == "0") {
            return
        }
        
        addBadge(text: text!, withOffset: offset, andColor: color, andFilled: filled)
    }
    
    private func addBadge(text: String, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true, andFontSize fontSize: CGFloat = 11)
    {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        var font = UIFont.systemFont(ofSize: fontSize)
        
        if #available(iOS 9.0, *) {
            font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
        }
        
        let badgeSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        // Initialize Badge
        let badge = CAShapeLayer()

        let height = badgeSize.height;
        var width = badgeSize.width + 2 /* padding */
        
        //make sure we have at least a circle
        if (width < height) {
            width = height
        }

        //x position is offset from right-hand side
        let x = view.frame.width - width + offset.x
        
        let badgeFrame = CGRect(origin: CGPoint(x: x, y: offset.y + 3), size: CGSize(width: width, height: height))
        
        badge.drawRoundedRect(rect: badgeFrame, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = text
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.font = font
        label.fontSize = font.pointSize
        
        label.frame = badgeFrame
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
