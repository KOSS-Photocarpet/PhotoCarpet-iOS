//
//  UserProfile.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/26.
//

import SwiftUI

struct UserProfile: View {
    @StateObject var viewModel = UserViewModel()

    var body: some View {
        VStack {
            if let user = viewModel.user, let profileUrl = user.profileUrl {
                AsyncImage(url: URL(string: profileUrl))
                Text(user.email)
            } else {
                Image("person")
                Text("anonymous")
            }

            Text(String(User.shared.point))

            NavigationLink {
                LikeHome()
            } label: {
                Text("찜 목록 가기")
            }
        }
        .task {
            self.viewModel.fetchData()
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
