//
//  MSVChatDataManager.m
//  XMPPSimpleChat
//
//  Created by Serge Moskalenko on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import "MSVChatDataManager.h"


@interface MSVChatDataManager()

@property (nonatomic, strong) MSVChatUserMe* me;
@property (nonatomic, strong) MSVChatUserRec* reciever;
@property (nonatomic, strong) XMPPHelper* xmppHelper;
@property (nonatomic, strong) NSMutableArray* messagesLocal;

@property (nonatomic, assign) int timerTicks;
@property (nonatomic, strong) NSTimer* timer;

- (void)newMessage:(NSString *)message to:(NSString *)jIdTo from:(NSString *)jIdFrom needToSendLater:(BOOL)needToSendLater;

@end

@implementation MSVChatDataManager

+ (MSVChatDataManager *)sharedInstance
{
    static MSVChatDataManager* staticStaredInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        staticStaredInstance = [[MSVChatDataManager alloc] init];
    });
    
    return staticStaredInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _isReachable = YES;
        
        _me = [MSVChatUserMe new];
        _reciever = [MSVChatUserRec new];
        _messagesLocal = [NSMutableArray new];
        _xmppHelper = [XMPPHelper new];
        _xmppHelper.delegate = self;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc
{
    self.xmppHelper.delegate = nil;
    [self.timer invalidate];
}

- (void)timerTicked:(NSTimer*)timer
{
    if (!self.isReachable)
        return;
    
    int i = 0;
    for(;i < self.messagesLocal.count; i++)
    {
        NSDictionary* dic = self.messagesLocal[i];
        if (dic[@"sendLater"] != nil)
        {
            [self.xmppHelper sendMessage:dic[@"message"] toID:dic[@"to"]];
            [self.messagesLocal removeObjectAtIndex:i];
            [self newMessage:dic[@"message"] to:dic[@"to"] from:dic[@"from"] needToSendLater:!self.isReachable];
            
            break; // one by 5 sec
        }
    }
}


#pragma mark - Messages

- (void)sendMessage:(NSString *)message
{
    [self.xmppHelper sendMessage:message toID:self.reciever.jid];
    [self newMessage:message to:self.reciever.jid from:self.me.jid needToSendLater:!self.isReachable];
}

- (NSArray *)messages
{
    return [NSArray arrayWithArray:self.messagesLocal];
}

- (void)newMessage:(NSString *)message to:(NSString *)jIdTo from:(NSString *)jIdFrom
{
    [self newMessage:message to:jIdTo from:jIdFrom needToSendLater:NO];
}

- (void)newMessage:(NSString *)message to:(NSString *)jIdTo from:(NSString *)jIdFrom needToSendLater:(BOOL)needToSendLater
{
    if (message == nil || jIdTo == nil || jIdFrom == nil)
        return;
    
    NSDictionary* messageRec = nil;
    if (needToSendLater)
        messageRec = @{@"message":message, @"to":jIdTo, @"from":jIdFrom, @"sendLater":@YES};
    else
        messageRec = @{@"message":message, @"to":jIdTo, @"from":jIdFrom};
    
    [self.messagesLocal addObject:messageRec];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMSVNewMessageKey object:nil];
}

- (void)saveMessages
{
    [self.messagesLocal writeToFile:[self pathToMessagesFile] atomically:NO];
}

- (void)loadMessages
{
    NSArray* savedMessages = [NSArray arrayWithContentsOfFile:[self pathToMessagesFile]];
    if (savedMessages)
        self.messagesLocal = [NSMutableArray arrayWithArray:savedMessages];
}

- (NSString *)pathToMessagesFile
{
    NSString* path = [self pathToCacheFileNamed:@"messages.plist"];
    return path;
}

- (NSString *)pathToCacheFileNamed:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fileName];
 }


#pragma mark - XMPPHelper

- (void)connect
{
    self.xmppHelper.userJID = self.me.jid;
    self.xmppHelper.userPassword = self.me.password;
    [self.xmppHelper connect];
}

- (void)disconnect
{
    [self.xmppHelper disconnect];
}

- (void)xmppHelper:(XMPPHelper *)xmppHelper didRecieveMessage:(NSString *)message to:(NSString *)to from:(NSString *)from
{
    [[MSVChatDataManager sharedInstance] newMessage:message to:to from:from];
}

@end
