# 🎬 Watchlist App - Swift CRUD Web App

## 📝 Description du projet
SwiftWish est une application web CRUD (Créer, Lire, Mettre à jour, Supprimer) développée intégralement en Swift. Elle permet aux utilisateurs de gérer leur propre liste de films et séries à regarder. 

L'application utilise le framework web Hummingbird 2 pour la gestion des requêtes HTTP et une base de données SQLite pour la persistance des données. L'interface utilisateur est générée dynamiquement côté serveur en HTML et stylisée avec le framework Pico CSS. Ce projet a été conçu pour s'exécuter dans l'environnement GitHub Codespaces.

## 🛣️ Liste des routes exposées
Cette application expose les routes HTTP suivantes pour gérer les opérations CRUD:

* **`GET /`** : Affiche la page principale avec la liste complète des films/séries et le formulaire permettant d'ajouter un nouvel élément.
**`POST /create`** : Reçoit les données du formulaire HTML et ajoute un nouvel élément à la base de données.
**`POST /update/:id`** : Met à jour les champs d'un élément existant en fonction de son identifiant.
**`POST /delete/:id`** : Supprime définitivement l'élément de la base de données correspondant à l'identifiant fourni.
* **`POST /toggle-status/:id`** : Route additionnelle permettant de modifier rapidement le statut de visionnage d'un film (ex: de "À voir" à "En cours").

## 🚀 Instructions d'utilisation
Ce projet est configuré pour fonctionner directement dans GitHub Codespaces. Les scripts de base n'ont pas été modifiés et le projet compile avec succès.

1. **Compiler le projet :**
   Ouvrez le terminal de Codespaces et exécutez le script de build :
   `./build.sh`

2. **Lancer le serveur :**
   Une fois la compilation terminée, lancez l'application web avec la commande :
   `./run.sh`

3. **Accéder à l'application :**
   Codespaces affichera une notification indiquant que le port 8080 a été ouvert. Cliquez sur le lien fourni par l'environnement pour accéder à l'interface HTML de la Watchlist dans votre navigateur.
