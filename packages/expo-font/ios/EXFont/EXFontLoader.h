// Copyright 2015-present 650 Industries. All rights reserved.

#import <React/RCTBridgeModule.h>

@interface EXFontLoader : NSObject <RCTBridgeModule>

- (instancetype)initWithFontFamilyPrefix:(NSString *)prefix;

@end
