//
//  EnrollView.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/22.
//

import SwiftUI

struct EnrollView: View {
    @EnvironmentObject var exhibitionInputData: ExhibitionInputData
    @Environment(\.dismiss) var dismissAction
    @State var isActive: Bool = false
    var isEdit: Bool = false

    var body: some View {
        ZStack {
            Color.clear
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("작품 선택")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    Text("* 첫번째 사진은 썸네일 화면입니다.")
                        .font(.system(size: 14))
                }
                .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ImageSelector(photo: $exhibitionInputData.photo1)
                        ImageSelector(photo: $exhibitionInputData.photo2)
                        ImageSelector(photo: $exhibitionInputData.photo3)
                        ImageSelector(photo: $exhibitionInputData.photo4)
                    }
                }

                CustomTextField(title: "전시회 제목", placeholder: "전시회 제목을 입력해주세요", text: $exhibitionInputData.title)

                CustomTextField(title: "간단한 설명", placeholder: "설명을 입력해주세요", text: $exhibitionInputData.description)

                CustomTextField(title: "해시태그", placeholder: "#태그1 #태그2", text: $exhibitionInputData.rawHashTags)
                VStack(alignment: .leading) {
                    Text("전시회 마감일")
                    VStack {
                        DatePicker("", selection: $exhibitionInputData.date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                }.padding(.top)

                Spacer()
                Spacer()
                Spacer()

                if exhibitionInputData.isFillData {
                    if isEdit == false {
                        NavigationLink(isActive: $isActive) {
                            if let response = exhibitionInputData.responseExhibition {
                                ExhibitionMainView(response)
                            }
                        } label: {
                            EmptyView()
                        }

                        Button {
                            createExhibition(
                                Request.Exhibition(
                                    title: exhibitionInputData.title,
                                    content: exhibitionInputData.description,
                                    exhibitionDate: exhibitionInputData.date,
                                    userId: User.shared.userId,
                                    customMoods: exhibitionInputData.hashTags,
                                    photo: exhibitionInputData.photo1.data!
                                )
                            ) { exhibition in
                                guard let exhibition = exhibition else { return }

                                exhibitionInputData.responseExhibition = exhibition
                                uploadPhoto(
                                    Request.Photo(
                                        exhibitionId: exhibition.exhibitId,
                                        soldOut: false,
                                        price: Int(exhibitionInputData.photo1.price)!,
                                        photo: exhibitionInputData.photo1.data!
                                    )
                                )
                                uploadPhoto(
                                    Request.Photo(
                                        exhibitionId: exhibition.exhibitId,
                                        soldOut: false,
                                        price: Int(exhibitionInputData.photo2.price)!,
                                        photo: exhibitionInputData.photo2.data!
                                    )
                                )
                                uploadPhoto(
                                    Request.Photo(
                                        exhibitionId: exhibition.exhibitId,
                                        soldOut: false,
                                        price: Int(exhibitionInputData.photo3.price)!,
                                        photo: exhibitionInputData.photo3.data!
                                    )
                                )
                                uploadPhoto(
                                    Request.Photo(
                                        exhibitionId: exhibition.exhibitId,
                                        soldOut: false,
                                        price: Int(exhibitionInputData.photo4.price)!,
                                        photo: exhibitionInputData.photo4.data!
                                    )
                                )
                                isActive.toggle()
                            }
                        }
                        label: {
                            Text("전시회 등록하기")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 18).bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(.black))
                                .cornerRadius(10)
                                .padding(.trailing, 28)
                        }
                    } else {
                        Button {
                            createExhibition(
                                method: .put,
                                exhibitionId: exhibitionInputData.responseExhibition?.exhibitId,
                                Request.Exhibition(
                                    title: exhibitionInputData.title,
                                    content: exhibitionInputData.description,
                                    exhibitionDate: exhibitionInputData.date,
                                    userId: User.shared.userId,
                                    customMoods: exhibitionInputData.hashTags,
                                    photo: exhibitionInputData.photo1.data!
                                )
                            ) { _ in
                                uploadPhoto(method: .put, Request.Photo(
                                    exhibitionId: exhibitionInputData.responseExhibition?.exhibitId ?? -1,
                                    soldOut: false,
                                    price: Int(exhibitionInputData.photo1.price)!,
                                    photo: exhibitionInputData.photo1.data!
                                ))
                                uploadPhoto(method: .put, Request.Photo(
                                    exhibitionId: exhibitionInputData.responseExhibition?.exhibitId ?? -1,
                                    soldOut: false,
                                    price: Int(exhibitionInputData.photo2.price)!,
                                    photo: exhibitionInputData.photo2.data!
                                ))
                                uploadPhoto(method: .put, Request.Photo(
                                    exhibitionId: exhibitionInputData.responseExhibition?.exhibitId ?? -1,
                                    soldOut: false,
                                    price: Int(exhibitionInputData.photo3.price)!,
                                    photo: exhibitionInputData.photo3.data!
                                ))
                                uploadPhoto(method: .put, Request.Photo(
                                    exhibitionId: exhibitionInputData.responseExhibition?.exhibitId ?? -1,
                                    soldOut: false,
                                    price: Int(exhibitionInputData.photo4.price)!,
                                    photo: exhibitionInputData.photo4.data!
                                ))
                                NavigationUtil.popToRootView()
                            }
                        } label: {
                            Text("전시회 수정하기")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 18).bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(.black))
                                .cornerRadius(10)
                                .padding(.trailing, 28)
                        }
                    }
                } else {
                    Text("전시회 \(isEdit ? "수정" : "등록")하기")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 18).bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(0x000000, opacity: 0.5))
                        .cornerRadius(10)
                        .padding(.trailing, 28)
                }
            }
            .padding(.leading, 31)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                BackButton {
                    dismissAction.callAsFunction()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension Color {
    init(_ hex: Int, opacity: Double = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}
