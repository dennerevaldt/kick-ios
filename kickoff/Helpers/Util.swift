//
//  Util.swift
//  kickoff
//
//  Created by Denner Evaldt on 13/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit

class Util {
    static func convertDateFormater(date: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date)
        
        return timeStamp
    }
    
    static func convertDateFormater(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        return dateFormatter.stringFromDate(date)
    }
    
    static func convertHourFormater(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        return dateFormatter.stringFromDate(date)
    }
    
    static func getDateFormatMysql(date: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(date) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date)
        
        return timeStamp
    }
    
    static func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        newImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        return newImage
    }
}
