//
//  PopupModifier.swift
//  SwiftUILocalNoti
//
import SwiftUI

struct PopupModifier: ViewModifier
{
    @Binding var isPresented: Bool
    
    var title : String
    var subtitle : String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                popupView()
            }
        }
    }
}

extension PopupModifier {
    func popupView() -> some View {
        VStack(spacing :30) {
            Text(title)
                .font(.system(size: 26, weight: .bold, design: .default))
            
            ZStack {
                Capsule()
                    .fill(.green)
                    .frame(width: 220, height: 100)
                
                Text(subtitle)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding()
                    .frame(width:210)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                self.$isPresented.wrappedValue.toggle()
            }){
                Text("Bye now")
            }
        }
        .frame(width: 240, height: 240, alignment: .center)
        .padding()
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 20 )
    }
}


extension View {
    func popup(isPresented: Binding <Bool>, title: String? = nil, subtitle : String? = nil) -> some View {
        return self.modifier(PopupModifier(isPresented: isPresented, title: title ?? "", subtitle: subtitle ?? ""))
    }
}
