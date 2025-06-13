//
//  Example1.swift
//  SwiftUILocalNoti
//
import SwiftUI

struct Example1 : View {
    @State private var toShowAlert: Bool = false
    
    var body: some View {
        let notiName = "su.brf.apps.notification"
        let pub = NotificationCenter.default.publisher(
            for: Notification.Name(notiName))
        VStack {
            Button(action: {
                NotificationHandler.shared.addNotification(
                    id: notiName,
                    title:"Your notification" , subtitle: "Have a nice day!")
            }, label : {
                Text("Send notification")
            })
        }
        .onReceive(pub) { data in
            // execute other methods when the
            // Combine publisher with the specified
            // name received
            if let content = (data.object as? UNNotificationContent){
                print("title:\(content.title), subtitle:\(content.subtitle)",
                      content.sound == .default ? "true" : "false")
//                defaultCritical // sound type
            }
        }
        .onAppear{
            NotificationHandler.shared.requestPermission( onDeny: {
                self.toShowAlert.toggle()
                print("onDeny")
            })
        }
        .alert(isPresented: $toShowAlert){
            Alert(
                title: Text("Notification has been disabled for this app"),
                message: Text("Please go to settings to enable it now"),
                primaryButton: .default(Text("Go to Settings")) {
                    self.goToSettings()
                },
                secondaryButton: .cancel()
            )
        }
    }
}


extension Example1 {
    private func goToSettings(){
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
}
