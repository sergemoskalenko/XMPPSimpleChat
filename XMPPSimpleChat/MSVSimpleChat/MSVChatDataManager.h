//
//  MSVChatDataManager.h
//  XMPPSimpleChat
//
//  Created by Serge Moskalenko on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MSVChatUser.h"
#import "MSVChatUserMe.h"
#import "MSVChatUserRec.h"
#import "XMPPHelper.h"

#define kMSVNewMessageKey @"kMSVNewMessageKey"

@class XMPPHelper;
@interface MSVChatDataManager : NSObject

@property (nonatomic, strong, readonly) MSVChatUserMe* me;
@property (nonatomic, strong, readonly) MSVChatUserRec* reciever;
@property (nonatomic, strong, readonly) XMPPHelper* xmppHelper;
@property (nonatomic, assign) BOOL isReachable;

+ (MSVChatDataManager *)sharedInstance;
- (void)sendMessage:(NSString *)message;

- (void)newMessage:(NSString *)message to:(NSString *)jIdTo from:(NSString *)jIdFrom;

- (void)saveMessages;
- (void)loadMessages;

- (NSArray *)messages;

- (void)setupReachability;

- (NSString *)pathToCacheFileNamed:(NSString *)fileName;

@end
