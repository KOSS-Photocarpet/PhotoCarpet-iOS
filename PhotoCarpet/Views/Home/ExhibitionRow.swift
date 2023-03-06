//
//  ExhibitionRow.swift
//  PhotoCarpet
//
//  Created by 이준호 on 2023/02/21.
//  Updated by 최정민 on 2023/02/28.
//

import Alamofire
import SwiftUI

final class ExhibitionRowViewModel: ObservableObject {
    @Published var exhibitions: [Response.Exhibition] = []

    enum RequestType: String {
        case recent
        case trend = "morelike"
    }

    // ViewModel 외부에서 함수를 만들어 이를 호출했을 때, API 요청이 비동기로 작동하고, 기존 함수에는 반환값을 넘겨주는 형식이였으나
    // 비동기로 작동하는 특성때문에 ViewModel 안의 프로퍼티에 접근해서 변경하는 방식으로 바꿈
    // 이를 해결하는 방법은 콜백함수를 사용하거나, 세마포어나 뮤텍스와 같은 동기화 도구를 사용하는 방법도 있을 것 같다.
    // 준호형 보고있지..? - from 정민
    func requestExhibitions(_ type: RequestType) {
        AF.request(Request.baseURL + "/exhibition/\(User.shared.userId)/likeExhibitions")
            .response { response in
                var likeExhibtions: [Response.Exhibition] = []
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
                        let result = try decoder.decode([Response.Exhibition].self, from: data)
                        likeExhibtions = result
                    } catch {
                        debugPrint(String(describing: error))
                    }
                }

                AF.request(Request.baseURL + "/exhibition/" + type.rawValue)
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
                                var result = try decoder.decode([Response.Exhibition].self, from: data)

                                var hashtags: [Int: [String]] = [:]
                                let queue = DispatchQueue(label: "get_tags", attributes: .concurrent)
                                let group = DispatchGroup()

                                queue.async(group: group) {
                                    for index in 0 ..< result.count {
                                        group.enter()
                                        AF.request(Request.baseURL + "/exhibition/withhashtag/\(result[index].exhibitId)")
                                            .response(queue: queue) { response in
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
                                                        let exhibition = try decoder.decode(Response.Exhibition.self, from: data)
                                                        hashtags[index] = exhibition.moodContents ?? []
                                                    } catch {
                                                        debugPrint(String(describing: error))
                                                    }
                                                }
                                                group.leave()
                                            }
                                    }
                                }

                                group.notify(queue: .main) {
                                    for index in 0 ..< result.count {
                                        let exhibition = result[index]
                                        result[index] = Response.Exhibition(
                                            exhibitId: exhibition.exhibitId,
                                            title: exhibition.title,
                                            content: exhibition.content,
                                            likeCount: exhibition.likeCount,
                                            exhibitionDate: exhibition.exhibitionDate,
                                            thumbUrl: exhibition.thumbUrl,
                                            user: exhibition.user,
                                            moodContents: hashtags[index] ?? [],
                                            liked: false)
                                        for likeExhibtion in likeExhibtions {
                                            if result[index].exhibitId == likeExhibtion.exhibitId {
                                                result[index] = Response.Exhibition(
                                                    exhibitId: exhibition.exhibitId,
                                                    title: exhibition.title,
                                                    content: exhibition.content,
                                                    likeCount: exhibition.likeCount,
                                                    exhibitionDate: exhibition.exhibitionDate,
                                                    thumbUrl: exhibition.thumbUrl,
                                                    user: exhibition.user,
                                                    moodContents: hashtags[index] ?? [],
                                                    liked: true)
                                                break
                                            }
                                        }
                                    }
                                    self.exhibitions = result
                                }
                            } catch {
                                debugPrint(String(describing: error))
                            }
                        }
                    }
            }
    }
}

struct ExhibitionRow: View {
    @ObservedObject private var viewModel: ExhibitionRowViewModel = .init()
    var categoryName: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .padding(.leading, 15)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.exhibitions.indices, id: \.self) { index in
                        NavigationLink {
                            ExhibitionMainView(viewModel.exhibitions[index])
                        } label: {
                            ExhibitionItem(viewModel.exhibitions[index])
                        }
                    }
                }
                .padding(.leading, 15)
            }
        }
        .task {
            if categoryName == "Recent" {
                viewModel.requestExhibitions(.recent)
            } else {
                viewModel.requestExhibitions(.trend)
            }
        }
    }
}

struct ExhibitionRow_Previews: PreviewProvider {
    static var previews: some View {
        ExhibitionRow(categoryName: "Trend")
    }
}
