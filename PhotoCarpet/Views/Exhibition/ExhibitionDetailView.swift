//
//  ExhibitionDetailView.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/22.
//

import SwiftUI

struct ExhibitionDetailView: View {
    @Environment(\.dismiss) var dismissAction
    @Binding var isLiked: Bool
    var exhibition: Response.Exhibition
//    @Binding var profileImage: Image?
//    @Binding var userName: String

    init(isLiked: Binding<Bool>, exhibition: Response.Exhibition) {
        _isLiked = isLiked
        self.exhibition = exhibition
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(exhibition.title!)
                    .font(.system(size: 35, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Like(isLiked: $isLiked) {
                    if isLiked {
                        dislikeExhibition(exhibition.exhibitId) {
                            withAnimation {
                                isLiked.toggle()
                            }
                        }
                    } else {
                        likeExhibition(exhibition.exhibitId) {
                            withAnimation {
                                isLiked.toggle()
                            }
                        }
                    }
                }
            }

            HStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(0xf5f5f5))

                Text(exhibition.user?.nickName ?? "unknown")
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(Binding.constant(exhibition.moodContents ?? []), id: \.self) { tag in
                        Tag(tag: tag)
                    }
                }
            }.padding([.top, .bottom], 20)
            Text(exhibition.content!)
                .padding([.leading, .trailing], 10)
            Spacer()
            HStack(alignment: .lastTextBaseline) {
                Spacer()
                Text("전시회 마감일")
                Text(dateToString(exhibition.exhibitionDate!))
                    .font(.system(size: 27, weight: .bold))
            }
        }
        .padding([.top, .leading, .trailing], 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: date)
    }
}

struct ExhibitionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
