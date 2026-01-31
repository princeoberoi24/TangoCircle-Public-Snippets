//
//  FileManagerHelper.swift
//  TaskTango
//
//  Created by mac on 18/11/25.
//

import UIKit
import Foundation

struct FileManagerHelper {
    
    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static func saveImageLocally(image: UIImage, fileName: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            print("Successfully saved image to: \(fileURL.path)")
            // Return the raw path string
            return fileURL.path
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return nil
        }
    }
    
    // ✅ FIX: Use Data(contentsOf:) which is more reliable than UIImage(contentsOfFile:)
    static func loadImageLocally(filePath: String) -> UIImage? {
        let url = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("Error loading image data from URL: \(error.localizedDescription)")
            return nil
        }
    }
}



