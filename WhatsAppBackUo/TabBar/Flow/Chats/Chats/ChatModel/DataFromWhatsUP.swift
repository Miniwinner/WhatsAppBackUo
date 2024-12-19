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
        
        if cleanedName.contains("-") {
            let components = cleanedName.components(separatedBy: "-")
            if let lastComponent = components.last, Int(lastComponent) != nil {
                dialogueName = components.dropLast().joined(separator: "-")
            } else {
                dialogueName = cleanedName
            }
        } else {
            dialogueName = cleanedName
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
        var mediaCount: Int = 0
        var mediaPaths: [String] = []
        do {
            let files = try fileManager.contentsOfDirectory(at: destination, includingPropertiesForKeys: nil)
            for file in files {
                switch file.pathExtension.lowercased() {
                case "txt":
                    let content = try String(contentsOf: file, encoding: .utf8)
                    messages = parser.parseContent(content: content)
                    mediaCount += 1
                    let finalPath = "WhatsUPUnzipped/\(destination.lastPathComponent)/\(file.lastPathComponent)"
                    mediaPaths.append(finalPath)
                default:
                    mediaCount += 1
                    let finalPath = "WhatsUPUnzipped/\(destination.lastPathComponent)/\(file.lastPathComponent)"
                    print(finalPath)
                    mediaPaths.append(finalPath)
                }
            }
           
            let dialogue = DialogueModel(id: UUID(),
                                         participants: [destination.lastPathComponent,"SELF"],
                                         messages: messages,
                                         mediaPaths: mediaPaths,
                                         mediaCount: mediaCount,
                                         lastmessdate: messages.last?.timestamp ?? Date(),
                                         lastMessage: messages.last?.content ?? "NO MESS")
            do {
                try db?.saveMessages(dialogue,rewrite: reWrite)
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
    
    func parseContent(content: String) -> [MessageModel] {
        var parsedMessages: [MessageModel] = []
        let pattern = #"^\[(\d{1,2}\.\d{1,2}\.\d{2}), (\d{2}:\d{2}:\d{2})\] (.*?): (.*)$"#
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        let lines = content.components(separatedBy: .newlines)
        for line in lines {
            let range = NSRange(line.startIndex..<line.endIndex, in: line)
            if let match = regex.firstMatch(in: line, options: [], range: range) {
                let dateString = String(line[Range(match.range(at: 1), in: line)!])
                let timeString = String(line[Range(match.range(at: 2), in: line)!])
                let sender = String(line[Range(match.range(at: 3), in: line)!])
                let content = String(line[Range(match.range(at: 4), in: line)!])
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d.M.yy, HH:mm:ss"
                let date = dateFormatter.date(from: "\(dateString), \(timeString)") ?? Date()
                let contentType: ContentType
                if content.contains("<attached:") {
                    contentType = .media
                } else {
                    contentType = .text
                }
                let message = MessageModel(id: UUID(),
                                           sender: sender,
                                           content: content,
                                           contentType: contentType,
                                           timestamp: date)
                parsedMessages.append(message)
            }
        }
        return parsedMessages
    }
    
    deinit {
        print("message parser deineted")
    }
    
    
    
}



