//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import "AMCocoaManager.h"


@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;


@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
  [super viewDidLoad];

    self.signInButton.enabled = NO;
  // initially hide the failure message
  self.signInFailureText.hidden = YES;

    [AMCocoaManager observeSignalsForButton:self.signInButton firstSignal:[AMCocoaManager observeTextFieldWithSignal:self.usernameTextField] lastSignal:[AMCocoaManager observeTextFieldWithSignal:self.passwordTextField]];
    [AMCocoaManager observeEventTouchUpInsideOnElemnt:self.signInButton uname:self.usernameTextField password:self.passwordTextField message:self.signInFailureText
     compelete:^(BOOL success) {
         [self success:success];
     }];

}

- (void)success:(BOOL)success {
    if (success) {
        [self performSegueWithIdentifier:@"signInSuccess" sender:self];
    }
}
@end
