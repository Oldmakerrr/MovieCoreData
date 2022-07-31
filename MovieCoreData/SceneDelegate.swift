//
//  SceneDelegate.swift
//  MovieCoreData
//
//  Created by Apple on 31.07.2022.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coreData = CoreDataStack()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        checkData()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        coreData.saveContext()
    }

//MARK: - Private functions
        
        private func checkData() {
            let moc = coreData.persistentContainer.viewContext
            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            
            if let movieCount = try? moc.count(for: request), movieCount > 0 {
                return
            }
            
            uploadSampleData()
        }
        
        private func uploadSampleData() {
            let moc = coreData.persistentContainer.viewContext
            guard
                let url = Bundle.main.url(forResource: "movies", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary,
                let jsonArray = jsonResult.value(forKey: "movie") as? NSArray
            else { return }
            for json in jsonArray {
                guard
                    let movieData = json as? [String: AnyObject],
                    let title = movieData["name"] as? String,
                    let userRating = movieData["rating"],
                    let format = movieData["format"] as? String
                else { return }
                let movie = Movie(context: moc)
                movie.title = title
                movie.format = format
                movie.userRating = userRating.int16Value
                
                if let imageName = movieData["image"] as? String,
                   let image = UIImage(named: imageName),
                   let imageData = image.jpegData(compressionQuality: 1.0) {
                    
                    movie.image = imageData
                }
                
            }
            coreData.saveContext()
        }

}

