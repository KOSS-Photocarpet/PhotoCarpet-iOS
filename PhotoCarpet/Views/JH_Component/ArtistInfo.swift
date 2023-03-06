//
//  ArtistInfo.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/23.
//

import SwiftUI

struct ArtistInfo: View {
    var exhibition: Response.Exhibition

    init(_ exhibition: Response.Exhibition) {
        self.exhibition = exhibition
    }

    var body: some View {
        HStack {
            if exhibition.user?.profilUrl != nil {
                AsyncImage(url: URL(string: exhibition.user?.profilUrl ?? "https://randomuser.me/api/portraits/lego/1.jpg")) { phase in
                    if let image = phase.image {
                        image
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        Image(systemName: "person.circle.fill")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    } else {
                        ProgressView()
                    }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .foregroundColor(.black)
                    .backgroundStyle(.white)
            }

            Text(exhibition.user?.nickName ?? "unknown")
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .bold))
        } // HStack
    }
}

struct ArtistInfo_Previews: PreviewProvider {
    static var previews: some View {
//        ArtistInfo()
        EmptyView()
    }
}
