//
//  MSVChatUserSaved.m
//  XMPPSimpleChat
//
//  Created by Som Sam on 24.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import "MSVChatUserSaved.h"

@implementation MSVChatUserSaved

- (void)setName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:[self msvChatUseNamerKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)name
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:[self msvChatUseNamerKey]];
}

- (void)setJid:(NSString *)jid
{
    [[NSUserDefaults standardUserDefaults] setObject:jid forKey:[self msvChatUserJIDKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)jid
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:[self msvChatUserJIDKey]];
}

- (void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:[self msvChatUserPasswordKey]];
}

- (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:[self msvChatUserPasswordKey]];
}

- (NSString *)className
{
    return NSStringFromClass([self class]);
    
}

- (NSString *)msvChatUseNamerKey
{
    return [NSString stringWithFormat:@"k%@NameKey", [self className]];
}

- (NSString *)msvChatUserJIDKey
{
    return [NSString stringWithFormat:@"k%@JIDKey", [self className]];
}

- (NSString *)msvChatUserPasswordKey
{
    return [NSString stringWithFormat:@"k%@PasswordKey", [self className]];
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"\nKeys: %@, %@, %@", [self msvChatUseNamerKey], [self msvChatUserJIDKey], [self msvChatUserPasswordKey]];
}

@end
