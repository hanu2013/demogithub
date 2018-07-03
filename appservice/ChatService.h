//
//  ChatService.h
//  XMPP
//
//  Created by Nguyen Kim Ngoc on 6/19/18.
//  Copyright © 2018 Nguyen Kim Ngoc. All rights reserved.
//

#ifndef ChatService_h
#define ChatService_h

#import <Foundation/Foundation.h>

@import XMPPFramework;

@interface ChatService : NSObject
@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;

@property (nonatomic, strong) XMPPPing *xmppPing;

@end
#endif /* ChatService_h */
