//
//  String+HTML.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/21/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
        func htmlAttributedString() -> NSAttributedString? {
            guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
            guard let html = try? NSMutableAttributedString(
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil) else { return nil }
            return html
        }
    
    private var convertHtmlToNSAttributedString: NSAttributedString? {
           guard let data = data(using: .utf8) else {
               return nil
           }
           do {
               return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
           }
           catch {
               print(error.localizedDescription)
               return nil
           }
       }
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
    }
