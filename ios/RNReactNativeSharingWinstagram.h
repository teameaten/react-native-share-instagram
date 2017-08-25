//
//  RNReactNativeSharingWinstagram.h
//  RNReactNativeSharingWinstagram
//
//  Created by Rafael Nascimento on 16/05/17.
//  Copyright © 2017 nascimentorafael. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@import UIKit;

@interface RNReactNativeSharingWinstagram : NSObject <RCTBridgeModule>

@property (retain) UIDocumentInteractionController * documentInteractionController;

@end
