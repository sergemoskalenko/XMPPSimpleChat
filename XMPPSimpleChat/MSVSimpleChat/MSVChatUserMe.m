//
//  MSVChatUser.m
//  XMPPSimpleChat
//
//  Created by Serge Moskalenko on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import "MSVChatUserMe.h"

#define kMSVChatUseNamerKey @"kMSVChatUseNamerKey"
#define kMSVChatUserJIDKey @"kMSVChatUserJIDKey"
#define kMSVChatUserPasswordKey @"kMSVChatUserPasswordKey"

@implementation MSVChatUserMe

- (void)setName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kMSVChatUseNamerKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)name
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kMSVChatUseNamerKey];
}


- (void)setJid:(NSString *)jid
{
    [[NSUserDefaults standardUserDefaults] setObject:jid forKey:kMSVChatUserJIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)jid
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kMSVChatUserJIDKey];
}


- (void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kMSVChatUserPasswordKey];
}

- (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kMSVChatUserPasswordKey];
}



@end
