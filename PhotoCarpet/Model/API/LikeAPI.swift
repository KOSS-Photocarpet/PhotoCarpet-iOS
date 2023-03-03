//
//  HomeAPI.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/26.
//

import Alamofire
import Foundation

enum Category: String {
    case exhibition
    case photo
}

struct LikePhotoModel {
    private(set) var likes = [Int: (Response.Photo, Response.Exhibition)]()

    func requestLikePhotos(_ userId: Int,
                           _ completion: @escaping ([Int: (Response.Photo, Response.Exhibition)]) -> Void)
    {
        let url = "\(Request.baseURL)/photo/\(userId)/likePhotos"
        let queue = DispatchQueue(label: "photo_queue", attributes: .concurrent)

        var results: [Int: (Response.Photo, Response.Exhibition)] = [:]

        AF.request(
            url,
            method: .get,
            encoding: URLEncoding.default,
            headers: ["Content-Type": "application/json", "Accept": "application/json"]
        )
        .responseDecodable(of: [Response.Photo].self, queue: queue) { response in
            do {
                let photos = try response.result.get()

                let group = DispatchGroup()

                for (index, photo) in photos.enumerated() {
                    queue.async(group: group) {
                        group.enter()

                        requestExhibition(photo.exhibitionId) { exhibition in
                            results[index] = (photo, exhibition)
                            group.leave()
                        }
                    }
                }

                group.wait()

                DispatchQueue.main.async {
                    completion(results)
                }

            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }

    func requestExhibition(_ exhibitId: Int, completion: @escaping (Response.Exhibition) -> Void) {
        let url = "\(Request.baseURL)/exhibition/\(exhibitId)"

        AF.request(url)
            .response { response in
                if let data = response.data {
                    do {
                        let result = try Request.decoder.decode(Response.Exhibition.self, from: data)
                        completion(result)
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                }
            }
    }

    mutating func setLikePhotos(results: [Int: (Response.Photo, Response.Exhibition)]) {
        likes = results
    }
}

struct LikeExhibitionModel {
    private(set) var likeExhibitions: [Response.Exhibition] = []

    func requestLikeExhibitions(_ userId: Int, completion: @escaping ([Response.Exhibition]) -> Void) {
        let url = "\(Request.baseURL)/exhibition/\(userId)/likeExhibitions"

        AF.request(url)
            .response { response in
                if let data = response.data {
                    do {
                        let results = try Request.decoder.decode([Response.Exhibition].self, from: data)
                        completion(results)

                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                }
            }
    }

    mutating func setLikeExhibitions(results: [Response.Exhibition]) {
        likeExhibitions = results
    }
}

final class LikeViewModel: ObservableObject {
    @Published var photoLikeModel: LikePhotoModel = .init()
    @Published var exhibitionLikeModel: LikeExhibitionModel = .init()

    var photoLikes: [Int: (Response.Photo, Response.Exhibition)] {
        photoLikeModel.likes
    }

    var exhibitionLikes: [Response.Exhibition] {
        exhibitionLikeModel.likeExhibitions
    }

    func requestLikePhotos() {
        photoLikeModel.requestLikePhotos(User.shared.userId) { results in
            self.photoLikeModel.setLikePhotos(results: results)
        }
    }

    func requestLikeExhibitions() {
        exhibitionLikeModel.requestLikeExhibitions(User.shared.userId) { results in
            self.exhibitionLikeModel.setLikeExhibitions(results: results)
        }
    }
}
