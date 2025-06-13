import CoreData

// Основной контроллер для работы с Core Data
//
// Singleton pattern (shared) - обеспечивает единую точку доступа к Core Data
// Режим in-memory - позволяет работать с временным хранилищем для тестов и превью
// Автоматическое слияние изменений - automaticallyMergesChangesFromParent упрощает работу с контекстами
// Preview-режим - специально настроен для работы SwiftUI Preview с тестовыми данными
// Обработка ошибок - все ошибки приводят к фатальной ошибке, так как работа Core Data критична для приложения
//
struct PersistenceController {
    // Singleton-экземпляр для глобального доступа к Core Data
    static let shared = PersistenceController()

    // Контейнер для управления хранилищем Core Data
    let container: NSPersistentContainer

    // Инициализатор с возможностью работы в памяти (для тестов)
    init(inMemory: Bool = false) {
        // Создаем контейнер с именем модели данных ("WaterFill.xcdatamodeld")
        container = NSPersistentContainer(name: "WaterFill")
        
        // Если требуется работа в памяти (для тестов/превью)
        if inMemory {
            // Устанавливаем специальный URL для временного хранилища в памяти
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Загружаем хранилище данных
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // В случае ошибки загрузки - критическая ошибка приложения
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Настраиваем автоматическое слияние изменений из родительского контекста - для автоматического обновления интерфейса при изменениях данных, избавляет от необходимости вручную вызывать mergeChanges.
        // Без этой настройки, если вы сохраняете данные в фоновом контексте, главный контекст (используемый в UI) не узнает об изменениях, пока вы не обновите его вручную
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // Предварительный просмотр данных для SwiftUI Preview
    static var preview: PersistenceController = {
        // Создаем экземпляр с хранилищем в памяти
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Создаем 10 тестовых записей о воде
        for _ in 0..<10 {
            let newEntry = WaterEntry(context: viewContext)
            newEntry.amount = 200  // Устанавливаем количество воды
            newEntry.date = Date() // Устанавливаем текущую дату
        }
        
        // Пытаемся сохранить тестовые данные
        do {
            try viewContext.save()
        } catch {
            // В случае ошибки - критическая ошибка приложения
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
}
