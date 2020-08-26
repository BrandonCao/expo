// Copyright 2018-present 650 Industries. All rights reserved.

#import <React/RCTBridgeModule.h>
#import <EXFont/EXFontProcessorInterface.h>

@interface EXReactFontManager : NSObject <RCTBridgeModule>

- (void)addFontProcessor:(id<EXFontProcessorInterface>)processor;

@end
