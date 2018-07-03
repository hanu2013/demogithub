//
//  AppDelegate.h
//  XMPP
//
//  Created by Nguyen Kim Ngoc on 5/31/18.
//  Copyright © 2018 Nguyen Kim Ngoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CocoaLumberjack;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DDFileLogger *ddFileLogger;

@end

