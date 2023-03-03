//
//  ExhibitionDetailView.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/22.
//

import SwiftUI

struct ExhibitionDetailView: View {
    @Environment(\.dismiss) var dismissAction
    @EnvironmentObject var exhibitionData: ExhibitionData
//    @Binding var profileImage: Image?
//    @Binding var userName: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(exhibitionData.title)
                    .font(.system(size: 35, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Like(isLiked: $exhibitionData.isLiked) {}
            }
            HStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(0xf5f5f5))

                Text("User Name")
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(Binding.constant(exhibitionData.hashTags), id: \.self) { tag in
                        Tag(tag: tag)
                    }
                }
            }.padding([.top, .bottom], 20)
            Text(exhibitionData.description)
                .padding([.leading, .trailing], 10)
            Spacer()
            HStack(alignment: .lastTextBaseline) {
                Spacer()
                Text("전시회 마감일")
                Text(exhibitionData.dateToString)
                    .font(.system(size: 27, weight: .bold))
            }
        }
        .padding([.top, .leading, .trailing], 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ExhibitionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExhibitionDetailView()
            .environmentObject(ExhibitionData())
    }
}
