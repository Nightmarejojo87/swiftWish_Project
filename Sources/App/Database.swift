import Foundation
import SQLite

class Database {
    private let db: Connection

    // 1. Définition de la table et des colonnes avec des expressions typées 
    private let watchlistTable = Table("watchlist")
    private let id = Expression<Int>("id")
    private let title = Expression<String>("title")
    private let genre = Expression<String>("genre")
    private let status = Expression<String>("status")
    private let rating = Expression<Int>("rating")

    // Initialisation de la connexion et création de la table
    init(dbPath: String = "watchlist.sqlite3") throws {
        db = try Connection(dbPath)
        try createTable()
    }

    private func createTable() throws {
        // Crée la table si elle n'existe pas déjà
        try db.run(watchlistTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(title)
            t.column(genre)
            t.column(status)
            t.column(rating)
        })
    }

    // --- OPÉRATIONS CRUD ---
    // Utilisation de async/await et throws pour la gestion des erreurs 

    // C - CREATE : Ajouter un nouvel élément à la base de données [cite: 42, 47]
    func createItem(item: WatchlistItem) async throws {
        let insert = watchlistTable.insert(
            title <- item.title,
            genre <- item.genre,
            status <- item.status,
            rating <- item.rating
        )
        try db.run(insert)
    }

    // R - READ : Récupérer tous les éléments pour la page principale [cite: 42, 47]
    func getItems() async throws -> [WatchlistItem] {
        var items: [WatchlistItem] = []
        
        for row in try db.prepare(watchlistTable) {
            let watchlistItem = WatchlistItem(
                id: row[id],
                title: row[title],
                genre: row[genre],
                status: row[status],
                rating: row[rating]
            )
            items.append(watchlistItem)
        }
        return items
    }

    // U - UPDATE : Mettre à jour un élément existant [cite: 42, 47]
    func updateItem(itemId: Int, updatedItem: WatchlistItem) async throws {
        let itemToUpdate = watchlistTable.filter(id == itemId)
        let update = itemToUpdate.update(
            title <- updatedItem.title,
            genre <- updatedItem.genre,
            status <- updatedItem.status,
            rating <- updatedItem.rating
        )
        try db.run(update)
    }

    // D - DELETE : Supprimer un élément de la base de données [cite: 42, 47]
    func deleteItem(itemId: Int) async throws {
        let itemToDelete = watchlistTable.filter(id == itemId)
        try db.run(itemToDelete.delete())
    }
}