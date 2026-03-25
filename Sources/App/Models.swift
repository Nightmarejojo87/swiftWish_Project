import Foundation

struct WatchlistItem: Codable, Sendable {
    var id: Int? // Optionnel car généré automatiquement par la base de données
    var title: String
    var genre: String
    var status: String
    var rating: Int
}