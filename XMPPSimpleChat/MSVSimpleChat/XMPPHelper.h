//
//  XMPPHelper.h
//  XMPPChat
//
//  Created by Serge Moskalenko on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPPReconnect.h"

#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"

#import "XMPPvCardTempModule.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"

#import "XMPPMUC.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPRoomHybridStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPRoomMessageHybridCoreDataStorageObject.h"
#import "XMPPMessageDeliveryReceipts.h"

#define kMSVMessageSentKey @"kMSVMessageSentKey"
#define kMSVMessageRecieveKey @"kMSVMessageRecieveKey"
#define kMSVConnectedKey @"kMSVConnectedKey"

@class XMPPHelper;
@protocol XMPPHelperDelegate <NSObject>
@optional
- (void)xmppHelper:(XMPPHelper *)xmppHelper didRecieveMessage:(NSString *)message to:(NSString *)to from:(NSString *)from;
@end

@interface XMPPHelper : NSObject <XMPPRoomDelegate>
{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPMUC *xmppMUC;
    XMPPRoom *xmppRoom;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPRoomCoreDataStorage *xmppRoomStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    
    XMPPMessageDeliveryReceipts* xmppMessageDeliveryRecipts;
    
    BOOL customCertEvaluation;
    BOOL isXmppConnected;
}

@property (nonatomic, strong) NSString *userJID;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, weak) id<XMPPHelperDelegate> delegate;


+ (id)sharedInstance;

- (BOOL)connect;
- (void)disconnect;

- (void)sendMessage:(NSString *)message toID:(NSString *)jid;

@end
