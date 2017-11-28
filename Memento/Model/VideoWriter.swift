//
//  VideoWritter.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-27.
//  Copyright © 2017 memTech. All rights reserved.
//

import AVFoundation
import UIKit
import Photos

class VideoWriter {
    
    
    
    
    func appendPixelBufferForImageAtURL(image: UIImage, pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor, presentationTime: CMTime) -> Bool {
        var appendSucceeded = false
        
        autoreleasepool {
            // Create an empty CVPixelBuffer pool from the pixel buffer adopter's pool
            if  let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool {
                let pixelBufferPointer = UnsafeMutablePointer<CVPixelBuffer?>.allocate(capacity: 1)
                let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(
                    kCFAllocatorDefault,
                    pixelBufferPool,
                    pixelBufferPointer
                )
                
                if let pixelBuffer = pixelBufferPointer.pointee, status == 0 {
                    // Get the CVPixelBuffer for the current video sample
                    // Create a new CIImage from the pixel buffer
                    fillPixelBufferFromImage(image: image, pixelBuffer: pixelBuffer)
                    appendSucceeded = pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                    pixelBufferPointer.deinitialize()
                } else {
                    NSLog("Error: Failed to allocate pixel buffer from pool")
                }
                
                pixelBufferPointer.deallocate(capacity: 1)
            }
        }
        
        return appendSucceeded
    }
    func fillPixelBufferFromImage(image: UIImage, pixelBuffer: CVPixelBuffer) {
        // Lock the pixel buffer to access it
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        // Get pixel buffer base address
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bpr = Int((4 * image.size.width))
        print("\nBPR: \(bpr)\n")
        // Create CGBitmapContext
        let context = CGContext(
            data: pixelData,
            width: Int(image.size.width),
            height: Int(image.size.height),
            bitsPerComponent: 8,
            bytesPerRow: Int(bpr),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )
        print("Drawing image into context")
        // Draw image into context
        context?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    }
    
