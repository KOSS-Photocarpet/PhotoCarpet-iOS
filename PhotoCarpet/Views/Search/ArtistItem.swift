//
//  ArtistItem.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/22.
//

import SwiftUI

struct ArtistItem: View {
    var profileMessage: String?
    var nickName: String?
    var profileURL: String?

    init(profileMessage: String?, nickName: String?, profileURL: String?) {
        self.profileMessage = profileMessage
        self.nickName = nickName
        self.profileURL = profileURL
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let profileUrl = profileURL {
                AsyncImage(url: URL(string: profileUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .padding(.vertical, 20)
                    case .empty:
                        ProgressView()
                    case .failure:
                        Image(systemName: "wifi.slash")
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(.vertical, 20)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(nickName ?? "Anonymous")
                    .font(.system(size: 14, weight: .semibold))
                Text(profileMessage ?? "")
                    .font(.system(size: 12, weight: .light))
            }
            .padding(.top, 20)
        }
        .frame(minWidth: 290, maxWidth: 290, minHeight: 90, maxHeight: 90, alignment: .leading)
        .padding(.horizontal, 20)
        .background(.white)
        .cornerRadius(30)
        .shadow(
            color: Color.gray.opacity(0.3),
            radius: 5,
            x: 0, y: 0
        )
    }
}

struct ArtistItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
//            ArtistItem(profileMessage: .constant("Id voluptas voluptatem possimus rerum voluptate est distinctio suscipit dolorem."), nickName: .constant("아티스트 이름"), profileURL: .constant("https://cdn-icons-png.flaticon.com/512/1361/1361876.png"))

            ArtistItem(profileMessage: "Id voluptas voluptatem possimus rerum voluptate est distinctio suscipit dolorem.", nickName: "아티스트 이름", profileURL: "https://cdn-icons-png.flaticon.com/512/1361/1361876.png")
        }
    }
}
