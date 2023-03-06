//
//  ExhibitionAPI.swift
//  PhotoCarpet
//
//  Created by 최정민 on 2023/02/26.
//

import Alamofire
import Foundation
import SwiftUI

func requestExhibition(_ exhibitionId: Int, _ completion: @escaping (Response.Exhibition, [Int: (Response.Photo, UIImage)]) -> Void) {
    AF.request(Request.baseURL + "/exhibition/withhashtag/\(exhibitionId)")
        .response { response in
            guard let data = response.data else { return }

            let decoder: JSONDecoder = {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)

                    let formatter = DateFormatter()
                    formatter.dateFormat = Request.dateFormat

                    if let date = formatter.date(from: dateString) {
                        return date
                    }

                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                }
                return decoder
            }()

            do {
                let exhibition = try decoder.decode(Response.Exhibition.self, from: data)
                var images: [Int: (Response.Photo, UIImage)] = [:]

                let queue = DispatchQueue(label: "download_photos", attributes: .concurrent)
                let group = DispatchGroup()

                AF.request(Request.baseURL + "/photo/\(exhibitionId)")
                    .responseDecodable(of: [Response.Photo].self, queue: queue) { response in
                        guard let photos = response.value else { return }

                        for index in photos.indices {
                            group.enter()
                            AF.download(photos[index].artUrl).responseData { response in
                                if let data = response.value {
                                    if let image = UIImage(data: data) {
                                        images[index] = (photos[index], image)
                                    }
                                }
                                group.leave()
                            }
                        }
                    }

                group.notify(queue: .main) {
                    completion(exhibition, images)
                }
            } catch {
                debugPrint(String(describing: error))
            }
        }
}

func createExhibition(method: HTTPMethod = .post, exhibitionId: Int? = nil, _ exhibition: Request.Exhibition, _ action: @escaping (Response.Exhibition?) -> Void) {
    struct ExhibitionRequest: Codable {
        let exhibitionId: Int?
        let title: String
        let content: String
        let exhibitionDate: String
        let userId: Int
        let customMoods: [String]
    }

    let header: HTTPHeaders = [
        "Content-Type": "multipart/form-data; boundary=Boundary-\(UUID().uuidString)",
//        "Authorization": "Bearer \(User.shared.jwtToken)",
    ]

    let formatter = DateFormatter()
    formatter.dateFormat = Request.dateFormat
    let converted = formatter.string(from: exhibition.exhibitionDate)

    AF.upload(multipartFormData: { multipartFormData in
        if let data = try? JSONEncoder().encode(ExhibitionRequest(
            exhibitionId: exhibitionId,
            title: exhibition.title,
            content: exhibition.content,
            exhibitionDate: converted,
            userId: User.shared.userId,
            customMoods: exhibition.customMoods
        )) {
            multipartFormData.append(data, withName: "exhibitionRequest", mimeType: "application/json")
        }
        if let image = exhibition.photo.jpegData(compressionQuality: 1) {
            multipartFormData.append(image, withName: "file", fileName: "\(image).jpeg", mimeType: "image/jpeg")
        }
    }, to: Request.baseURL + "/exhibition/\(method == .post ? "create" : (method == .put ? "update" : "resolved"))", usingThreshold: UInt64(), method: method, headers: header).response { response in
        guard let statusCode = response.response?.statusCode, statusCode == 200 || statusCode == 500 else { return }

        if method == .put {
            action(nil)
            return
        }

        if let data = response.data {
            let decoder: JSONDecoder = {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)

                    formatter.dateFormat = Request.dateFormat
                    if let date = formatter.date(from: dateString) {
                        return date
                    }

                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                }
                return decoder
            }()

            do {
                let exhibition = try decoder.decode(Response.Exhibition.self, from: data)
                action(exhibition)
            } catch {
                debugPrint(String(describing: error))
            }
        }
    }
}

func requestPhotos(_ exhibitionId: Int, _ completion: @escaping ([Int: (Response.Photo, UIImage)]) -> Void) {
    let queue = DispatchQueue(label: "request_photos", attributes: .concurrent)
    let group = DispatchGroup()
    var images: [Int: (Response.Photo, UIImage)] = [:]

    AF.request(Request.baseURL + "/photo/\(exhibitionId)")
        .responseDecodable(of: [Response.Photo].self, queue: queue) { response in
            guard let photos = response.value else { return }

            for index in photos.indices {
                group.enter()
                AF.download(photos[index].artUrl).responseData { response in
                    if let data = response.value {
                        if let image = UIImage(data: data) {
                            images[index] = (photos[index], image)
                        }
                    }
                    group.leave()
                }
            }

            group.wait()
            completion(images)
        }
}

func uploadPhoto(method: HTTPMethod = .post, _ photo: Request.Photo) {
    struct PhotoRequest: Codable {
        let exhibitionId: Int
        let soldOut: Bool
        let price: Int
    }

    let header: HTTPHeaders = [
        "Content-Type": "multipart/form-data; boundary=Boundary-\(UUID().uuidString)",
    ]

    AF.upload(multipartFormData: { multipartFormData in
        if let data = try? JSONEncoder().encode(PhotoRequest(
            exhibitionId: photo.exhibitionId,
            soldOut: photo.soldOut,
            price: photo.price
        )) {
            multipartFormData.append(data, withName: "photoRequest", mimeType: "application/json")
        }
        if let image = photo.photo.jpegData(compressionQuality: 1) {
            multipartFormData.append(image, withName: "file", fileName: "\(image).jpeg", mimeType: "image/jpeg")
        }
    }, to: Request.baseURL + "/photo/\(method == .post ? "create" : (method == .put ? "update" : "resovled"))", usingThreshold: .init(), method: method, headers: header).response {
        response in
        guard let statusCode = response.response?.statusCode, statusCode == 200 else {
            return
        }
    }
}

func likeExhibition(_ exhibitionId: Int, completion: @escaping () -> Void) {
    AF.request(
        Request.baseURL + "/like/\(User.shared.userId)/\(exhibitionId)",
        method: .post
    ).response { response in
        guard let statusCode = response.response?.statusCode, statusCode == 200 else {
            debugPrint(String(describing: response.response?.statusCode))
            return
        }
        completion()
    }
}

func dislikeExhibition(_ exhibitionId: Int, completion: @escaping () -> Void) {
    AF.request(
        Request.baseURL + "/dislike/\(User.shared.userId)/\(exhibitionId)",
        method: .delete
    ).response { response in
        guard let statusCode = response.response?.statusCode, statusCode == 200 else {
            debugPrint(String(describing: response.response?.statusCode))
            return
        }
        completion()
    }
}

func likePhoto(_ photoId: Int, completion: @escaping () -> Void) {
    AF.request(
        Request.baseURL + "/photo/like/\(User.shared.userId)/\(photoId)",
        method: .post
    ).response { response in
        guard let statusCode = response.response?.statusCode, statusCode == 200 else {
            debugPrint(String(describing: response.response?.statusCode))
            return
        }
        completion()
    }
}
