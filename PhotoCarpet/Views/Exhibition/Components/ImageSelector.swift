//
//  ImageSelector.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/22.
//

import PhotosUI
import SwiftUI

struct ImageSelector: View {
    @State private var selectedItem: PhotosPickerItem?
    @Binding var photo: ExhibitionInputData.Photo

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if let photo = photo.photo {
                        photo
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 94, height: 179)
                            .cornerRadius(10)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(0xF5F5F5))
                    }
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if photo.photo == nil {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.clear)
                        }
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    photo.data = uiImage
                                    photo.photo = Image(uiImage: uiImage)
                                    return
                                }
                            }
                        }
                    }
                }
                .frame(width: 94, height: 179)

                TextField("가격을 입력해주세요.", text: $photo.price)
                    .font(.custom("system", size: 10, relativeTo: .footnote))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .padding([.all], 5)
                    .background(Color(0xF5F5F5))
                    .cornerRadius(5)
            }
            .frame(width: 94)
        }
    }
}
