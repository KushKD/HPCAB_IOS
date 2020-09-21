//
//  String+HTML.swift
//  eCabinet1.0
//
//  Created by HP-DIT on 9/21/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

extension String {
        func htmlAttributedString() -> NSAttributedString? {
            guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
            guard let html = try? NSMutableAttributedString(
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil) else { return nil }
            return html
        }
    }
