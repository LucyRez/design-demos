import SwiftUI

struct ContentView: View {
    // Используем EnvironmentObject для доступа к данным о воде
    @EnvironmentObject private var waterData: WaterData
    
    // Состояния для анимации волн, пульсации и диалога ввода
    @State private var wavePhase: CGFloat = 0.0
    @State private var isPulsating = false
    @State private var showInputDialog = false
    @State private var inputAmount: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фоновый цвет, игнорирующий безопасные области
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Заголовок приложения
                    HStack {
                        Spacer()
                        Text("WaterFill")
                            .font(.custom("Chalkboard SE", size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    ZStack {
                        // Анимация волн
                        Waves(amplitude: 10, frequency: 1.5, phase: wavePhase)
                            .fill(Color.blue.opacity(0.5))
                            .clipShape(Circle())
                            .onAppear {
                                // Запуск анимации волн
                                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                                    wavePhase = .pi * 2
                                }
                            }
                        
                        // Внешний круг
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(1.0)
                            .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.5))
                        
                        // Прогресс-круг, показывающий текущее количество воды
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(waterData.currentAmount / waterData.dailyGoal, 1.0)))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.blue)
                            .rotationEffect(Angle(degrees: 270.0))
                            .scaleEffect(isPulsating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.5).repeatCount(1, autoreverses: true), value: isPulsating)
                            .onChange(of: waterData.currentAmount) { oldValue, newValue in
                                // Пульсация при изменении количества воды
                                isPulsating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isPulsating = false
                                }
                            }
                            .shadow(color: .white.opacity(0.5), radius: 5, x: -5, y: -5)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 5, y: 5)
                        
                        // Текстовое отображение текущего количества воды и дневной цели
                        VStack {
                            Text("\(String(format: "%.1f", waterData.currentAmount)) ml")
                                .font(.title)
                                .bold()
                                .foregroundColor(.blue)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                            
                            Text("of \(String(format: "%.1f", waterData.dailyGoal)) ml")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 200, height: 200)
                    .padding()
                    
                    // Кнопка для добавления воды
                    Button(action: {
                        showInputDialog = true
                    }) {
                        Text("Add water")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    // Список истории потребления воды
                    List {
                        ForEach(waterData.history) { entry in
                            HStack {
                                Text("\(String(format: "%.1f", entry.amount)) ml")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Spacer()
                                
                                Text(entry.date ?? Date(), style: .time)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                // Кнопка удаления записи
                                Button(action: {
                                    deleteEntry(entry)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(.plain)
                }
                .padding()
            }
            .navigationTitle("")
            // Диалог для ввода количества воды
            .alert("Add water", isPresented: $showInputDialog) {
                TextField("Amount of water (ml)", text: $inputAmount)
                    .keyboardType(.numberPad)
                Button("Add") {
                    if let amount = Double(inputAmount) {
                        waterData.addWater(amount: amount)
                        inputAmount = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    inputAmount = ""
                }
            }
        }
    }
    
    // Приватный метод для удаления записи о потреблении воды из истории
    // managedObjectContext - это среда Core Data, в которой существует запись
    // delete(entry) - помечает запись для удаления из базы данных
    // save() - фиксирует изменения (включая удаление) в постоянном хранилище
    // updateCurrentAmount() - обновляет UI после изменения данных
    // Блок do-catch обрабатывает возможные ошибки при сохранении
    private func deleteEntry(_ entry: WaterEntry) {
        // Получаем контекст управляемого объекта (Managed Object Context) из записи
        let context = entry.managedObjectContext
        
        context?.delete(entry) // Удаляем запись из контекста
        do {
            // Пытаемся сохранить изменения в контексте
            try context?.save()
            
            // Обновляем текущее количество воды после успешного удаления
            waterData.updateCurrentAmount()
        } catch {
            // Обрабатываем возможную ошибку при сохранении контекста
            print("Error deleting entry: \(error)")
        }
    }
    
    
    // Структура, представляющая волнообразную форму для создания анимации волн
    //
    // - Реализует протокол Shape,
    //   что позволяет использовать ее для отрисовки в SwiftUI
    // - animatableData позволяет анимировать изменение фазы волны
    // - Путь создается с помощью синусоидальной функции,
    //   параметры которой можно настраивать
    // Волна рисуется от левого края к правому,
    // затем замыкается в нижней части для создания замкнутой формы
    //
    struct Waves: Shape {
        var amplitude: CGFloat // Амплитуда волны (высота)
        var frequency: CGFloat // Частота волны (количество волн)
        var phase: CGFloat     // Фаза волны (для анимации)
        
        // Вычисляемое свойство для анимации
        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }
        
        // Метод, определяющий путь (path) для отрисовки формы
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.width
            let height = rect.height
            
            // Начинаем путь с нижнего левого угла
            path.move(to: CGPoint(x: 0, y: height))
            
            // Проходим по всем точкам по ширине rect с шагом 1
            for x in stride(from: 0, through: width, by: 1) {
                // Вычисляем y-координату точки на волне с использованием синусоидальной функции
                // Формула: y = амплитуда * sin(нормализованная x-координата * частота + фаза) + смещение к центру
                // нормализованная x-координата: CGFloat(x) / width
                // То есть значение x приводится к диапазону [0...1], чтобы синусоидальная волна корректно масштабировалась под любой размер области (rect.width)
                let y = amplitude * sin((CGFloat(x) / width * frequency + phase)) + height / 2
                // вместо 2 можно 9 - поднимется уровень воды
                // Добавляем линию к вычисленной точке
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            // Завершаем путь, рисуя линии до нижнего правого угла и обратно к нижнему левому
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            
            return path
        }
    }
}
