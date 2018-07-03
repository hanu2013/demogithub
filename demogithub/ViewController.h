//
//  ViewController.h
//  XMPP
//
//  Created by Nguyen Kim Ngoc on 5/31/18.
//  Copyright © 2018 Nguyen Kim Ngoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatService.h"


@import XMPPFramework;
@import CocoaLumberjack;

//@import Reachability;

@interface ViewController : UIViewController

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;

@property (nonatomic, strong) XMPPPing *xmppPing;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@end

