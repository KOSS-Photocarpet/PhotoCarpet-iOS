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
        print("url : \(url)")
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept": "application/json"])
            .response { response in
                if let data = response.data {
                    let formatter = DateFormatter()
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
                        let data = try decoder.decode(Response.SearchResult<T>.self, from: data)
                        print("data: \(data)")
                        print("data result: \(data.result)")
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
                    } catch let DecodingError.typeMismatch(type, context)  {
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
