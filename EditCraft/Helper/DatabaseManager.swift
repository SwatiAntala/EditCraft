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
}

// MARK: - ECVideo Methods
extension DatabaseManager {
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

// MARK: - ECPhoto Methods
extension DatabaseManager {
    func addECPhoto(_ ecPhoto: ECPhoto) {
        let entity = Photo(context: context)
        configureECPhotoEntity(entity, with: ecPhoto)
        saveContext()
    }
    
    func updateECPhoto(_ ecPhoto: ECPhoto) {
        guard let entity = fetchECPhotoEntityByID(id: ecPhoto.id) else {
            print("ECPhoto with ID \(ecPhoto.id) not found")
            return
        }
        configureECPhotoEntity(entity, with: ecPhoto)
        saveContext()
    }
    
    func deleteECPhoto(_ ecPhoto: ECPhoto) {
        guard let entity = fetchECPhotoEntityByID(id: ecPhoto.id) else {
            print("ECPhoto with ID \(ecPhoto.id) not found")
            return
        }
        context.delete(entity)
        saveContext()
    }
    
    func fetchECPhotos() -> [ECPhoto] {
        var ecPhotos: [ECPhoto] = []
        
        do {
            let entities = try context.fetch(Photo.fetchRequest()) as! [Photo]
            ecPhotos = entities.map { entity in
                return ECPhoto(
                    id: entity.id ?? .init(),
                    thumImage: entity.thumbImg,
                    assetIdentifier: entity.assetIdentifier ?? ""
                )
            }
        } catch {
            print("Error fetching ECPhoto entities: \(error)")
        }
        
        return ecPhotos
    }
    
    private func fetchECPhotoEntityByID(id: UUID) -> Photo? {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching ECPhotoEntity by ID: \(error)")
            return nil
        }
    }
    
    private func configureECPhotoEntity(_ entity: Photo, with ecPhoto: ECPhoto) {
        entity.id = ecPhoto.id
        entity.thumbImg = ecPhoto.thumImage
        entity.assetIdentifier = ecPhoto.assetIdentifier
    }
}

// MARK: - ECAudio Methods
extension DatabaseManager {
    func addECAudio(_ ecAudio: ECAudio) {
        let entity = Audio(context: context)
        configureECAudioEntity(entity, with: ecAudio)
        saveContext()
    }
    
    func updateECAudio(_ ecAudio: ECAudio) {
        guard let entity = fetchECAudioEntityByID(id: ecAudio.id) else {
            print("ECAudio with ID \(ecAudio.id) not found")
            return
        }
        configureECAudioEntity(entity, with: ecAudio)
        saveContext()
    }
    
    func deleteECAudio(_ ecAudio: ECAudio) {
        guard let entity = fetchECAudioEntityByID(id: ecAudio.id) else {
            print("ECAudio with ID \(ecAudio.id) not found")
            return
        }
        context.delete(entity)
        saveContext()
    }
    
    func fetchECAudios() -> [ECAudio] {
        var ecAudios: [ECAudio] = []
        
        do {
            let entities = try context.fetch(Audio.fetchRequest()) as! [Audio]
            ecAudios = entities.map { entity in
                return ECAudio(
                    id: entity.id ?? .init(),
                    audioURL: entity.audioURL ?? "",
                    thumImage: entity.thumImage,
                    duration: entity.duration ?? "",
                    name: entity.name ?? "",
                    size: entity.size ?? ""
                    
                )
            }
        } catch {
            print("Error fetching ECAudio entities: \(error)")
        }
        
        return ecAudios
    }
    
    private func fetchECAudioEntityByID(id: UUID) -> Audio? {
        let request: NSFetchRequest<Audio> = Audio.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching ECAudioEntity by ID: \(error)")
            return nil
        }
    }
    
    private func configureECAudioEntity(_ entity: Audio, with ecAudio: ECAudio) {
        entity.id = ecAudio.id
        entity.audioURL = ecAudio.audioURL
        entity.thumImage = ecAudio.thumImage
        entity.duration = ecAudio.duration
        entity.name = ecAudio.name
        entity.size = ecAudio.size
    }
}


extension DatabaseManager {
    
    func getEditVideoList() -> [ECVideo] {
        fetchECVideos()
    }
}

extension DatabaseManager {
    func getEditPhotoList() -> [ECPhoto] {
        fetchECPhotos()
    }
}


extension DatabaseManager {
    
    func getEditAudioList() -> [ECAudio] {
        fetchECAudios()
    }
}
