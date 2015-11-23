//
//  MSVChatUser.m
//  XMPPSimpleChat
//
//  Created by Serge Moskalenko on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import "MSVChatUserRec.h"

#define kMSVChatUseRecNamerKey @"kMSVChatUseRecNamerKey"
#define kMSVChatUserRecJIDKey @"kMSVChatUserRecJIDKey"
#define kMSVChatUserRecPasswordKey @"kMSVChatUserRecPasswordKey"

@implementation MSVChatUserRec

- (void)setName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kMSVChatUseRecNamerKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)name
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kMSVChatUseRecNamerKey];
}


- (void)setJid:(NSString *)jid
{
    [[NSUserDefaults standardUserDefaults] setObject:jid forKey:kMSVChatUserRecJIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)jid
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kMSVChatUserRecJIDKey];
}


- (void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kMSVChatUserRecPasswordKey];
}

- (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kMSVChatUserRecPasswordKey];
}



@end
