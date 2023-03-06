//
//  Like.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/24.
//

import SwiftUI

struct Like: View {
    @Binding var isLiked: Bool
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .scaleEffect(isLiked ? 1.125 : 1.0)
                .foregroundColor(isLiked ? .red : .black)
        }
    }
}

struct Like_Previews: PreviewProvider {
    static var previews: some View {
        Like(isLiked: .constant(false)) {}
    }
}
