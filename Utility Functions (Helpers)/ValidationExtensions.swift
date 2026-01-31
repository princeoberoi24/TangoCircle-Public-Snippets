//
//  ValidationExtensions.swift
//  TaskTango
//
//  Created by Apple on 25/12/25.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        // This regex pattern strictly requires an "@" symbol and a domain part
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
