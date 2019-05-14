//
//  PEYDefines.h
//  PerspectiveEye
//
//  Created by yasic on 2019/5/6.
//

#import "NSArray+PEYCollectionOperation.h"
#import "NSDictionary+PEYCollectionOperation.h"

#ifndef PEYDefines_h
#define PEYDefines_h

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define HEXCOLOR(hexValue) HEXACOLOR(hexValue, 1.0)
#define HEXACOLOR(hexValue, alphaValue) [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:(alphaValue)]

#ifndef Font
#define Font(x) [UIFont systemFontOfSize:x]
#endif

#ifndef BoldFont
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]
#endif

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#endif /* PEYDefines_h */
