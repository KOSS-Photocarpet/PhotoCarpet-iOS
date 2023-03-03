//
//  SearchAPI.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/28.
//

import Alamofire
import Foundation

enum SearchType: String {
    case artist
    case exhibition
}

class SearchViewModel: ObservableObject {
    @Published var artists = [Response.Artist]()
    @Published var exhibitions = [Response.Exhibition]()

    func fetchSearch<T: Codable>(_ dump: T.Type, _ searchType: SearchType, _ keyword: String) {
        let url = "\(Request.baseURL)/search/\(searchType.rawValue)/\(keyword)"

        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept": "application/json"])
            .response { response in
                if let data = response.data {
                    let formatter = DateFormatter()

                    do {
                        let data = try Request.decoder.decode(Response.SearchResult<T>.self, from: data)
                        if let result = data.result as? [Response.Artist] {
                            print("artist: \(result)")
                            self.artists = result
                        } else if let result = data.result as? [Response.Exhibition] {
                            print("exhibition: \(result)")
                            self.exhibitions = result
                        }

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
            .resume()
    }
}
