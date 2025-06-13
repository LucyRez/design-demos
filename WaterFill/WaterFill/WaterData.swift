import SwiftUI
import CoreData

// Класс `WaterData` управляет данными о потреблении воды и взаимодействует с CoreData.
class WaterData: ObservableObject {
    // Опубликованные свойства, которые автоматически обновляют UI при изменении.
    @Published var currentAmount: Double = 0.0 // Текущее количество выпитой воды.
    @Published var dailyGoal: Double = 2000.0 // Дневная цель по потреблению воды.
    @Published var history: [WaterEntry] = [] // История записей о потреблении воды.

    // Контекст CoreData для управления объектами.
    private let context: NSManagedObjectContext

    // Инициализатор класса, принимающий контекст CoreData.
    init(context: NSManagedObjectContext) {
        self.context = context
        print("WaterData initialized with context: \(context)")
        loadData() // Загрузка данных при инициализации.
    }

    // Функция для добавления новой записи о выпитой воде.
    func addWater(amount: Double) {
        // Создание новой записи в CoreData.
        let newEntry = WaterEntry(context: context)
        newEntry.amount = amount // Установка количества воды.
        newEntry.date = Date() // Установка текущей даты.

        saveData() // Сохранение данных в CoreData.
        loadData() // Обновление данных после добавления записи.
    }

    // Функция для сброса всех данных.
    func resetData() {
        currentAmount = 0.0 // Сброс текущего количества воды.

        // Создание запроса на удаление всех записей из CoreData.
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = WaterEntry.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest) // Выполнение запроса на удаление.
            saveData() // Сохранение изменений.
        } catch {
            print("Ошибка при удалении данных: \(error)") // Обработка ошибок.
        }
    }

    // Функция для обновления текущего количества воды.
    func updateCurrentAmount() {
        loadData() // Загрузка данных для обновления.
    }

    // Приватная функция для сохранения данных в CoreData.
    private func saveData() {
        do {
            try context.save() // Сохранение контекста.
        } catch {
            print("Ошибка при сохранении данных: \(error)") // Обработка ошибок.
        }
    }

    // Приватная функция для загрузки данных из CoreData.
    private func loadData() {
        // Создание запроса на получение записей о воде.
        let fetchRequest: NSFetchRequest<WaterEntry> = WaterEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // Сортировка по дате.

        do {
            history = try context.fetch(fetchRequest) // Загрузка записей.
            currentAmount = history.reduce(0) { $0 + $1.amount } // Расчет текущего количества воды.
        } catch {
            print("Ошибка при загрузке данных: \(error)") // Обработка ошибок.
        }
    }
}
