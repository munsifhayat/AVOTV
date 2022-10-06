import Foundation

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        formatter.dateFormat = "dd MMM yyyy"
        return  formatter.string(from: self)
    }
    
    
    var year: String {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        formatter.dateFormat = "yy"
        return  formatter.string(from: self)
    }
    
    var month: String {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        formatter.dateFormat = "MM"
        return  formatter.string(from: self)
    }
    
    var serverString: String {
        return self.stringValue(format: "dd-MMM-yyyy HH:mm")
    }
    
    var dayInt:Int
    {
        return Calendar.current.component(.day, from:self)
        
    }
    
    var monthInt:Int
    {
        return Calendar.current.component(.month, from:self)
        
    }
    
    var yearInt:Int
    {
        return Calendar.current.component(.year, from:self)
        
    }
    
}



extension String {
    func localToUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        print(self)
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        print(dateFormatter.string(from: dt!))
        return dateFormatter.string(from: dt!)
    }
    
    func UTCToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    func dateValue(format: String, timeZone: TimeZone? = TimeZone(abbreviation: "GMT")) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
    var isNumeric: Bool {
        return isEmpty || range(of: "[^0-9]", options: .regularExpression) == nil
    }
}

extension Date {
    func dateToString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    func stringValue(format: String, timeZone: TimeZone? = TimeZone(abbreviation: "GMT")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    
    var timeStamp: String {
        return "KORSA\(self.timeIntervalSince1970 * 100000)"
    }
    
    var isCurrentDay: Bool {
        return Date().stringValue(format: "yyyy-MM-dd", timeZone: .current) == self.stringValue(format: "yyyy-MM-dd", timeZone: .current)
    }
    var isCurrentMonth: Bool {
        return Date().stringValue(format: "yyyy-MM", timeZone: .current) == self.stringValue(format: "yyyy-MM", timeZone: .current)
    }
    var isCurrentYear: Bool {
        return Date().stringValue(format: "yyyy", timeZone: .current) == self.stringValue(format: "yyyy", timeZone: .current)
    }
    
}


extension Date {
    func getElapsedInterval() -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
        // IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN
        // WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE
        // (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME
        // IS GOING TO APPEAR IN SPANISH
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar
        
        var dateString: String?
        
        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            formatter.allowedUnits = [.year] //2 years
        } else if let month = interval.month, month > 0 {
            formatter.allowedUnits = [.month] //1 month
        } else if let week = interval.weekOfYear, week > 0 {
            formatter.allowedUnits = [.weekOfMonth] //3 weeks
        } else if let day = interval.day, day > 0 {
            formatter.allowedUnits = [.day] // 6 days
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            
            dateString = dateFormatter.string(from: self) // IS GOING TO SHOW 'TODAY'
        }
        
        if dateString == nil {
            dateString = formatter.string(from: self, to: Date())
        }
        
        return dateString!
    }
    
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Week
        if let interval = Calendar.current.dateComponents([.weekOfMonth], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "week ago" : "\(interval)" + " " + "weeks ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}
