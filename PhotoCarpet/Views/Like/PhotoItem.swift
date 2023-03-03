//
//  PhotoItem.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/23.
//

import SwiftUI

struct PhotoItem: View {
    var photoUrl: String?
    var artistProfileUrl: String?
    var artistName: String?

    init(photoUrl: String?, artistProfileUrl: String?, artistName: String?) {
        self.photoUrl = photoUrl
        self.artistProfileUrl = artistProfileUrl
        self.artistName = artistName
    }

    var body: some View {
        ZStack {
            if let photoUrl {
                AsyncImage(url: URL(string: photoUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 150, height: 250)
                            .cornerRadius(5)
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 250)
                            .cornerRadius(5)
                    case .failure:
                        Image(systemName: "wifi.slash")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 150, height: 250)
                            .cornerRadius(5)
                    @unknown default:
                        EmptyView()
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                    }
                }
            } else {
                Image(systemName: "nosign")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 150, height: 250)
                    .cornerRadius(5)
            }
            
            VStack {
                Spacer()
                ArtistInfo(artistProfileUrl: artistProfileUrl, artistName: artistName)
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
            .frame(width: 150, height: 250, alignment: .leading)
        } // ZStack
    }
}

struct PhotoItem_Previews: PreviewProvider {
    static var previews: some View {
        PhotoItem(photoUrl: nil, artistProfileUrl: nil, artistName: nil)
    }
}
