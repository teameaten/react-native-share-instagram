//
//  RNReactNativeSharingWinstagram.h
//  RNReactNativeSharingWinstagram
//
//  Created by Rafael Nascimento on 16/05/17.
//  Copyright © 2017 nascimentorafael. All rights reserved.
//

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@import UIKit;

@interface RNReactNativeSharingWinstagram : NSObject <RCTBridgeModule>

@property (retain) UIDocumentInteractionController * documentInteractionController;

@end
