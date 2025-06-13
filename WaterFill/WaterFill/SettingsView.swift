import SwiftUI

// Экран настроек приложения
struct SettingsView: View {
    // Получаем доступ к общим данным о воде через EnvironmentObject
    @EnvironmentObject private var waterData: WaterData

    var body: some View {
        // Основная навигационная структура
        NavigationView {
            // Список настроек
            List {
                // Секция для настройки дневной цели потребления воды
                Section(header: Text("Daily Goal")) {
                    VStack(alignment: .leading, spacing: 10) {
                        // Текущее значение цели
                        Text("Current Goal: \(Int(waterData.dailyGoal)) ml")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        // Слайдер для регулировки цели
                        Slider(
                            value: $waterData.dailyGoal,  // Привязка к значению цели
                            in: 500...5000,  // Диапазон значений (от 500 до 5000 мл)
                            step: 100  // Шаг изменения (100 мл)
                        ) {
                            Text("Adjust Goal")  // Описание для accessibility
                        }
                        .accentColor(.blue)  // Цвет слайдера
                    }
                    .padding(.vertical, 10)  // Вертикальные отступы
                }

                // Секция с полезными советами
                Section(header: Text("Tips & Tricks")) {
                    // Группа советов по ежедневным привычкам (раскрываемая)
                    DisclosureGroup("Daily Habits") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("1. Start your day with a glass of water.")
                            Text("2. Set reminders to drink water regularly.")
                            Text("3. Carry a water bottle with you.")
                            Text("4. Add flavor to your water with fruits.")
                            Text("5. Track your progress in the app.")
                        }
                        .font(.subheadline)  // Размер шрифта
                        .foregroundColor(.gray)  // Цвет текста
                        .padding(.vertical, 5)  // Вертикальные отступы
                    }

                    // Группа советов по здоровью
                    DisclosureGroup("Health Tips") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("1. Drinking water improves skin health.")
                            Text("2. Stay hydrated to boost energy levels.")
                            Text("3. Water helps with digestion and metabolism.")
                            Text("4. Drink water before meals to control appetite.")
                            Text("5. Hydration is key for muscle recovery.")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                    }

                    // Группа советов по тренировкам
                    DisclosureGroup("Workout Tips") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("1. Drink water before, during, and after workouts.")
                            Text("2. For intense workouts, consider electrolyte drinks.")
                            Text("3. Hydration improves performance and endurance.")
                            Text("4. Avoid sugary sports drinks; opt for water.")
                            Text("5. Listen to your body: thirst is a sign of dehydration.")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                    }

                    // Группа советов по экономии воды
                    DisclosureGroup("Water Saving Tips") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("1. Turn off the tap while brushing your teeth.")
                            Text("2. Fix leaky faucets to save water.")
                            Text("3. Use a bucket instead of a hose to wash your car.")
                            Text("4. Collect rainwater for gardening.")
                            Text("5. Only run the dishwasher or washing machine with full loads.")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                    }
                }

                // Секция с кнопкой сброса данных
                Section {
                    Button(action: {
                        // Анимированный сброс данных
                        withAnimation(.easeInOut(duration: 0.3)) {
                            waterData.resetData()
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Reset Data")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)  // Красный фон для опасного действия
                                .cornerRadius(10)  // Закругленные углы
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())  // Стиль кнопки без стандартных эффектов
                }
            }
            .listStyle(InsetGroupedListStyle())  // Стиль списка с закругленными секциями
            .navigationTitle("Settings")  // Заголовок экрана
            .navigationBarTitleDisplayMode(.inline)  // Компактный режим заголовка
        }
    }
}
