//
//  ExhibitionMainView.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/22.
//

import Alamofire
import SwiftUI

final class PhotoDisplayViewModel: ObservableObject {
    @Published var photos: [(photoData: Response.Photo, photo: UIImage, isLiked: Bool)] = []

    func requestPhotos(exhibitionId: Int) {
        AF.request(Request.baseURL + "/photo/\(exhibitionId)").responseDecodable(of: [Response.Photo].self) { response in
            guard let result = response.value else { return }

            let queue = DispatchQueue(label: "request_photos")
            let group = DispatchGroup()

            queue.async(group: group) {
                for photo in result {
                    group.enter()
                    AF.download(photo.artUrl).responseData(queue: queue) { response in
                        if let data = response.value {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.photos.append(
                                        (photoData: photo, photo: image, isLiked: false)
                                    )
                                }
                            }
                        }
                        group.leave()
                    }
                }
            }

            group.notify(queue: queue) {
                AF.request(Request.baseURL + "/photo/\(User.shared.userId)/likePhotos")
                    .responseDecodable(of: [Response.Photo].self, queue: queue) { response in
                        guard let data = response.value else { return }
                        for photo in data {
                            if let idx = self.photos.firstIndex(where: { $0.photoData.photoId == photo.photoId }) {
                                DispatchQueue.main.async {
                                    self.photos[idx].isLiked = true
                                }
                            }
                        }
                    }
            }
        }
    }
}

struct ExhibitionMainView: View {
    @ObservedObject var photoDisplayViewModel = PhotoDisplayViewModel()
    @Environment(\.dismiss) var dismissAction
    @State private var exhibitionInputData: ExhibitionInputData = .init()
    @State private var showDetail: Bool = false
    @State private var isLiked: Bool = false

    var exhibition: Response.Exhibition
    init(_ exhibition: Response.Exhibition) {
        self.exhibition = exhibition
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Group {
                    Spacer()
                    Spacer()
                    Spacer()
                }

                Group {
                    Text(exhibition.title!)
                        .lineLimit(1 ... 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(0x000000, opacity: 0.5))
                        .cornerRadius(10)
                        .padding(.bottom)

                    HStack(spacing: 10) {
                        NavigationLink {
                            PhotoDisplayView(exhibition: exhibition)
                                .environmentObject(photoDisplayViewModel)
                        } label: {
                            Text("관람하기")
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .bold))
                                .padding()
                                .background(Color(0xFEFEFE))
                                .cornerRadius(5)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            photoDisplayViewModel.requestPhotos(exhibitionId: exhibition.exhibitId)
                        })

                        if exhibition.user?.nickName != User.shared.nickName {
                            NavigationLink {
                                // TODO: 아티스트 정보 이동
                            } label: {
                                Text("아티스트 정보")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .bold))
                                    .padding()
                                    .background(Color(0xF2F2F2, opacity: 0.5))
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                .padding([.leading, .trailing], 30)

                Spacer()

                Button {
                    showDetail.toggle()
                } label: {
                    HStack(alignment: .lastTextBaseline) {
                        Image(systemName: "chevron.down")
                        Text("more")
                            .font(.system(size: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                }
                .sheet(isPresented: $showDetail) {
                    ExhibitionDetailView(isLiked: $isLiked, exhibition: exhibition)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(content: {
            AsyncImage(url: URL(string: exhibition.thumbUrl!), content: { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .renderingMode(.original)
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if phase.error != nil {
                    Image(systemName: "wifi.slash")
                } else {
                    ProgressView()
                        .scaleEffect(3)
                }
            })
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    NavigationUtil.popToRootView()
                }
            }

            if exhibition.user?.nickName == User.shared.nickName {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EnrollView(isEdit: true)
                            .environmentObject(exhibitionInputData)
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                            .scaleEffect(1.5)
                            .padding(.trailing)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        requestPhotos(exhibition.exhibitId) { (response: [Int: (Response.Photo, UIImage)]) in
                            DispatchQueue.main.async {
                                exhibitionInputData.responseExhibition = exhibition
                                exhibitionInputData.title = exhibition.title ?? ""
                                exhibitionInputData.description = exhibition.content ?? ""
                                exhibitionInputData.rawHashTags = exhibition.moodContents?.reduce("") {
                                    $0 + $1 + " "
                                } ?? ""
                                exhibitionInputData.date = exhibition.exhibitionDate ?? Date()

                                exhibitionInputData.photo1 = ExhibitionInputData.Photo(
                                    data: response[0]?.1,
                                    photo: Image(uiImage: response[0]?.1 ?? UIImage()),
                                    price: String(response[0]?.0.price ?? 0),
                                    isLiked: false
                                )
                                exhibitionInputData.photo2 = ExhibitionInputData.Photo(
                                    data: response[1]?.1,
                                    photo: Image(uiImage: response[1]?.1 ?? UIImage()),
                                    price: String(response[1]?.0.price ?? 0),
                                    isLiked: false
                                )
                                exhibitionInputData.photo3 = ExhibitionInputData.Photo(
                                    data: response[2]?.1,
                                    photo: Image(uiImage: response[2]?.1 ?? UIImage()),
                                    price: String(response[2]?.0.price ?? 0),
                                    isLiked: false
                                )
                                exhibitionInputData.photo4 = ExhibitionInputData.Photo(
                                    data: response[3]?.1,
                                    photo: Image(uiImage: response[3]?.1 ?? UIImage()),
                                    price: String(response[3]?.0.price ?? 0),
                                    isLiked: false
                                )
                            }
                        }
                    })
                }
            } else {
                ToolbarItem(placement: .navigationBarTrailing) {
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
                    .padding(.trailing)
                    .onAppear {
                        if let liked = exhibition.liked {
                            isLiked = liked
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ExhibitionMainView_Previews: PreviewProvider {
    static var previews: some View {
//        ExhibitionMainView()
        EmptyView()
    }
}
