//
//  DateExtension.swift
//  Todo_EM
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 27.01.2025.
//

import Foundation

extension Date {
    func formattedDate(style: String = "dd/MM/yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style
        return formatter.string(from: self)
    }
}

