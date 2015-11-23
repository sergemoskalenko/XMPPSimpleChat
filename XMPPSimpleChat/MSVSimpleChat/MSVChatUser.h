//
//  MSVChatUser.h
//  XMPPSimpleChat
//
//  Created by Serge Moskalenko on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSVChatUser : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* jid;
@property (nonatomic, strong) NSString* password;

@end
