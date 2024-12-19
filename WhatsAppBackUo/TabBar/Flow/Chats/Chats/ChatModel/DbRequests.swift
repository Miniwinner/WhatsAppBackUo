import CoreData
import UIKit



class DbRequests {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    weak var presenter: PresentLogic?
    
    var parent: String = "None"
    
    init(presenter: PresentLogic? = nil, parent: String) {
        self.presenter = presenter
        self.parent = parent
        print("DB inited from \(self.parent)")
    }
    
    deinit {
        print("DB deinited \(parent)")
    }
    
    func saveMessages(_ dialogue: DialogueModel, rewrite: Bool = false) throws {
        let fetchRequest: NSFetchRequest<Dialogue> = Dialogue.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "participants == %@", dialogue.participants.joined(separator: ", "))
        
        do {
            if rewrite {
                let results = try context.fetch(fetchRequest)
                for oldDialogue in results {
                    context.delete(oldDialogue)
                }
                print("Старый диалог и связанные сообщения удалены.")
            }
            
            let dialogueEntity = NSEntityDescription.insertNewObject(forEntityName: "Dialogue", into: context) as! Dialogue
            dialogueEntity.id = dialogue.id
            dialogueEntity.participants = dialogue.participants.joined(separator: ", ")
            dialogueEntity.mediaCount = Int32(dialogue.mediaCount)
            dialogueEntity.date = dialogue.lastmessdate
            dialogueEntity.paths = dialogue.mediaPaths.joined(separator: ", ")
            
            dialogueEntity.lastmess = dialogue.lastMessage
        
            for message in dialogue.messages {
                let messageEntity = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
                messageEntity.id = message.id
                messageEntity.sender = message.sender
                messageEntity.content = message.content
                messageEntity.contentType = message.contentType.rawValue
                messageEntity.timeStamp = message.timestamp
                dialogueEntity.addToMessages(messageEntity)
            }
            
            try context.save()
            print("Диалог успешно сохранён: \(dialogue.participants)")
            UserDefaults.standard.set(true, forKey: "dataLoaded")
            presenter?.presentNewData()
        } catch {
            print("Ошибка при сохранении диалога: \(error)")
            throw error
        }
    }


    
    func fetchAllDialogues() -> [DialogueModel] {
            let fetchRequest: NSFetchRequest<Dialogue> = Dialogue.fetchRequest()
            
            do {
                let dialogues = try context.fetch(fetchRequest)
                var dialogueModels: [DialogueModel] = []
                
                for dialogueEntity in dialogues {
                    let participants = dialogueEntity.participants?.components(separatedBy: ", ") ?? []
                    let paths = dialogueEntity.paths?.components(separatedBy: ", ") ?? []
                    let messages = extractMessages(from: dialogueEntity)
                    let sortedMessages = messages.sorted { $0.timestamp < $1.timestamp }
                    let dialogueModel = DialogueModel(
                        id: dialogueEntity.id ?? UUID(),
                        participants: participants,
                        messages: sortedMessages,
                        mediaPaths: paths,
                        mediaCount: Int(dialogueEntity.mediaCount),
                        lastmessdate: dialogueEntity.date ?? Date(),
                        lastMessage: dialogueEntity.lastmess ?? "1"
                        
                    )
                    
                    dialogueModels.append(dialogueModel)
                }
                
                return dialogueModels
            } catch {
                print(error)
                return []
                 
            }
        }
        
        private func extractMessages(from dialogueEntity: Dialogue) -> [MessageModel] {
            var messageModels: [MessageModel] = []
            
            if let messageEntities = dialogueEntity.messages?.allObjects as? [Message] {
                for messageEntity in messageEntities {
                    let messageModel = MessageModel(
                        id: messageEntity.id ?? UUID(),
                        sender: messageEntity.sender ?? "",
                        content: messageEntity.content ?? "",
                        contentType: ContentType(rawValue: messageEntity.contentType ?? "") ?? .text,
                        timestamp: messageEntity.timeStamp ?? Date()
                    )
                    
                    messageModels.append(messageModel)
                }
            }
            
            return messageModels
        }
}
