//
//  ArtistInfo.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/23.
//

import SwiftUI

struct ArtistInfo: View {
    var artistProfileUrl: String?
    var artistName: String?
    
    init(artistProfileUrl: String?, artistName: String?) {
        self.artistProfileUrl = artistProfileUrl
        self.artistName = artistName
    }
    
    var body: some View {
        HStack {
            if let artistProfileUrl {
                AsyncImage(url: URL(string: artistProfileUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    case .empty:
                        ProgressView()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "wifi.slash")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                }
            } else {
                Image(systemName: "nosign")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }

            Text(artistName ?? "아티스트 이름")
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .bold))
        } // HStack
    }
}

struct ArtistInfo_Previews: PreviewProvider {
    static var previews: some View {
        ArtistInfo(artistProfileUrl: nil, artistName: "아티스트 이름")
    }
}
