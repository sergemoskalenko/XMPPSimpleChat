//
//  ViewController.m
//  XMPPSimpleChat
//
//  Created by Som Sam on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import "ViewController.h"
#import "MSVChatDataManager.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (nonatomic, strong) Reachability* reach;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_loginTextView removeFromSuperview];
    _loginTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_loginTextView];
    
    [_passwordTextView removeFromSuperview];
    _passwordTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_passwordTextView];
    
    [_enterButtonView removeFromSuperview];
    _enterButtonView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_enterButtonView];
    
    [_textView removeFromSuperview];
    _textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_textView];
    
    
    NSNumber *padding = @15;
    NSDictionary *metrics = NSDictionaryOfVariableBindings(padding);
    void (^addConstraint)(UIView *, NSString *, NSDictionary *) = ^(UIView *superview, NSString *format, NSDictionary *views) {
        [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views]];
    };
    
    NSDictionary *rows = NSDictionaryOfVariableBindings(_loginTextView, _passwordTextView, _enterButtonView, _textView);
    
    addConstraint(self.view, @"H:|-padding-[_loginTextView]-padding-|", rows);
    addConstraint(self.view, @"H:|-padding-[_passwordTextView]-padding-|", rows);
    addConstraint(self.view, @"H:|-padding-[_enterButtonView]-padding-|", rows);
    addConstraint(self.view, @"H:|-padding-[_textView]-padding-|", rows);
    
    addConstraint(self.view, @"V:|-50-[_loginTextView(30)]-padding-[_passwordTextView(30)]-padding-[_enterButtonView(30)]-padding-[_textView]-padding-|", rows);

    // - init login / pass
        
    _loginTextView.text = [MSVChatDataManager sharedInstance].me.jid;
    _passwordTextView.text = [MSVChatDataManager sharedInstance].me.password;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(xmppConnected:)
                                                 name:kMSVConnectedKey
                                               object:nil];

    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // NSLog(@"REACHABLE!");
            [MSVChatDataManager sharedInstance].isReachable = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        // NSLog(@"UNREACHABLE!");
        [MSVChatDataManager sharedInstance].isReachable = NO;

    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)xmppConnected:(NSNotification *)notif
{
    NSDictionary* userInfo = [notif userInfo];
    if (userInfo)
    {
        [(AppDelegate* )([UIApplication sharedApplication].delegate) alert:[userInfo objectForKey:@"info"]];
    }
    else
    {
        [self performSegueWithIdentifier:@"next" sender:_enterButtonView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterButton:(id)sender
{
    [MSVChatDataManager sharedInstance].me.jid = _loginTextView.text;
    [MSVChatDataManager sharedInstance].me.password = _passwordTextView.text;

    if (![MSVChatDataManager sharedInstance].isReachable)
    {
        [(AppDelegate* )([UIApplication sharedApplication].delegate) alert:@"NO INTERNET"];
    }
    else
    {
        [SVProgressHUD show];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // time-consuming task
            [[MSVChatDataManager sharedInstance].xmppHelper connect];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss] ;
            });
        });
    }
    NSLog(@"enterButton");
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
    
    
    [SVProgressHUD show];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        [[MSVChatDataManager sharedInstance].xmppHelper connect];
        dispatch_async(dispatch_get_main_queue(), ^{

            [SVProgressHUD dismiss] ;
        });
    });
    
    NSLog(@"%@", identifier); return YES;
    if ([identifier isEqualToString:@"Identifier Of Segue Under Scrutiny"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = YES|NO; // you determine this
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Alert"
                                         message:@"Segue not permitted (better message here)"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
}

@end
