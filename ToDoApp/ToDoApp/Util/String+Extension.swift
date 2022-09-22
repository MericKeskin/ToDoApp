//
//  String+Extension.swift
//  ToDoApp
//
//  Created by Meriç Keskin on 22.09.2022.
//

import Foundation

extension String {
    static func getFormattedDate(string: String , formatter: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter

        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!);
    }
}
