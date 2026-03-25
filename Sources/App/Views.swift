import Foundation
import Hummingbird

struct HTML: ResponseGenerator {
    let html: String
    func response(from request: Request, context: some RequestContext) throws -> Response {
        return Response(
            status: .ok,
            headers: [.contentType: "text/html; charset=utf-8"],
            body: .init(byteBuffer: ByteBuffer(string: html))
        )
    }
}

enum Views {
    static func renderIndex(items: [WatchlistItem]) -> HTML {
        var rows = ""
        
        for item in items {
            let itemId = item.id ?? 0
            // Logique pour le bouton de statut rapide
            let nextStatus = item.status == "À voir" ? "En cours" : (item.status == "En cours" ? "Terminé" : "À voir")
            
            rows += """
            <tr>
                <td>\(item.title)</td>
                <td>\(item.genre)</td>
                <td>\(item.status)</td>
                <td>\(item.rating)/10</td>
                <td>
                    <form action="/toggle-status/\(itemId)" method="POST" style="display:inline;">
                        <input type="hidden" name="status" value="\(nextStatus)">
                        <button type="submit" class="secondary outline" style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Passer à '\(nextStatus)'</button>
                    </form>
                    <form action="/delete/\(itemId)" method="POST" style="display:inline;">
                        <button type="submit" class="contrast outline" style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Supprimer</button>
                    </form>
                </td>
            </tr>
            """
        }
        
        let document = """
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="UTF-8">
            <title>Ma Watchlist</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
        </head>
        <body>
            <main class="container">
                <h1>🎬 Ma Watchlist</h1>
                
                <section>
                    <h2>Mes Films & Séries</h2>
                    <table class="striped">
                        <thead>
                            <tr>
                                <th>Titre</th>
                                <th>Genre</th>
                                <th>Statut</th>
                                <th>Note</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            \(rows.isEmpty ? "<tr><td colspan='5'>Aucun film pour le moment.</td></tr>" : rows)
                        </tbody>
                    </table>
                </section>
                
                <hr>
                
                <section>
                    <h2>Ajouter un élément</h2>
                    <form action="/create" method="POST">
                        <div class="grid">
                            <input type="text" name="title" placeholder="Titre du film" required>
                            <input type="text" name="genre" placeholder="Genre" required>
                        </div>
                        <div class="grid">
                            <select name="status" required>
                                <option value="À voir" selected>À voir</option>
                                <option value="En cours">En cours</option>
                                <option value="Terminé">Terminé</option>
                            </select>
                            <input type="number" name="rating" placeholder="Note sur 10" min="0" max="" required>
                        </div>
                        <button type="submit">Ajouter à la liste</button>
                    </form>
                </section>
            </main>
        </body>
        </html>
        """
        
        return HTML(html: document)
    }
}