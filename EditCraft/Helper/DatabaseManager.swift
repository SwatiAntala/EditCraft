//
//  DatabaseManager.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    private init() { }
    
    static var sharedInstance = DatabaseManager()
   
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context:", error)
        }
    }
    
    // MARK: - CloneApp Methods
    // Existing CloneApp methods go here...

    // MARK: - ECVideo Methods
    
    func addECVideo(_ ecVideo: ECVideo) {
        let entity = Video(context: context)
        configureECVideoEntity(entity, with: ecVideo)
        saveContext()
    }
    
    func updateECVideo(_ ecVideo: ECVideo) {
        guard let entity = fetchECVideoEntityByID(id: ecVideo.id) else {
            print("ECVideo with ID \(ecVideo.id) not found")
            return
        }
        configureECVideoEntity(entity, with: ecVideo)
        saveContext()
    }
    
    func deleteECVideo(_ ecVideo: ECVideo) {
        guard let entity = fetchECVideoEntityByID(id: ecVideo.id) else {
            print("ECVideo with ID \(ecVideo.id) not found")
            return
        }
        context.delete(entity)
        saveContext()
    }
    
    func fetchECVideos() -> [ECVideo] {
        var ecVideos: [ECVideo] = []
        
        do {
            let entities = try context.fetch(Video.fetchRequest()) as! [Video]
            ecVideos = entities.map { entity in
                return ECVideo(
                    id: entity.id ?? .init(),
                    url: entity.videoURL ?? "", 
                    thumImage: entity.thumbImg,
                    assetIdentifier: entity.assetIdentifier ?? "",
                    duration: entity.duration ?? ""
                )
            }
        } catch {
            print("Error fetching ECVideo entities: \(error)")
        }
        
        return ecVideos
    }
    
    private func fetchECVideoEntityByID(id: UUID) -> Video? {
        let request: NSFetchRequest<Video> = Video.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching ECVideoEntity by ID: \(error)")
            return nil
        }
    }
    
    private func configureECVideoEntity(_ entity: Video, with ecVideo: ECVideo) {
        entity.id = ecVideo.id
        entity.videoURL = ecVideo.url
        entity.thumbImg = ecVideo.thumImage
        entity.assetIdentifier = ecVideo.assetIdentifier
        entity.duration = ecVideo.duration
    }
}

extension DatabaseManager {
    
    func getEditVideoList() -> [ECVideo] {
        fetchECVideos()
    }
}
