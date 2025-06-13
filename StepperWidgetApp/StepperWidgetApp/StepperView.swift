//
//  ContentView.swift
//  StepperWidgetApp
//
//  Created by Lucy Rez on 12.02.2025.
//

import SwiftUI
import WidgetKit

struct StepperView: View {
    
    @AppStorage("Test", store: UserDefaults(suiteName: "group.hse.stepper"))
    private var stepProgress: Int = 0
    
    @State
    private var stepGoal: Int = 100
    
    @State
    private var stepGoalInput: String = ""
    

    var body: some View {
        VStack {
            
            TextField("Input Number of Steps", text: $stepGoalInput)
                .onSubmit {
                    stepGoal = Int(stepGoalInput) ?? 100
                }
                .padding()
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .foregroundColor(.gray)
                    .opacity(0.3)
                
                Circle()
                    .trim(from: 0, to: CGFloat(Double(stepProgress)/Double(stepGoal)))
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                
                VStack {
                    Text("Steps: ")
                        .font(.title2)
                        .bold()
                    
                    Text("\(stepProgress)")
                        .font(.largeTitle)
                        .bold()
                }
                    
                    
            }
            .padding(64)
            
           Button(action: {
               stepProgress += 1
               WidgetCenter.shared.reloadTimelines(ofKind: "WidgetStepperDemo")
           }, label: {
               Text("Increase Step")
                   .font(.title2)
                   .padding()
                   .frame(maxWidth: .infinity)
                   .background(.blue)
                   .foregroundColor(.white)
                   .cornerRadius(10)
                   .padding()
               
           })
        }
       
    }
}

#Preview {
    StepperView()
}
