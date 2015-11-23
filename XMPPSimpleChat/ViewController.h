//
//  ViewController.h
//  XMPPSimpleChat
//
//  Created by Som Sam on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *enterButtonView;
@property (weak, nonatomic) IBOutlet UITextField *loginTextView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextView;

- (IBAction)enterButton:(id)sender;

@end

