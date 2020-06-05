//
//  FetchPhotoOperation.swift
//  Astronomy
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    //MARK: - Properties -
    let photoRef: MarsPhotoReference
    var imageData: Data?
    var photoTask: URLSessionDataTask?
    
    
    //MARK: - Inits -
    init(photoReference: MarsPhotoReference) {
        photoRef = photoReference
        super.init()
    }
    
    
    //MARK: - Actions -
    override func start() {
        state = .isExecuting
        
        let photoTaskURL = photoRef.imageURL.usingHTTPS!
        let fetchPhotos = URLSession.shared.dataTask(with: photoTaskURL) { data, _, error in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Something bad happened. We didn't get your photo: \(self.photoRef) \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned.")
                return
            }
            
            self.imageData = data
        }
        fetchPhotos.resume()
        photoTask = fetchPhotos
    }
    
    override func cancel() {
        photoTask?.cancel()
        super.cancel()
        print("Canceled operations for photo fetch.")
    }
    
    
}
