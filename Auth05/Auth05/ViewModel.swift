//
//  ViewModel.swift
//  Auth05
//
//  Created by Grigory Sosnovskiy on 05.02.2025.
//

import Foundation

enum Signup {
    struct Request: Encodable {
        var username: String
        var email: String
        var password: String
        var secretResponse: String
    }

    struct Response: Decodable {
        let token: String
    }
}

enum Signin {
    struct Request: Encodable {
        var username: String
        var password: String
    }

    struct Response: Decodable {
        let token: String
    }
}

final class ViewModel: ObservableObject {
    enum Const {
        static let tokenKey = "token"
    }

    @Published var username: String = ""
    @Published var gotToken: Bool = KeychainService().getString(forKey: Const.tokenKey)?.isEmpty == false

    private var worker = AuthWorker()
    private var keychain = KeychainService()

    func signUp(
        login: String,
        email: String,
        password: String
    ) {
        let endpoint = AuthEndpoint.signup
        let requestData = Signup.Request(
            username: login,
            email: email,
            password: password,
            secretResponse: "hello"
        )

        let body = try? JSONEncoder().encode(requestData)
        let request = Request(endpoint: endpoint, method: .post, body: body)
        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                if
                    let data,
                    let response = try? JSONDecoder().decode(Signup.Response.self, from: data)
                {
                    let token = response.token
                    self?.keychain.setString(token, forKey: Const.tokenKey)
                    DispatchQueue.main.async {
                        self?.gotToken = true
                    }
                }

                print("failed to get token")
            }
        }
    }

    func signIn(
        login: String,
        password: String
    ) {
        let endpoint = AuthEndpoint.signup
        let requestData = Signin.Request(
            username: login,
            password: password
        )

        let body = try? JSONEncoder().encode(requestData)
        let request = Request(endpoint: endpoint, method: .post, body: body)
        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                if
                    let data,
                    let response = try? JSONDecoder().decode(Signin.Response.self, from: data)
                {
                    let token = response.token
                    self?.keychain.setString(token, forKey: Const.tokenKey)
                    DispatchQueue.main.async {
                        self?.gotToken = true
                    }
                }

                print("failed to get token")
            }
        }
    }

    func getUsers() {
        let token = keychain.getString(forKey: Const.tokenKey) ?? ""
        let request = Request(endpoint: AuthEndpoint.users(token: token))
        worker.load(request: request) { result in
            switch result {
            case .failure(_):
                print("error")
            case .success(let data):
                guard let data else {
                    print("error")
                    return
                }
                print(String(data: data, encoding: .utf8))
            }
        }
    }
}

enum AuthEndpoint: Endpoint {
    case signup
    case signin
    case users(token: String)

    var rawValue: String {
        switch self {
        case .signup:
            return "signup"
        case .signin:
            return "signin"
        case .users:
            return "posts"
        }
    }

    var compositePath: String {
        return "/api/auth/\(self.rawValue)"
    }

    var headers: [String: String] {
        switch self {
        case .users(let token): ["Authorization": "Bearer \(token)"]
        default: ["Content-Type": "application/json"]
        }

    }
}

final class AuthWorker {
    let worker = BaseURLWorker(baseUrl: "http://127.0.0.1:7000")

    func load(request: Request, completion: @escaping (Result<Data?, Error>) -> Void) {
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let result):
                completion(.success(result.data))
            }
        }
    }
}
