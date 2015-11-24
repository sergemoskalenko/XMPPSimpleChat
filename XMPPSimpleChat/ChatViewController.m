//
//  ChatViewController.m
//  XMPPSimpleChat
//
//  Created by Som Sam on 22.11.15.
//  Copyright (c) 2015 Serge Moskalenko. All rights reserved.
//

#import "ChatViewController.h"
#import "MSVChatDataManager.h"
#import "HPGrowingTextView.h"
#import "SVProgressHUD.h"
#import "Reachability.h"

@interface ChatViewController ()
@property (nonatomic, strong) HPGrowingTextView* textView;
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, assign) BOOL isLoaded;
@end

@implementation ChatViewController

- (void)changedRichability:(NSNotification *)notif
{
    Reachability* rich = notif.object;
    if (rich.isReachable)
        [self connect];
    else
        [self disconnect];
    
}

- (void)connect
{
    _statementLabel.text = @"Connecting";
    [SVProgressHUD show];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        [[MSVChatDataManager sharedInstance] connect];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss] ;
            _statementLabel.text = @"Connected";
        });
    });
}

- (void)disconnect
{
    [[MSVChatDataManager sharedInstance] disconnect];
    _statementLabel.text = @"Disconnected";
}


#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _jidTextView.text = [MSVChatDataManager sharedInstance].reciever.jid;
    
    [_jidTextView setDelegate:(id<UITextFieldDelegate>)self];
    [_jidTextView setReturnKeyType:UIReturnKeyDone];
    [_jidTextView addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];

    
    [_statementLabel removeFromSuperview];
    _statementLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_statementLabel];

    [_logoutButtonView removeFromSuperview];
    _logoutButtonView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_logoutButtonView];
    
    [_jidTextView removeFromSuperview];
    _jidTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_jidTextView];
    
    [_tableView removeFromSuperview];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    
    
    NSNumber *padding = @15;
    NSDictionary *metrics = NSDictionaryOfVariableBindings(padding);
    void (^addConstraint)(UIView *, NSString *, NSDictionary *) = ^(UIView *superview, NSString *format, NSDictionary *views) {
        [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views]];
    };
    
    NSDictionary *rows = NSDictionaryOfVariableBindings(_statementLabel, _logoutButtonView, _jidTextView, _tableView);
    
    addConstraint(self.view, @"H:|-padding-[_statementLabel]-[_logoutButtonView(70)]-padding-|", rows);
    
    addConstraint(self.view, @"H:|-padding-[_jidTextView]-padding-|", rows);
    addConstraint(self.view, @"H:|-padding-[_tableView]-padding-|", rows);
    
    addConstraint(self.view, @"V:|-30-[_logoutButtonView(30)]", rows);
    addConstraint(self.view, @"V:|-30-[_statementLabel(30)]-padding-[_jidTextView(30)]-padding-[_tableView]-40-|", rows);
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newMessage)
                                                 name:kMSVNewMessageKey
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedRichability:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [self textViewInit];
    [self newMessage];
}

- (void)textViewInit
{
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    self.containerView.backgroundColor = self.jidTextView.backgroundColor;
    
    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.view.frame.size.width - 80, 40)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 3;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    self.textView.returnKeyType = UIReturnKeyGo; //just as an example
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.delegate = (NSObject<HPGrowingTextViewDelegate> *)self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor clearColor]; // [UIColor whiteColor];
    self.textView.placeholder = @"Add a comment";
    self.textView.returnKeyType = UIReturnKeyDefault;
    
    [self.view addSubview:self.containerView];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.containerView addSubview:self.textView];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [doneBtn setTitleColor:[UIColor colorWithRed:81 / 255.0 green:144 / 255.0 blue:3 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.containerView addSubview:doneBtn];
    [self.view bringSubviewToFront:doneBtn];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)sendMessage
{
    NSLog(@"send message");
    
    [self.textView resignFirstResponder];
    
    [MSVChatDataManager sharedInstance].reciever.jid = self.jidTextView.text;
    [[MSVChatDataManager sharedInstance] sendMessage:self.textView.text];
    
    self.textView.text = @"";

}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.containerView.frame = containerFrame;
  //  [self checkFrame];
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.containerView.frame = containerFrame;
  //  [self checkFrame];
    
    // commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.containerView.frame = r;
    
 //   [self checkFrame];
}




- (void)newMessage
{
    [_tableView reloadData];
    
    if ([MSVChatDataManager sharedInstance].messages.count > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[MSVChatDataManager sharedInstance].messages.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)logoutButton:(id)sender
{
    [[MSVChatDataManager sharedInstance] saveMessages];
    [[MSVChatDataManager sharedInstance] disconnect];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldFinished:(id)sender
{
    
    [MSVChatDataManager sharedInstance].reciever.jid = _jidTextView.text;
    [sender resignFirstResponder];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return 100; // [tableData count];
    return  [[MSVChatDataManager sharedInstance].messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:simpleTableIdentifier]; // UITableViewCellStyleDefault
    }
    
    NSDictionary* dic = [[MSVChatDataManager sharedInstance].messages objectAtIndex:indexPath.row];
    
    
    cell.detailTextLabel.text = dic[@"from"]; //  [NSString stringWithFormat:@"Info: %ld", (long)indexPath.row];
    cell.textLabel.text = dic[@"message"]; // [NSString stringWithFormat:@"String number %ld", (long)indexPath.row]; // [tableDataobjectAtIndex:indexPath.row];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
// 
//    return 50.;
//}

@end
