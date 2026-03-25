import Foundation

struct WatchlistItem: Codable, Sendable {
    var id: Int?
    var title: String
    var genre: String
    var status: String
    var rating: Int
}