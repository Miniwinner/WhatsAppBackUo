import Foundation
import AVKit

final class DataFromWhatsUP {
    
    private let fileManager = FileManager.default
    private let parser = DataParser()
    var db: DbRequests?
    
    func startData(_ url: URL) {
        Task {
            do {
                try parseDialogue(url)
            }
            catch {
                print(error)
            }
        }
    }
    
    init(db: DbRequests? = nil) {
        self.db = db
        print("parser data inited")
    }
    
    deinit {
        print("parser data deinited")
    }

    private func parseDialogue(_ url: URL) throws {
        var rewrite: Bool = false
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        print("found")
        
        let archiveName = url.deletingPathExtension().lastPathComponent
        
        let cleanedName = archiveName.replacingOccurrences(of: "WhatsApp Chat - ", with: "")
        let dialogueName: String
        
//        if cleanedName.contains("-") {
//            let components = cleanedName.components(separatedBy: "-")
//            if let lastComponent = components.last, Int(lastComponent) != nil {
//                dialogueName = components.dropLast().joined(separator: "-")
//            } else {
//                dialogueName = cleanedName
//            }
//        } else {
//            dialogueName = cleanedName
//        }
        if cleanedName.contains("-") {
            let components = cleanedName.components(separatedBy: "-")
            
            let cleanedComponents = components.map { $0.replacingOccurrences(of: " ", with: "") }
            
            if let lastComponent = cleanedComponents.last, Int(lastComponent) != nil {
                dialogueName = cleanedComponents.dropLast().joined(separator: "-")
            } else {
                dialogueName = cleanedComponents.joined(separator: "-")
            }
        } else {
            dialogueName = cleanedName.replacingOccurrences(of: " ", with: "")
        }
        
        let mainDestination = documentsURL.appendingPathComponent("WhatsUPUnzipped")
        let dialogueFolder = mainDestination.appendingPathComponent(dialogueName)
        
        if fileManager.fileExists(atPath: dialogueFolder.path) {
            do {
                print("Удаляем старую копию: \(dialogueFolder.path)")
                try fileManager.removeItem(at: dialogueFolder)
                rewrite = true
            } catch {
                print("Ошибка при удалении старой папки: \(error)")
            }
        }
        
        do {
            try fileManager.createDirectory(at: dialogueFolder, withIntermediateDirectories: true)
            print("Создана подпапка для диалога: \(dialogueFolder.path)")
            
            try fileManager.unzipItem(at: url, to: dialogueFolder)
            print("Архив успешно распакован в: \(dialogueFolder.path)")
        } catch {
            print("Ошибка при создании папки или распаковке архива: \(error)")
        }
        
        try prepareData(destination: dialogueFolder, reWrite: rewrite)
    }

    private func prepareData(destination: URL, reWrite: Bool) throws {
        var messages: [MessageModel] = []
        var mediaPaths: [String] = []
        var documentsPaths: [String] = []
        do {
            let files = try fileManager.contentsOfDirectory(at: destination, includingPropertiesForKeys: nil)
            for file in files {
                let finalPath = "WhatsUPUnzipped/\(destination.lastPathComponent)/\(file.lastPathComponent)"
                switch file.pathExtension.lowercased() {
                case "txt":
                    documentsPaths.append(finalPath)
                    print(file.lastPathComponent)
                    if file.lastPathComponent == "_chat.txt" {
                        let content = try String(contentsOf: file, encoding: .utf8)
                        messages = parser.parseContent(content: content, destination: destination.lastPathComponent)
                        print(messages)
                    }
                case "jpg", "jpeg", "png", "gif", "bmp", "tiff","mp4", "mov", "avi", "mkv", "webm","mp3", "wav", "m4a", "aac", "flac", "opus":
                    mediaPaths.append(finalPath)
                    documentsPaths.append(finalPath)
                default:
                    print("Unknown media type for file: \(file.pathExtension)")
                    documentsPaths.append(finalPath)
               
                }
            }
            let dialogue = DialogueModel(id: UUID(),
                                         participants: [destination.lastPathComponent,"SELF"],
                                         messages: messages,
                                         mediaPaths: mediaPaths,
                                         documentPaths: documentsPaths,
                                         lastmessdate: messages.last?.timestamp ?? Date(),
                                         lastMessage: messages.last?.content ?? "NO MESS")
            do {
                try db?.saveMessages(dialogue,rewrite: reWrite)
                SceneManager.shared.firstLaunch = false
            } catch {
                print("error saving in  coredata - \(error)")
            }
        }
        catch {
            print(error)
        }
        
    }
    
    
    
    
    
    
    
}

