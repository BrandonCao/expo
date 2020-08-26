// Copyright 2015-present 650 Industries. All rights reserved.

#import <EXFont/EXFontLoader.h>
#import <EXFont/EXFontLoaderProcessor.h>
#import <EXFont/EXReactFontManager.h>
#import <EXFont/EXFontScaler.h>
#import <EXFont/EXFont.h>
#import <objc/runtime.h>
#import <EXFont/EXFontRegistry.h>
#import <EXFont/EXFontScalersManager.h>
#import <React/RCTBridge.h>

@interface EXFontLoader ()

@property (nonatomic, strong) EXFontScaler *scaler;
@property (nonatomic, strong) EXFontLoaderProcessor *processor;
@property (nonatomic, strong) EXFontRegistry *registry;

@end

@implementation EXFontLoader

RCT_EXPORT_MODULE(ExpoFontLoader)

@synthesize bridge = _bridge;

+ (BOOL)requiresMainQueueSetup
{
  // We need to
  return YES;
}

- (instancetype)init
{
  if (self = [super init]) {
    _scaler = [[EXFontScaler alloc] init];
    _registry = [[EXFontRegistry alloc] init];
    _processor = [[EXFontLoaderProcessor alloc] initWithRegistry:_registry];
  }
  return self;
}

- (instancetype)initWithFontFamilyPrefix:(NSString *)prefix
{
  if (self = [super init]) {
    _scaler = [[EXFontScaler alloc] init];
    _registry = [[EXFontRegistry alloc] init];
    _processor = [[EXFontLoaderProcessor alloc] initWithFontFamilyPrefix:prefix registry:_registry];
  }
  return self;
}


- (void)setBridge:(RCTBridge *)bridge
{
  if (bridge) {
    EXReactFontManager *manager = [bridge moduleForName:@"FontManager"];
    [manager addFontProcessor:_processor];
    
    [[EXFontScalersManager sharedInstance] registerFontScaler:_scaler];
  }
}

RCT_REMAP_METHOD(loadAsync,
                 loadAsyncWithFontFamilyName:(NSString *)fontFamilyName
                 withLocalUri:(NSString *)path
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  if ([_registry fontForName:fontFamilyName]) {
    reject(@"E_FONT_ALREADY_EXISTS",
           [NSString stringWithFormat:@"Font with family name '%@' already loaded", fontFamilyName],
           nil);
    return;
  }
  
  // TODO(nikki): make sure path is in experience's scope
  NSURL *uriString = [[NSURL alloc] initWithString:path];
  NSData *data = [[NSFileManager defaultManager] contentsAtPath:[uriString path]];
  if (!data) {
    reject(@"E_FONT_FILE_NOT_FOUND",
           [NSString stringWithFormat:@"File '%@' for font '%@' doesn't exist", path, fontFamilyName],
           nil);
    return;
  }
  
  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
  CGFontRef font = CGFontCreateWithDataProvider(provider);
  CGDataProviderRelease(provider);
  if (!font) {
    reject(@"E_FONT_CREATION_FAILED",
           [NSString stringWithFormat:@"Could not create font from loaded data for '%@'", fontFamilyName],
           nil);
    return;
  }
  
  [_registry setFont:[[EXFont alloc] initWithCGFont:font] forName:fontFamilyName];
  resolve(nil);
}

@end