    func saveVideoToLibrary(videoURL: NSURL) {
        PHPhotoLibrary.requestAuthorization { status in
            // Return if unauthorized
            guard status == .authorized else {
                print("Error saving video: unauthorized access")
                return
            }
            
            // If here, save video to library
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL as URL)
            }) { success, error in
                if !success {
                    print("Error saving video: \(error!)")
                }
            }
        }
    }
    func createAssetWriter(path: String, size: CGSize) -> AVAssetWriter? {
        // Convert <path> to NSURL object
        let pathURL = NSURL(fileURLWithPath: path)
        
        // Return new asset writer or nil
        do {
            // Create asset writer passing it the output URL where it should
            // write the output file and file type

            let newWriter = try AVAssetWriter(outputURL: pathURL as URL, fileType: AVFileType.mp4)
            var videoSettings: [String : AnyObject] = [:]
            // Define settings for video input
            if #available(iOS 11.0, *) {
              videoSettings  = [
                    AVVideoCodecKey  : AVVideoCodecType.h264 as AnyObject,
                    AVVideoWidthKey  : size.width as AnyObject,
                    AVVideoHeightKey : size.height as AnyObject
                ]
            } else {
                // Fallback on earlier versions
                videoSettings = [
                    AVVideoCodecKey  : AVVideoCodecH264 as AnyObject,
                    AVVideoWidthKey  : size.width as AnyObject,
                    AVVideoHeightKey : size.height as AnyObject
                ]
            }

            
            // Create a new AVAssetWriterInput to append the samples comming from
            // AVCaptureVideoDataOuput - passing it a media type of AVMediaType.video
            // and the video setting created above
            
            let assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
            // Add video input to writer
            assert(newWriter.canAdd(assetWriterVideoInput) == true, "assetWriterVideoInput cannot be added")
            newWriter.add(assetWriterVideoInput)
            
            
            // Return writer
            print("Created asset writer for \(size.width)x\(size.height) video")
            return newWriter
        } catch {
            print("Error creating asset writer: \(error)")
            return nil
        }
    }
    // --------------------------------------------------------------- //
    // This function is called to create video from array of UIImages  //
    // inputs:
    // allImages: array of UIImages : [UIImage]
    // videoPath: path to save the output file : String
    // videoSize: size of video : CGSize
    // videoFPS: video frame per second rate : Int32
    // --------------------------------------------------------------- //
    
    func writeImagesAsMovie(allImages: [UIImage], videoPath: String, videoSize: CGSize, videoFPS: Int32) {
        // Create AVAssetWriter to write video
        guard let assetWriter = createAssetWriter(path: videoPath, size: videoSize) else {
            print("Error converting images to video: AVAssetWriter not created")
            return
        }
        
        // If here, AVAssetWriter exists so create AVAssetWriterInputPixelBufferAdaptor
        let writerInput = assetWriter.inputs.filter{ $0.mediaType == AVMediaType.video }.first!
        //print("Writer input:  \(writerInput)")
        // Define a dictionary of attributes used to configure the AVAssetWriterInputPixelBufferAdaptor
        // The values in this dictionary should corespond to the source pixel format that was used when
        // configuring the AVCaptureVideoDataOutput

        let sourceBufferAttributes : [String : AnyObject] = [
            kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : kCVPixelFormatType_32BGRA as AnyObject,
            //kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32ARGB) as AnyObject,
            kCVPixelBufferWidthKey as String : videoSize.width as AnyObject,
            kCVPixelBufferHeightKey as String : videoSize.height as AnyObject,
            kCVPixelFormatOpenGLESCompatibility as String : kCFBooleanTrue
        ]

        //print("Source buffer attribute: \(sourceBufferAttributes)")
        // Create a new AVAssetWriterInputPixelBufferAdaptor - passing it the above attributes
        // This object provides and optimized CVPixelBufferPool that will be used for creating
        // CVPixelBuffer object for rendering video frames
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: sourceBufferAttributes)
        //print("pixel buffer apaptor: \(pixelBufferAdaptor)")
        
        // Start writing session
        if assetWriter.startWriting(){
            print("Starting a session ...")
            assetWriter.startSession(atSourceTime: kCMTimeZero)
        }
        else{
            print("Failed to start writing")
            return
        }
        //print(assetWriter.startSession(atSourceTime: kCMTimeZero))
        //assetWriter.startSession(atSourceTime: kCMTimeZero)
        if (pixelBufferAdaptor.pixelBufferPool == nil) {
            print("Error converting images to video: pixelBufferPool nil after starting session")
            
            return
        }
        
        // -- Create queue for <requestMediaDataWhenReadyOnQueue>
        let mediaQueue = DispatchQueue(label: "mediaInputQueue")
        
        // -- Set video parameters
        let frameDuration = CMTimeMake(1, videoFPS)
        var frameCount = 0
        
        // -- Add images to video
        let numImages = allImages.count
        writerInput.requestMediaDataWhenReady(on: mediaQueue, using: { () -> Void in
            // Append unadded images to video but only while input ready
            while (writerInput.isReadyForMoreMediaData && frameCount < numImages) {
                let lastFrameTime = CMTimeMake(Int64(frameCount), videoFPS)
                let presentationTime = frameCount == 0 ? lastFrameTime : CMTimeAdd(lastFrameTime, frameDuration)
                
                if !self.appendPixelBufferForImageAtURL(image: allImages[frameCount], pixelBufferAdaptor: pixelBufferAdaptor, presentationTime: presentationTime) {
                    print("Error converting images to video: AVAssetWriterInputPixelBufferAdapter failed to append pixel buffer")
                    return
                }
                
                frameCount += 1
            }
            
            // No more images to add? End video.
            if (frameCount >= numImages) {
                writerInput.markAsFinished()
                assetWriter.finishWriting {
                    if (assetWriter.error != nil) {
                        print("Error converting images to video: \(assetWriter.error!)")
                    } else {
                        self.saveVideoToLibrary(videoURL: NSURL(fileURLWithPath: videoPath))
                        print("Converted images to movie @ \(videoPath)")
                    }
                }
            }
        })
    }
}
