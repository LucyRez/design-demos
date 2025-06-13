import SwiftUI

// Основное представление для отображения статистики потребления воды
struct StatisticsView: View {
    // Используем EnvironmentObject для доступа к данным о воде
    @EnvironmentObject private var waterData: WaterData
    // Состояние для хранения выбранной даты
    @State private var selectedDate: Date? = nil
    // Состояние для управления отображением деталей дня
    @State private var showDayDetail = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Заголовок экрана
                HStack {
                    Spacer()
                    Text("Statistics")
                        .font(.custom("Chalkboard SE", size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Spacer()
                }
                .padding(.top, 20)

                // Календарь для отображения дней месяца
                CalendarView(selectedDate: $selectedDate, showDayDetail: $showDayDetail)
                    .frame(height: 300)
                    .padding()
            }

            // Если выбрана дата и нужно показать детали дня, отображаем карточку с деталями
            if showDayDetail, let selectedDate = selectedDate {
                DayDetailCard(date: selectedDate, showDayDetail: $showDayDetail)
                    .transition(.move(edge: .bottom)) // Анимация появления снизу
                    .animation(.spring(), value: showDayDetail) // Пружинная анимация
                    .zIndex(1) // Убедимся, что карточка поверх других элементов
            }
        }
        .navigationBarHidden(true) // Скрываем навигационную панель
    }
}

// Представление календаря
struct CalendarView: View {
    @EnvironmentObject private var waterData: WaterData
    // Привязка к выбранной дате и состоянию отображения деталей
    @Binding var selectedDate: Date?
    @Binding var showDayDetail: Bool

    var body: some View {
        VStack {
            // Отображение текущего месяца и года
            Text(getCurrentMonthYear())
                .font(.subheadline)
                .padding(.bottom, 10)

            // Сетка для отображения дней недели и дней месяца
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                // Отображение сокращенных названий дней недели
                ForEach(getWeekdaySymbols(), id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // Пустые ячейки для выравнивания первого дня месяца
                ForEach(0..<getFirstWeekdayOffset(), id: \.self) { _ in
                    Text("")
                }

                // Отображение дней месяца
                ForEach(getDaysInMonth(), id: \.self) { date in
                    Button(action: {
                        // При выборе даты обновляем состояние
                        selectedDate = date
                        showDayDetail = true
                    }) {
                        VStack {
                            // Отображение числа месяца
                            Text("\(Calendar.current.component(.day, from: date))")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            // Круг, показывающий уровень потребления воды
                            Circle()
                                .fill(getColorForDate(date))
                                .frame(width: 10, height: 10)
                        }
                        .padding(5)
                        .background(selectedDate == date ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }

    // Функция для получения текущего месяца и года в формате "MMMM yyyy"
    private func getCurrentMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }

    // Функция для получения всех дней текущего месяца
    private func getDaysInMonth() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let range = calendar.range(of: .day, in: .month, for: today)!
        return range.compactMap { day -> Date? in
            calendar.date(bySetting: .day, value: day, of: today)
        }
    }

    // Функция для получения смещения первого дня месяца относительно начала недели
    private func getFirstWeekdayOffset() -> Int {
        let calendar = Calendar.current
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    // Функция для получения сокращенных названий дней недели
    private func getWeekdaySymbols() -> [String] {
        let calendar = Calendar.current
        return calendar.shortWeekdaySymbols
    }

    // Функция для получения цвета круга в зависимости от потребления воды
    private func getColorForDate(_ date: Date) -> Color {
        let amount = getWaterAmountForDate(date)
        if amount >= waterData.dailyGoal {
            return .blue // Норма достигнута
        } else if amount > 0 {
            return .blue.opacity(0.5) // Потребление есть, но норма не достигнута
        } else {
            return .gray // Потребления нет
        }
    }

    // Функция для получения количества воды, потребленного в указанную дату
    private func getWaterAmountForDate(_ date: Date) -> Double {
        waterData.history.filter { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }.reduce(0) { $0 + $1.amount }
    }
}

// Карточка с деталями дня
struct DayDetailCard: View {
    @EnvironmentObject private var waterData: WaterData
    @Environment(\.colorScheme) private var colorScheme
    let date: Date
    @Binding var showDayDetail: Bool
    @State private var offset: CGFloat = 0

    var body: some View {
        VStack(spacing: 16) {
            // Заголовок карточки
            Text("Day Details")
                .font(.headline)
                .padding(.top, 16)

            // Отображение количества потребленной воды
            let amount = getWaterAmountForDate(date)
            Text("Water consumed: \(String(format: "%.1f", amount)) мл")
                .font(.title2)
                .foregroundColor(.blue)

            // Отображение иконки и текста в зависимости от достижения цели
            if amount >= waterData.dailyGoal {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                Text("Goal achieved")
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                Text("Goal not achieved")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }

            // Кнопка для закрытия карточки
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    offset = UIScreen.main.bounds.height
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showDayDetail = false
                }
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: colorScheme == .light ? 10 : 0) // Тень только в светлой теме
        .overlay(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Обводка в темной теме
                }
            }
        )
        .padding()
        .offset(y: offset)
        .onAppear {
            offset = 0
        }
    }

    // Функция для получения количества воды, потребленного в указанную дату
    private func getWaterAmountForDate(_ date: Date) -> Double {
        waterData.history.filter { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }.reduce(0) { $0 + $1.amount }
    }
}
