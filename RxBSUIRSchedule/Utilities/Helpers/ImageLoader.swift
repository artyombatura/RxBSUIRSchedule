//
//  ImageLoader.swift
//  RxBSUIRSchedule
//
//  Created by Artsiom Batura on 10/8/20.
//

import UIKit
import RxSwift

enum ImageLoader {
    enum ImageLoaderError: Error {
        case ImageLoadingFailure
    }

    public static func loadImage(from url: URL) -> Single<UIImage> {
        return Single<UIImage>.create { (single) -> Disposable in
            let queue = DispatchQueue(label: "image.loading.queue", qos: .utility)
            
            queue.async {
                do {
                    let data = try Data(contentsOf: url)
                    guard let image = UIImage(data: data) else { return }
                    
                    single(.success(image))
                } catch {
                    single(.error(ImageLoaderError.ImageLoadingFailure))
                }
            }
            
            return Disposables.create()
        }
    }
}

