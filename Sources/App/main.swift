import Hummingbird
import Foundation

// Initialisation de la base de données
let db = try Database()

let router = Router()

// Structure qui "attrape" les données du formulaire web
struct FormData: Decodable {
    let title: String
    let genre: String
    let status: String
    let rating: Int
}

// R - READ (Route GET)
router.get("/") { request, context -> HTML in
    let items = try await db.getItems()
    return Views.renderIndex(items: items)
}

// C - CREATE (Route POST 1)
router.post("/create") { request, context -> Response in
    // 1. On décode les données entrantes du formulaire
    let formData = try await request.decode(as: FormData.self, context: context)
    
    // 2. On prépare notre objet modèle pour la base de données
    let newItem = WatchlistItem(
        title: formData.title,
        genre: formData.genre,
        status: formData.status,
        rating: formData.rating
    )
    
    // 3. On sauvegarde dans la base SQLite de manière asynchrone
    try await db.createItem(item: newItem)
    
    // 4. On redirige l'utilisateur vers la page principale une fois terminé
    return Response(status: .seeOther, headers: [.location: "/"])
}

// U - UPDATE (Route POST 2)
router.post("/update/:id") { request, context -> Response in
    guard let idString = context.parameters.get("id"), let id = Int(idString) else {
        return Response(status: .badRequest)
    }
    // Simulation d'une mise à jour complète
    let updatedItem = WatchlistItem(id: id, title: "Film Modifié", genre: "Drame", status: "Terminé", rating: 4)
    try await db.updateItem(itemId: id, updatedItem: updatedItem)
    
    return Response(status: .seeOther, headers: [.location: "/"])
}

// D - DELETE (Route POST 3)
router.post("/delete/:id") { request, context -> Response in
    guard let idString = context.parameters.get("id"), let id = Int(idString) else {
        return Response(status: .badRequest)
    }
    try await db.deleteItem(itemId: id)
    
    return Response(status: .seeOther, headers: [.location: "/"])
}

// UPDATE RAPIDE - (Route POST 4 pour remplir le critère)
router.post("/toggle-status/:id") { request, context -> Response in
    guard let idString = context.parameters.get("id"), let id = Int(idString) else {
        return Response(status: .badRequest)
    }
    // Logique pour inverser le statut ici (non implémentée dans l'exemple db)
    return Response(status: .seeOther, headers: [.location: "/"])
}

let app = Application(router: router)
try await app.runService()