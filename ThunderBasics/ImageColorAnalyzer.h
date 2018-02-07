//
//  ImageColorAnalyzer.h
//  ColorArt
//
// Redistribution and use, with or without modification, are permitted provided that the following conditions are met:
//
// - Redistributions must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
// - Neither the name of Panic Inc nor the names of its contributors may be used to endorse or promote works derived from this software without specific prior written permission from Panic Inc.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL PANIC INC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Modified by David Schimon 1 / 2013

@import Foundation;
@import UIKit;

/**
 `ImageColorAnalyzer` Analyzes a `UIImage` and picks out its main colors
 */
@interface ImageColorAnalyzer : NSObject

/**
 @abstract A reference to the `UIImage` that is being Analyzed
 */
@property (nonatomic, readonly) UIImage *image;

/**
 @abstract A `UIColor` that represents the main color in the image
 @discussion e.g. If red is most prominent color in the image the primary color will be red
 */
@property (nonatomic, readonly) UIColor *primaryColor;

/**
 @abstract A `UIColor` that represents the secondary color in the image
 @discussion e.g. If red is the second most prominent color in the image the secondary color will be red
 */
@property (nonatomic, readonly) UIColor *secondaryColor;

/**
 @abstract The color of the text that should overlay the image. This color will normally be black or white
 */
@property (nonatomic, readonly) UIColor *detailColor;

@property (nonatomic, readonly) UIColor *backgroundColor;

/**
 Initializes the `ImageColorAnalyzer` with a `UIImage`
 @param image The `UIImage` to be color analyzed.
 @discussion The image will not be analyzed until the -(void)analyzeImage method is called
 */
- (id)initWithImage:(UIImage *)image;

/**
 Performs the image analysis
 */
- (void)analyzeImage;

@end