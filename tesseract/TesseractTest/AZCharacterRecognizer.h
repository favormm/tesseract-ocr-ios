//
//  AZCharacterRecognizer.h
//  tesseract
//
//  Created by Alexander Persson on 2011-07-18.
//  Copyright 2011 Alexander Persson. All rights reserved.
//

typedef void (^AZCharacterRecognitionResultBlock)(NSString* result);

@interface AZCharacterRecognizer : NSObject {
 @protected
    NSString* dataPath_;
    void* tesseract_;
    
    NSOperationQueue* operations_;
}

/**
 @brief Designated initializer.
 */
- (id)initWithTesseractDataPath:(NSString*)path language:(NSString*)language;

/** 
 @brief Sets which characters are whitelisted. No other characters will be 
 returned to the delegate.
 */
- (void)setWhitelist:(NSString*)whitelist;

/**
 @brief Will attempt to perform Optical Character Recognition on the image
 provided.
 */
- (void)attemptCharacterRecognitionOnImage:(UIImage*)image result:(AZCharacterRecognitionResultBlock)result;

@end
