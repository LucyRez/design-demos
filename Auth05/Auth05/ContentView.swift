//
//  ContentView.swift
//  Auth05
//
//  Created by Grigory Sosnovskiy on 05.02.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State var login: String = ""
    @State var email: String = ""
    @State var password: String = ""

    var body: some View {
        VStack {
            if viewModel.gotToken {
                Label(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/, systemImage: /*@START_MENU_TOKEN@*/"42.circle"/*@END_MENU_TOKEN@*/)
                Button("Get all users") {
                    viewModel.getUsers()
                }
            } else {
                TextField("Your login", text: $login)
                TextField("Your email", text: $email)
                TextField("Your password", text: $password)
                Button("Sign up") {
                    viewModel.signUp(
                        login: login,
                        email: email,
                        password: password
                    )
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
