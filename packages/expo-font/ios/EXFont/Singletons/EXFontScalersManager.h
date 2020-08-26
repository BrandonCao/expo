// Copyright 2018-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

@protocol EXFontScaler

- (UIFont *)scaledFont:(UIFont *)font toSize:(CGFloat)fontSize;

@end

@interface EXFontScalersManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerFontScaler:(id<EXFontScaler>)scaler;

@end
