//
//  ChatViewController.h
//  XMPPSimpleChat
//
//  Created by Som Sam on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *statementLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButtonView;
@property (weak, nonatomic) IBOutlet UITextField *jidTextView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)logoutButton:(id)sender;


@end
