import Foundation
import SQLite

actor Database {
    private let db: Connection
    
    // Expressions typées pour éviter le SQL brut
    private let watchlistTable = Table("watchlist")
    private let id = Expression<Int>("id")
    private let title = Expression<String>("title")
    private let genre = Expression<String>("genre")
    private let status = Expression<String>("status")
    private let rating = Expression<Int>("rating")

    init(dbPath: String = "watchlist.sqlite3") throws {
        db = try Connection(dbPath)
        
        // Création de la table
        try db.run(watchlistTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(title)
            t.column(genre)
            t.column(status)
            t.column(rating)
        })
    }

    // --- OPÉRATIONS CRUD ---

    func createItem(item: WatchlistItem) throws {
        let insert = watchlistTable.insert(
            title <- item.title,
            genre <- item.genre,
            status <- item.status,
            rating <- item.rating
        )
        try db.run(insert)
    }

    func getItems() throws -> [WatchlistItem] {
        var items: [WatchlistItem] = []
        for row in try db.prepare(watchlistTable) {
            let item = WatchlistItem(
                id: row[id], title: row[title], genre: row[genre], status: row[status], rating: row[rating]
            )
            items.append(item)
        }
        return items
    }

    func updateItem(itemId: Int, updatedItem: WatchlistItem) throws {
        let itemToUpdate = watchlistTable.filter(id == itemId)
        try db.run(itemToUpdate.update(
            title <- updatedItem.title,
            genre <- updatedItem.genre,
            status <- updatedItem.status,
            rating <- updatedItem.rating
        ))
    }

    func updateStatus(itemId: Int, newStatus: String) throws {
        let itemToUpdate = watchlistTable.filter(id == itemId)
        try db.run(itemToUpdate.update(status <- newStatus))
    }

    func deleteItem(itemId: Int) throws {
        let itemToDelete = watchlistTable.filter(id == itemId)
        try db.run(itemToDelete.delete())
    }
}