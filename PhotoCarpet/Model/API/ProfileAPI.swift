//
//  ProfileAPI.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/26.
//

import Alamofire
import Foundation

class UserViewModel: ObservableObject {
    struct User: Identifiable {
        internal init(id: Int, email: String, profileUrl: String? = nil) {
            self.id = id
            self.email = email
            self.profileUrl = profileUrl
        }

        init() { self.id = 0; self.email = ""; self.profileUrl = nil }

        let id: Int
        let email: String
        let profileUrl: String?
    }

    @Published var user: UserViewModel.User = .init()

    func fetchData() {
        let url = "\(Request.baseURL)/user"

        let parameters = ["nickname": "tester2"]

        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept": "application/json"])
            .responseDecodable(of: Response.SocialUser.self) { response in
                do {
                    let result = try response.result.get()
                    self.user = UserViewModel.User(id: result.userId, email: result.email, profileUrl: result.profileUrl)
                } catch {
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
}
