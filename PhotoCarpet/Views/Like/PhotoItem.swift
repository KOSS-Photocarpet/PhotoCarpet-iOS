//
//  PhotoItem.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/23.
//

import SwiftUI

struct PhotoItem: View {
    var body: some View {
        ZStack {
            Image("Image")
                .renderingMode(.original)
                .resizable()
                .frame(width: 150, height: 250)
                .cornerRadius(5)

            VStack {
                Spacer()
//                ArtistInfo()
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
            .frame(width: 150, height: 250, alignment: .leading)
        } // ZStack
    }
}

struct PhotoItem_Previews: PreviewProvider {
    static var previews: some View {
        PhotoItem()
    }
}
