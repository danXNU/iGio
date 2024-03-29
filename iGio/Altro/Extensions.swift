//
//  Extensions.swift
//  SFA
//
//  Created by Dani Tox on 14/11/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import SwiftEntryKit

extension UIDevice {
    var deviceType : UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
}

extension Notification.Name {
    static let updateTheme = Notification.Name("UPDATE_THEME")
}

extension String {
    var firstLine : String {
        if let line1 = self.components(separatedBy: .newlines).first {
            return line1
        } else {
            return self
        }
    }
    
    var wordsCount : Int {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
}

extension UIViewController {
    
    /// Mostra un alert con titolo e messaggio custom. Questa funzione agisce già nella MainQueue
    ///
    /// - Parameters:
    ///   - title: titolo dell'alert
    ///   - message: messaggio dell'alert
    func showError(withTitle title: String, andMessage message : String) {
        DispatchQueue.main.async {
            var attributes = EKAttributes.topNote
            attributes.entryBackground = .color(color: EKColor.init(.red))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
            attributes.displayDuration = 3.5

            let description = EKProperty.LabelContent(text: message, style: .init(font: UIFont.preferredFont(forTextStyle: .body), color: .white))
            
            let contentView = EKNoteMessageView(with: description)
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    func showAlert(withTitle title: String, andMessage message : String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func enableAutoHideKeyboardAfterTouch(in views: [UIView]) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        views.forEach({ $0.addGestureRecognizer(tap)})
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var isInNavigationController : Bool {
        if let _ = self.navigationController {
            return true
        } else {
            return false
        }
    }
    
    var isRootNavigationPage : Bool {
        guard let nav = self.navigationController else {
            return false
        }
        if nav.viewControllers.first == self {
            return true
        } else {
            return false
        }
    }
    
}

extension Date {
    static var monthsIntegers: ClosedRange<Int> {
        return 1...12
    }
}

extension String {
    var monthInteger: Int {
        let str = self.lowercased()
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "it")
        
        let months = calendar.monthSymbols
        
        return (months.firstIndex(of: str) ?? 0) + 1
    }
}

extension Int {
    var monthString: String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "it")
        
        let symbols = calendar.monthSymbols
        
        guard self <= symbols.count else { return "" }
        return symbols[self - 1]
    }
}


extension Date {
    
    public func advanced(by n: Int) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: 1, to: self)!
        return newDate
    }
    
    public func distance(to other: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: other).day ?? 0
    }
}

//extension ClosedRange where Bound == Date {
//    func array(advancedBy component: Calendar.Component = .day, value: Int = 1) -> [Date] {
//        let calendar = Calendar.current
//        var startingDate = self.lowerBound
//        var finishDate = self.upperBound
//
//        while startingDate <= finishDate {
//            startingDate = calendar.date(byAdding: .day, value: 1, to: startingDate) ?? finishDate
//        }
//
//        return []
//    }
//}

extension Date {
    
    static func create(from str: String) -> Date? {
        let dateF = DateFormatter()
        dateF.calendar = Calendar.current
        dateF.dateFormat = "dd/MM/yyyy"
        
        return dateF.date(from: str)
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    //    var noon: Date {
    //        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    //    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    func dayOfWeek() -> String {
        let dateF = DateFormatter()
        dateF.dateFormat = "EEEE"
        let dayEng = dateF.string(from: self).capitalized
        var dayIT : String
        switch dayEng {
        case "Monday":
            dayIT = "Lunedì"
        case "Tuesday":
            dayIT = "Martedì"
        case "Wednesday":
            dayIT = "Mercoledì"
        case "Thursday":
            dayIT = "Giovedì"
        case "Friday":
            dayIT = "Venerdì"
        case "Saturday":
            dayIT = "Sabato"
        case "Sunday":
            dayIT = "Domenica"
        default:
            dayIT = "ErroreGiorno: \(dayEng)"
        }
        return dayIT
    }
    
    var startOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.locale = Locale(identifier: "it_IT")
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return sunday //gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        
        guard let nextSunday = gregorian.date(byAdding: .day, value: 7, to: sunday) else { return nil }
        let day = gregorian.component(.day, from: nextSunday)
        let month = gregorian.component(.month, from: nextSunday)
        let year = gregorian.component(.year, from: nextSunday)
        
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return gregorian.date(from: components)
    }
    
    enum WeekDays : Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
    
    func next(weekday : WeekDays) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        let nextDayComponents = DateComponents(calendar: calendar, weekday: weekday.rawValue)
        return calendar.nextDate(after: Date(), matching: nextDayComponents, matchingPolicy: .nextTimePreservingSmallerComponents)
    }
    
    func isToday() -> Bool {
        var calendar = Calendar.current
        calendar.locale = NSLocale.current
        
        let todayStart = calendar.startOfDay(for: Date())
        let givenDateStart = calendar.startOfDay(for: self)
        
        if todayStart == givenDateStart {
            return true
        } else {
            return false
        }
    }
    
    func isYesterday() -> Bool {
        var calendar = Calendar.current
        calendar.locale = NSLocale.current
        
        let todayStart = calendar.startOfDay(for: Date())
        let givenDateStart = calendar.startOfDay(for: self)
        
        guard let realYesterday =  calendar.date(byAdding: .day, value: -1, to: todayStart) else {
            return false
        }
        
        if realYesterday == givenDateStart {
            return true
        } else {
            return false
        }
    }
    
    var stringValue : String {
        var calendar = Calendar.current
        calendar.locale = NSLocale.current
        
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
    
        return "\(day)/\(month)/\(year)"
    }
    
    var startOfDay : Date {
        var calendar = Calendar.current
        calendar.locale = NSLocale.current
        
        return calendar.startOfDay(for: self)
    }
}


extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension UIColor {
    
    static let darkGreen : UIColor = UIColor.green.darker(by: 20)!
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

extension String {
//    func image() -> UIImage? {
//        let size = CGSize(width: 40, height: 40)
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        UIColor.clear.set()
//        let rect = CGRect(origin: .zero, size: size)
//        UIRectFill(CGRect(origin: .zero, size: size))
//        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
    
    func image(with size: CGFloat = 40) -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: size) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context
        
        return image ?? UIImage()
    }
}

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        
        
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
