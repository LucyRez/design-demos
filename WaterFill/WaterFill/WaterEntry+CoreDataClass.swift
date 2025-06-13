import Foundation
import CoreData

// Класс `WaterEntry` представляет сущность в CoreData, которая хранит данные о записях потребления воды.
// Аннотация `@objc(WaterEntry)` позволяет использовать этот класс в Objective-C, если это необходимо.
//
@objc(WaterEntry)
public class WaterEntry: NSManagedObject {
    // Класс наследуется от `NSManagedObject`, что делает его управляемым объектом CoreData.
    // Это означает, что экземпляры этого класса могут сохраняться, загружаться и управляться CoreData.
}
