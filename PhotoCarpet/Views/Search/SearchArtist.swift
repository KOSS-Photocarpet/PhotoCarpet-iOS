//
//  SearchArtist.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/22.
//

import SwiftUI

struct SearchArtist: View {
    @EnvironmentObject var searchVM: SearchViewModel

    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    
    var body: some View {
        let artists = searchVM.artists
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(artists.indices, id: \.self) { index in
                    NavigationLink {
                        Text("정환이형 프로필 관리 페이지")
                    } label: {
//                        ArtistItem(profileMessage: .constant(artist.profileMessage), nickName: .constant(artist.nickname), profileURL: .constant(artist.profileUrl))

//                        ArtistItem(profileMessage: artist.profileMessage, nickName: artist.nickname, profileURL: artist.profileUrl)
                        ArtistItem(profileMessage: artists[index].profileMessage, nickName: artists[index].nickname, profileURL: artists[index].profileUrl)
                    }
                }
            }
            .padding(.top, 15)
        }
        .scrollIndicators(.hidden)
    }
}

struct SearchArtist_Previews: PreviewProvider {
    static var previews: some View {
        SearchArtist()
    }
}
