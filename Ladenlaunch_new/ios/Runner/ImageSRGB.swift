import UIKit
import Flutter

public class ImageSRGB: NSObject {
  @objc static func convertToSRGB(_ path: String) -> String {
    let url = URL(fileURLWithPath: path)

    guard let data = try? Data(contentsOf: url),
          let image = UIImage(data: data) else {
      return path
    }

    // Draw into sRGB context
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    format.opaque = false
    format.preferredRange = .standard // forces sRGB

    let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
    let sRGBImage = renderer.image { _ in
      image.draw(at: .zero)
    }

    let jpegData = sRGBImage.jpegData(compressionQuality: 1)!
    let newPath = path.replacingOccurrences(of: ".heic", with: ".jpg")

    try? jpegData.write(to: URL(fileURLWithPath: newPath))

    return newPath
  }
}
