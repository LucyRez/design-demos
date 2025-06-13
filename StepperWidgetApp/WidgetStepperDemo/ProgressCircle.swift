//
//  ProgressCircle.swift
//  StepperWidgetApp
//
//  Created by Lucy Rez on 12.02.2025.
//

import SwiftUI

struct ProgressCircle: View {
    
    var stepProgress: Int
    var lineWidth: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundColor(.gray)
                .opacity(0.3)
            
            Circle()
                .trim(from: 0, to: CGFloat(Double(stepProgress)/100))
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            
            VStack {
                
               Button("\(stepProgress)", intent: StepperAppIntent())
                    .font(.largeTitle)
                    .bold()
            }
                
        }
    }
}
