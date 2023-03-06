//
//  PhotoDisplayView.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/22.
//

import Alamofire
import SwiftUI

extension AnyTransition {
    static var modal: AnyTransition {
        .asymmetric(
            insertion: .push(from: .bottom).combined(with: .opacity),
            removal: .push(from: .top).combined(with: .opacity)
        )
    }

    static var alert: AnyTransition {
        .asymmetric(
            insertion: .push(from: .top),
            removal: .opacity
        )
    }
}

struct PhotoDisplayView: View {
    @Environment(\.dismiss) var dismissAction
    var exhibition: Response.Exhibition
    @State private var selection = 0
    @State private var isActive = false
    @State private var showCompleteAlert = false
    @State private var showFailModal = false

    @EnvironmentObject private var viewModel: PhotoDisplayViewModel

    init(exhibition: Response.Exhibition) {
        self.exhibition = exhibition
    }

    var body: some View {
        return ZStack {
            TabView(selection: $selection) {
                ForEach(viewModel.photos.indices, id: \.self) { index in
                    PhotoPageView(photo: Image(uiImage: viewModel.photos[index].photo))
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())

            VStack {
                if isActive {
                    Spacer()
                    BuyModal(
                        price: String(viewModel.photos[selection].photoData.price),
                        isActive: $isActive,
                        showCompleteAlert: $showCompleteAlert,
                        showFailModal: $showFailModal
                    )
                    .padding(.bottom, 50)
                    .transition(.modal)
                }

                if showCompleteAlert {
                    CompleteAlert()
                        .transition(.alert)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showCompleteAlert.toggle()
                                }
                            }
                        }
                }

                if showFailModal {
                    FailModal(
                        showFailModal: $showFailModal
                    )
                    .transition(.alert)
                }
            }
        }
        .background(.black)
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    dismissAction.callAsFunction()
                }
            }

            if exhibition.user?.nickName != User.shared.nickName {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.easeOut(duration: 0.5)) {
                            isActive.toggle()
                        }
                    } label: {
                        Image(systemName: "dollarsign.circle")
                            .scaleEffect(1.25)
                            .foregroundColor(.black)
                    }

                    if viewModel.photos.count > selection {
                        Like(isLiked: .constant(viewModel.photos[selection].isLiked)) {
                            if viewModel.photos[selection].isLiked {
                                // TODO: 전시물 좋아요 해제 API 호출
                            } else {
                                likePhoto(viewModel.photos[selection].photoData.photoId) {
                                    withAnimation {
                                        viewModel.photos[selection].isLiked.toggle()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PhotoPageView: View {
    var photo: Image

    var body: some View {
        photo
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
