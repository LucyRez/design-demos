import Foundation
import CoreData

// Расширение для сущности `WaterEntry`, которая представляет запись о потреблении воды.
extension WaterEntry {
    // Статический метод для создания запроса на выборку данных из CoreData
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaterEntry> {
        // Возвращает запрос для выборки объектов типа `WaterEntry` из CoreData.
        return NSFetchRequest<WaterEntry>(entityName: "WaterEntry")
    }

    // Атрибуты сущности `WaterEntry`, управляемые CoreData.
    @NSManaged public var amount: Double // Количество выпитой воды
    @NSManaged public var date: Date? // Дата, когда была сделана запись
}

// Расширение для соответствия протоколу `Identifiable`
// Позволяет использовать `WaterEntry` в SwiftUI, где требуется идентификация объектов
extension WaterEntry : Identifiable {
}
