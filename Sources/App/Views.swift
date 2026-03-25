import Foundation
import Hummingbird

// On crée une structure pour envelopper le HTML afin que Hummingbird puisse le renvoyer
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
    // Fonction qui génère la page principale avec la liste et le formulaire d'ajout
    static func renderIndex(items: [WatchlistItem]) -> HTML {
        var rows = ""
        
        // Boucle pour générer dynamiquement les données 
        for item in items {
            let itemId = item.id ?? 0
            rows += """
            <tr>
                <td>\(item.title)</td>
                <td>\(item.genre)</td>
                <td>\(item.status)</td>
                <td>\(item.rating)/5</td>
                <td>
                    <form action="/delete/\(itemId)" method="POST" style="display:inline;">
                        <button type="submit" class="secondary outline">Supprimer</button>
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
                            \(rows)
                        </tbody>
                    </table>
                </section>
                
                <hr>
                
                <section>
                    <h2>Ajouter un élément</h2>
                    <form action="/create" method="POST">
                        <input type="text" name="title" placeholder="Titre du film" required>
                        <input type="text" name="genre" placeholder="Genre" required>
                        <select name="status">
                            <option value="À voir">À voir</option>
                            <option value="En cours">En cours</option>
                            <option value="Terminé">Terminé</option>
                        </select>
                        <input type="number" name="rating" placeholder="Note sur 5" min="1" max="5" required>
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