final class DataParser {
    
    init() {
        print("inited parser message")
    }
    
//    func parseContent(content: String) -> [MessageModel] {
//        var parsedMessages: [MessageModel] = []
//        let pattern = #"^\[(\d{1,2}\.\d{1,2}\.\d{2}), (\d{2}:\d{2}:\d{2})\] (.*?): (.*)$"#
//
//        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
//        let lines = content.components(separatedBy: .newlines)
//        for line in lines {
//            let range = NSRange(line.startIndex..<line.endIndex, in: line)
//            if let match = regex.firstMatch(in: line, options: [], range: range) {
//                let dateString = String(line[Range(match.range(at: 1), in: line)!])
//                let timeString = String(line[Range(match.range(at: 2), in: line)!])
//                let sender = String(line[Range(match.range(at: 3), in: line)!])
//                let content = String(line[Range(match.range(at: 4), in: line)!])
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "d.M.yy, HH:mm:ss"
//                let date = dateFormatter.date(from: "\(dateString), \(timeString)") ?? Date()
//                let contentType: ContentType
//                if content.contains("<attached:") {
//                    contentType = .media
//                    print("content media")
//                } else {
//                    contentType = .text
//                }
//                print("content - \(content)\n\n")
//                let message = MessageModel(id: UUID(),
//                                           sender: sender,
//                                           content: content,
//                                           contentType: contentType,
//                                           timestamp: date)
//                parsedMessages.append(message)
//            }
//        }
//        return parsedMessages
//    }
    
   
    func parseContent(content: String, destination: String) -> [MessageModel] {
        var messages: [MessageModel] = []
        
        // Регулярное выражение для парсинга строки сообщения
        let messagePattern = #"\[(\d{2}\.\d{2}\.\d{2}), (\d{2}:\d{2}:\d{2})\] (\w+): (.+)"#
        let regex = try! NSRegularExpression(pattern: messagePattern, options: [])
        
        // Разделяем текст лога на строки
        let logLines = content.components(separatedBy: "\n")
        
        // Форматтер для преобразования строки в дату
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm:ss"
        
        for line in logLines {
            let range = NSRange(line.startIndex..<line.endIndex, in: line)
            
            if let match = regex.firstMatch(in: line, options: [], range: range) {
                if let dateRange = Range(match.range(at: 1), in: line),
                   let timeRange = Range(match.range(at: 2), in: line),
                   let senderRange = Range(match.range(at: 3), in: line),
                   let contentRange = Range(match.range(at: 4), in: line) {
                    
                    let date = String(line[dateRange])
                    let time = String(line[timeRange])
                    let sender = String(line[senderRange])
                    var content = String(line[contentRange])
                    let copyContent = content
                    let timestampString = "\(date) \(time)"
                    
                    // Создаем объект Date
                    if let timestamp = dateFormatter.date(from: timestampString) {
                        let contentType: ContentType = (content.lowercased().contains("omitted") || content.contains("<attached:")) ? .media : .text
                        if contentType == .media {
                            let pathWithoutAttach = formatAttachedPath(from: copyContent)
                            content = "WhatsUPUnzipped/\(destination)/\(pathWithoutAttach ?? "123")"
                        }
                        let message = MessageModel(
                            id: UUID(),
                            sender: sender,
                            content: content,
                            contentType: contentType,
                            timestamp: timestamp
                        )
                        messages.append(message)
                    }
                }
            }
        }
        
        return messages
    }

   


    
    deinit {
        print("message parser deineted")
    }
    
    
    
}



