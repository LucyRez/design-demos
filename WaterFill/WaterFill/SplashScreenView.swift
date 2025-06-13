import SwiftUI

// Основная структура для экрана заставки
struct SplashScreenView: View {
    // Состояния для управления анимацией и отображением
    @State private var isActive = false // Для перехода на основной экран
    @State private var dropOffset: CGFloat = -200 // Начальное положение капли
    @State private var dropScale: CGFloat = 0.5 // Начальный масштаб капли
    @State private var textOpacity: Double = 0.0 // Прозрачность текста
    @State private var wavePhase: CGFloat = 0.0 // Фаза волны для анимации

    var body: some View {
        ZStack {
            // Градиентный фон от синего к полупрозрачному синему
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Игнорирование безопасных зон

            // Фон с пузырьками
            BubblesBackground()

            // Анимация волны
            Wave(amplitude: 40, frequency: 1.5, phase: wavePhase)
                .fill(Color.blue.opacity(0.3)) // Полупрозрачный синий цвет
                .frame(height: 300) // Высота волны
                .offset(y: 250) // Смещение волны вниз
                .onAppear {
                    // Анимация волны с бесконечным повторением
                    withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        wavePhase = .pi * 2 // Изменение фазы для создания эффекта волны
                    }
                }

            // Иконка капли
            Image(systemName: "drop.fill")
                .resizable() // Возможность изменения размера
                .scaledToFit() // Сохранение пропорций
                .frame(width: 100, height: 100) // Размер капли
                .foregroundColor(.white) // Белый цвет
                .scaleEffect(dropScale) // Применение масштаба
                .offset(y: dropOffset) // Применение смещения
                .onAppear {
                    // Анимация падения капли
                    withAnimation(Animation.easeIn(duration: 1.0)) {
                        dropOffset = 0 // Капля падает вниз
                        dropScale = 1.0 // Капля увеличивается
                    }

                    // Анимация появления текста с задержкой
                    withAnimation(Animation.easeIn(duration: 1.0).delay(0.5)) {
                        textOpacity = 1.0 // Текст становится видимым
                    }
                }

            // Текст "WaterFill"
            Text("WaterFill")
                .font(.custom("Chalkboard SE", size: 80)) // Шрифт и размер
                .foregroundColor(.white) // Белый цвет
                .opacity(textOpacity) // Применение прозрачности
                .offset(y: 120) // Смещение текста вниз
                .onAppear {
                    // Анимация появления текста с задержкой
                    withAnimation(Animation.easeIn(duration: 1.0).delay(0.5)) {
                        textOpacity = 1.0 // Текст становится видимым
                    }
                }
        }
        // Управление прозрачностью всего экрана заставки
        .opacity(isActive ? 0 : 1)
        .animation(.easeInOut(duration: 1.0), value: isActive)
        .onAppear {
            // Задержка перед переходом на основной экран
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation(.easeInOut(duration: 2)) {
                    isActive = true // Активация перехода
                }
            }
        }
        // Переход на основной экран с TabView
        .fullScreenCover(isPresented: $isActive) {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                StatisticsView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.bar")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

// Структура для создания анимации волны
struct Wave: Shape {
    var amplitude: CGFloat // Амплитуда волны
    var frequency: CGFloat // Частота волны
    var phase: CGFloat // Фаза волны

    // Поддержка анимации фазы
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    // Создание пути для волны
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: 0, y: height))

        // Построение волны
        for x in stride(from: 0, through: width, by: 1) {
            let y = amplitude * sin((CGFloat(x) / width * frequency + phase)) + height / 2
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))

        return path
    }
}

// Структура для создания пузырьков
struct Bubble: View {
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height // Начальное положение пузырька
    @State private var xPosition: CGFloat = CGFloat.random(in: 0...UIScreen.main.bounds.width) // Случайное положение по X
    @State private var scale: CGFloat = CGFloat.random(in: 0.1...0.8) // Случайный масштаб
    @State private var opacity: Double = Double.random(in: 0.2...1.0) // Случайная прозрачность
    @State private var delay: Double = Double.random(in: 0...3) // Случайная задержка перед началом анимации

    var body: some View {
        Circle()
            .fill(Color.white.opacity(opacity)) // Белый цвет с прозрачностью
            .frame(width: 20 * scale, height: 20 * scale) // Размер пузырька
            .shadow(color: .white.opacity(0.5), radius: 5, x: 0, y: 0) // Тень для эффекта свечения
            .position(x: xPosition, y: yOffset) // Позиция пузырька
            .onAppear {
                // Анимация подъема пузырька с задержкой
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(Animation.linear(duration: Double.random(in: 3...8)).repeatForever(autoreverses: false)) {
                        yOffset = -UIScreen.main.bounds.height // Пузырек поднимается вверх
                    }
                }
            }
    }
}

// Структура для создания фона с пузырьками
struct BubblesBackground: View {
    var body: some View {
        ZStack {
            // Создание 100 пузырьков
            ForEach(0..<100) { _ in
                Bubble()
            }
        }
    }
}
