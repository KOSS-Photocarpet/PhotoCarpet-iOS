//
//  ExhibitionInfo.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/23.
//

import SwiftUI

struct ExhibitionInfo: View {
    var exhibition: Response.Exhibition

    init(_ exhibition: Response.Exhibition) {
        self.exhibition = exhibition
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(exhibition.title!)
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .bold))

            ArtistInfo(exhibition)
        } // VStack
    }
}

struct ExhibitionInfo_Previews: PreviewProvider {
    static var previews: some View {
//        ExhibitionInfo()
        EmptyView()
    }
}
