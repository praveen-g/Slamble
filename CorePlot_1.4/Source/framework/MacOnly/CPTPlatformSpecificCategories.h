#import "CPTColor.h"
#import "CPTLayer.h"
#import "CPTPlatformSpecificDefines.h"

#pragma mark CPTLayer

/** @category CPTLayer(CPTPlatformSpecificLayerExtensions)
 *  @brief Platform-specific extensions to CPTLayer.
 **/
@interface CPTLayer(CPTPlatformSpecificLayerExtensions)

/// @name Images
/// @{
-(CPTNativeImage *)imageOfLayer;
/// @}

@end

#pragma mark - CPTColor

/** @category CPTColor(CPTPlatformSpecificColorExtensions)
 *  @brief Platform-specific extensions to CPTColor.
 **/
@interface CPTColor(CPTPlatformSpecificColorExtensions)

@property (nonatomic, readonly, retain) NSColor *nsColor;

@end

#pragma mark - NSAttributedString

/** @category NSAttributedString(CPTPlatformSpecificAttributedStringExtensions)
 *  @brief NSAttributedString extensions for drawing styled text.
 **/
@interface NSAttributedString(CPTPlatformSpecificAttributedStringExtensions)

/// @name Drawing
/// @{
-(void)drawInRect:(CGRect)rect inContext:(CGContextRef)context;
/// @}

@end
