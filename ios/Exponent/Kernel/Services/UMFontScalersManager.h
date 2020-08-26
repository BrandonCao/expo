// Copyright 2018-present 650 Industries. All rights reserved.

#import <UMCore/UMSingletonModule.h>
#import <UIKit/UIKit.h>

@protocol UMFontScaler

- (UIFont *)scaledFont:(UIFont *)font toSize:(CGFloat)fontSize;

@end

@protocol UMFontScalersManager

- (void)registerFontScaler:(id<UMFontScaler>)scaler;

@end

// Only used for SDKs up to 39. Remove when SDK39 is dropped from Expo client.
@interface UMFontScalersManager : UMSingletonModule <UMFontScalersManager>

@end
