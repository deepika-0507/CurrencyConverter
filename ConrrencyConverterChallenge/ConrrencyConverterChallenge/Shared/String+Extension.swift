//
//  String+Extension.swift
//  ConrrencyConverterChallenge
//
//  Created by Deepika Ponnaganti on 17/01/24.
//

import Foundation

extension String {
   var isNumeric: Bool {
     return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
   }
}
