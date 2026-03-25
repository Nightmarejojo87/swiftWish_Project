import Hummingbird
import Foundation

// Structures pour décoder les formulaires HTML
struct FormData: Decodable {
    let title: String
    let genre: String
    let status: String
    let rating: Int
}

struct StatusFormData: Decodable {
    let status: String
}

// Initialisation de la base de données (Actor)
let db = try Database()
let router = Router()

// 1. GET - Afficher la page
router.get("/") { request, context -> HTML in
    let items = try await db.getItems()
    return Views.renderIndex(items: items)
}

// 2. POST - Créer un élément
router.post("/create") { request, context -> Response in
    // CORRECTION Hummingbird 2 ICI
    let formData = try await URLEncodedFormDecoder().decode(FormData.self, from: request, context: context)
    let newItem = WatchlistItem(title: formData.title, genre: formData.genre, status: formData.status, rating: formData.rating)
    try await db.createItem(item: newItem)
    return Response(status: .seeOther, headers: [.location: "/"])
}

// 3. POST - Supprimer un élément
router.post("/delete/:id") { request, context -> Response in
    guard let idString = context.parameters.get("id"), let id = Int(idString) else {
        return Response(status: .badRequest)
    }
    try await db.deleteItem(itemId: id)
    return Response(status: .seeOther, headers: [.location: "/"])
}

// 4. POST - Modifier le statut rapidement
router.post("/toggle-status/:id") { request, context -> Response in
    guard let idString = context.parameters.get("id"), let id = Int(idString) else {
        return Response(status: .badRequest)
    }
    // CORRECTION Hummingbird 2 ICI
    let formData = try await URLEncodedFormDecoder().decode(StatusFormData.self, from: request, context: context)
    try await db.updateStatus(itemId: id, newStatus: formData.status)
    return Response(status: .seeOther, headers: [.location: "/"])
}

// 5. POST - Route complète de mise à jour
router.post("/update/:id") { request, context -> Response in
    guard let idString = context.parameters.get("id"), let id = Int(idString) else {
        return Response(status: .badRequest)
    }
    // CORRECTION Hummingbird 2 ICI
    let formData = try await URLEncodedFormDecoder().decode(FormData.self, from: request, context: context)
    let updatedItem = WatchlistItem(id: id, title: formData.title, genre: formData.genre, status: formData.status, rating: formData.rating)
    try await db.updateItem(itemId: id, updatedItem: updatedItem)
    return Response(status: .seeOther, headers: [.location: "/"])
}

// Configuration pour Codespaces avec l'adresse 0.0.0.0
let app = Application(
    router: router,
    configuration: .init(address: .hostname("0.0.0.0", port: 8080))
)

try await app.runService()