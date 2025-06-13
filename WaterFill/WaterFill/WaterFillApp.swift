import SwiftUI

// Основная структура приложения, которая является точкой входа.
@main
struct WaterFillApp: App {
    // Контроллер для работы с CoreData.
    let persistenceController = PersistenceController.shared

    // Объект `WaterData`, который управляет данными о воде.
    // Используется `@StateObject`, чтобы сохранить состояние при изменении представлений.
    @StateObject private var waterData = WaterData(context: PersistenceController.shared.container.viewContext)

    // Состояние для управления отображением экрана заставки.
    @State private var showSplashScreen = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Если `showSplashScreen` равно `true`, показываем экран заставки.
                if showSplashScreen {
                    SplashScreenView()
                        .onAppear {
                            // Через 5 секунд скрываем экран заставки с анимацией.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation {
                                    showSplashScreen = false
                                }
                            }
                        }
                } else {
                    // Если экран заставки скрыт, показываем основное содержимое приложения.
                    TabView {
                        // Вкладка "Home" с основным интерфейсом.
                        ContentView()
                            .tabItem {
                                Label("Home", systemImage: "house") // Иконка и текст вкладки.
                            }
                            .environmentObject(waterData) // Передача объекта `WaterData` в `ContentView`.

                        // Вкладка "Statistics" с отображением статистики.
                        StatisticsView()
                            .tabItem {
                                Label("Statistics", systemImage: "chart.bar") // Иконка и текст вкладки.
                            }
                            .environmentObject(waterData) // Передача объекта `WaterData` в `StatisticsView`.

                        // Вкладка "Settings" с настройками.
                        SettingsView()
                            .tabItem {
                                Label("Settings", systemImage: "gear") // Иконка и текст вкладки.
                            }
                            .environmentObject(waterData) // Передача объекта `WaterData` в `SettingsView`.
                    }
                    // Передача контекста CoreData в окружение для использования в дочерних представлениях.
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}
