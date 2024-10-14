//
//  Date+Extension.swift
//  Hitrav
//
//  Created by Hamed Pouramiri on 8/23/20.
//  Copyright © 2020 Pixel. All rights reserved.
//

import Foundation

extension Date {

    func toStringFormatWithEnglishLocale(format: String = "MMMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.locale = LanguageManager.SupportedLanguage.english.info.locale
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "Europe/Istanbul")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func toStringFormat(format: String = "MMMM yyyy", englishLocale: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.locale = englishLocale ? LanguageManager.SupportedLanguage.english.info.locale : LanguageManager.shared.locale
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "Europe/Istanbul")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }

    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }

    func addMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }

    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }

    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }

    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]

        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }

    func timeSinceNow() -> String {
        guard self < Date() else { return "Back to the future" }
        let preferredLanguages = LanguageManager.shared.preferredLanguages
        let allComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components: DateComponents = Calendar.current.dateComponents(allComponents, from: self, to: Date())
        let times = [
            (Localizable.year(preferredLanguages: preferredLanguages), components.year ?? 0),
            (Localizable.month(preferredLanguages: preferredLanguages), components.month ?? 0),
            (Localizable.week(preferredLanguages: preferredLanguages), components.weekOfYear ?? 0),
            (Localizable.day(preferredLanguages: preferredLanguages), components.day ?? 0),
            (Localizable.hourLowerCase(preferredLanguages: preferredLanguages), components.hour ?? 0),
            (Localizable.minute(preferredLanguages: preferredLanguages), components.minute ?? 0),
            (Localizable.second(preferredLanguages: preferredLanguages), components.second ?? 0)
        ]
        for (period, timeAgo) in times  where timeAgo > 0 {
            return "\(timeAgoFormat(timeAgo, period)) " + Localizable.ago(preferredLanguages: preferredLanguages)
        }

        return Localizable.justNow(preferredLanguages: preferredLanguages)
    }

    private func timeAgoFormat(_ time: Int, _ period: String) -> String {
        guard !LayoutDirectionManager.switchToRTL else { return "\(time) \(period)" }
        guard time != 1 else { return "\(time) \(period)" }
        return "\(time) \(period)s"
    }
}
