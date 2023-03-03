//
//  LikePhoto.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/23.
//

import SwiftUI

struct LikePhoto: View {
    var listOfLikes: [Int: (Response.Photo, Response.Exhibition)]

    init(likes: [Int: (Response.Photo, Response.Exhibition)]) {
        self.listOfLikes = likes
    }

    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(listOfLikes.keys.sorted(by: <), id: \.self) { key in
                    NavigationLink {
                        // TODO: Response.Exhibition type의 데이터 파라미터로 넘겨주기
                        ExhibitionMainView()
                    } label: {
                        PhotoItem(photoUrl: listOfLikes[key]?.0.artUrl,
                                  artistProfileUrl: listOfLikes[key]?.1.user?.profilUrl,
                                  artistName: listOfLikes[key]?.1.user?.nickName)
                            .padding(.vertical, 10)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .scrollIndicators(.hidden)
    }
}

struct LikePhoto_Previews: PreviewProvider {
    static var previews: some View {
        LikePhoto(likes: [:])
    }
}
