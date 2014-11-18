//
//  AMCocoaManager.h
//  RWReactivePlayground
//
//  Created by Amir Ghoreshi on 17/11/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>

@interface AMCocoaManager : NSObject

+ (void)observeTextField:(UITextField *)field;
+ (void)observeTextFieldWithFilter:(UITextField *)field;
+ (void)observeTextFieldWithFilterSeparate:(UITextField *)field;
+ (void)observeTextFieldWithMap:(UITextField *)field;
+ (void)observeTextFieldWithValidation:(UITextField *)field;
+ (void)observeTextFieldWithMarco:(UITextField *)field;
+ (RACSignal *)observeTextFieldWithSignal:(UITextField *)field;
+ (void)observeSignalsForButton:(UIButton *)goButton firstSignal:(RACSignal *)firstSignal lastSignal:(RACSignal *)lastSignal;
+ (void)observeEventTouchUpInsideOnElemnt:(UIButton *)button uname:(UITextField *)uname password:(UITextField *)password message:(UILabel *)message compelete:(void(^)(BOOL))compelete;

@end
