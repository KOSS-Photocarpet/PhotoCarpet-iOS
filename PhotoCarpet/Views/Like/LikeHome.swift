//
//  LikeHome.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/23.
//

import SwiftUI

struct LikeHome: View {
    @Environment(\.dismiss) private var dismissAction

    @State var category: Category = .photo // 전시회 검색인지 확인

    // TODO: 좋아요 viewModel 만들기
    @ObservedObject private var likeVM = LikeViewModel()

    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            HStack {
                Button {
                    category = .photo
                } label: {
                    Text("Photos")
                        .fontWeight(category == .photo ? .bold : .regular)
                }

                Spacer()

                Button {
                    category = .exhibition
                } label: {
                    Text("Exhibitions")
                        .fontWeight(category == .exhibition ? .bold : .regular)
                }
            }
            .frame(width: 200)

            category == .exhibition ? AnyView(SearchExhibition(exhibitions: likeVM.exhibitionLikes).onAppear {
                likeVM.requestLikeExhibitions()
            }) : AnyView(LikePhoto(likes: likeVM.photoLikes).onAppear {
                likeVM.requestLikePhotos()
            })
        }
        .padding(.top, 20)

        .navigationBarTitle("찜목록", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
                    .onTapGesture {
                        dismissAction()
                    }
            }
        })
        .tint(.black)
    }
}

struct LikeHome_Previews: PreviewProvider {
    static var previews: some View {
        LikeHome()
    }
}
