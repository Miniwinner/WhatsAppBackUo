import Foundation
import ImageIO
import MobileCoreServices

func timeAgoSinceDate(_ date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)
    
    if let year = components.year, year > 0 {
        return "\(year) year(s) ago"
    }
    
    if let month = components.month, month > 0 {
        return "\(month) month(s) ago"
    }
    
    if let day = components.day, day > 0 {
        return "\(day) day(s) ago"
    }
    
    if let hour = components.hour, hour > 0 {
        return "\(hour) hour(s) ago"
    }
    
    if let minute = components.minute, minute > 0 {
        return "\(minute) minute(s) ago"
    }
    
    return "Just now"
}

import Foundation

func formatMessageDate(date: Date) -> String {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let messageDate = calendar.startOfDay(for: date)
    
    // Если сообщение было сегодня
    if calendar.isDateInToday(date) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" // Формат времени
        return "Today at \(timeFormatter.string(from: date))"
    }
    
    // Если сообщение было вчера
    if calendar.isDateInYesterday(date) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" // Формат времени
        return "Yesterday at \(timeFormatter.string(from: date))"
    }
    
    // Для всех других случаев (старые сообщения)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM dd" // Например, "December 13"
    return dateFormatter.string(from: date)
}

func compareDays(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    
    // Сравниваем только день, месяц и год
    let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
    let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
    
    return components1 != components2
}


func extractAndFormatDate(from path: String) -> String? {
    // Регулярное выражение для поиска даты в формате YYYY-MM-DD-HH-MM-SS
    let pattern = #"(\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2})"#
    
    // Находим дату в пути
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
    let range = NSRange(path.startIndex..<path.endIndex, in: path)
    
    if let match = regex.firstMatch(in: path, range: range),
       let dateRange = Range(match.range, in: path) {
        let dateString = String(path[dateRange])
        
        // Создаём DateFormatter для разбора исходной даты
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Стандартизированная локаль
        
        // Конвертируем строку в Date
        if let date = inputFormatter.date(from: dateString) {
            // Создаём другой DateFormatter для нужного формата
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM, yyyy HH:mm"
            outputFormatter.locale = Locale(identifier: "ru_RU") // Русская локаль
            
            return outputFormatter.string(from: date)
        }
    }
    return nil
}

func formattedTime(from seconds: Double) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = .pad
    return formatter.string(from: seconds) ?? "0:00"
}


func formatToSecs(from seconds: Double) {
    
}
