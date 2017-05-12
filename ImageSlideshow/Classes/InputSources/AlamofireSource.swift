//
//  AlamofireSource.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 14.01.16.
//
//

import Alamofire
import AlamofireImage

/// Input Source to image using Alamofire
@objcMembers
public class AlamofireSource: NSObject, InputSource {
    /// url to load
    public var url: URL
    public var lowResolutionUrl: URL?
  
    /// placeholder used before image is loaded
    public var placeholder: UIImage?

    /// Initializes a new source with a URL
    /// - parameter url: a url to load
    /// - parameter placeholder: a placeholder used before image is loaded
    public init(url: URL, lowResolutionUrl: URL?, placeholder: UIImage? = nil) {
        self.url = url
        self.lowResolutionUrl = lowResolutionUrl
        self.placeholder = placeholder
        super.init()
    }

    /// Initializes a new source with a URL string
    /// - parameter urlString: a string url to load
    /// - parameter placeholder: a placeholder used before image is loaded
    public init?(urlString: String, lowResolutionUrlString: String? = nil, placeholder: UIImage? = nil) {
        if let validUrl = URL(string: urlString) {
            self.url = validUrl
            self.placeholder = placeholder
          
            if let lowResUrlString = lowResolutionUrlString,
              let validLowResUrl = URL(string: lowResUrlString) {
                self.lowResolutionUrl = validLowResUrl
            }
          
            super.init()
        } else {
            return nil
        }
    }

    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void, lowResolutionCallback: ((UIImage?) -> Void)? = nil) {
      guard let lowResCallback = lowResolutionCallback,
        let lowResolutionUrl = lowResolutionUrl else {
        imageView.af_setImage(withURL: self.url, placeholderImage: placeholder, filter: nil, progress: nil) { (response) in
          callback(response.result.value)
        }
        return
      }
      imageView.af_setImage(withURL: lowResolutionUrl, placeholderImage: placeholder, filter: nil, progress: nil) { (response) in
        lowResCallback(response.result.value)
        imageView.af_setImage(withURL: self.url, placeholderImage: self.placeholder, filter: nil, progress: nil) { (response) in
          callback(response.result.value)
        }
      }
    }

    public func cancelLoad(on imageView: UIImageView) {
        imageView.af_cancelImageRequest()
    }
}
