//
//  AMCocoaManager.m
//  RWReactivePlayground
//
//  Created by Amir Ghoreshi on 17/11/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "AMCocoaManager.h"
#import "AMValidatorManager.h"
#import "RWDummySignInService.h"

@implementation AMCocoaManager

-(id)init {
    NSLog(@"init");
    return self;
}
+ (void)observeTextField:(UITextField *)field {

    [field.rac_textSignal subscribeNext:^(NSString *newValue) {
        NSLog(@"%@", newValue);
    } error:^(NSError *error) {
        NSLog(@"error");
    } completed:^{
        NSLog(@"completed");
    }];
}

+ (void)observeTextFieldWithFilter:(UITextField *)field {

    [[field.rac_textSignal filter:^BOOL(NSString *newValue) {
        newValue = [AMValidatorManager trim:newValue];
        return newValue.length > 3;
    }]
    subscribeNext:^(NSString *newValue) {
        newValue = [AMValidatorManager trim:newValue];
        NSLog(@"%@", newValue);
    } error:^(NSError *error) {
        NSLog(@"error");
    } completed:^{
        NSLog(@"completed");
    }];
}


//Just for showing the discrete pipeline steps:
+ (void)observeTextFieldWithFilterSeparate:(UITextField *)field {

    RACSignal *fieldSignal = field.rac_textSignal;

    RACSignal *filterSignal = [fieldSignal filter:^BOOL(NSString * text) {
        text = [AMValidatorManager trim:text];
        return text.length > 3;
    }];

    [filterSignal subscribeNext:^(id text) {
        text = [AMValidatorManager trim:text];
        NSLog(@"%@", text);
    }];
}


+ (void)observeTextFieldWithMap:(UITextField *)field {

    [[[field.rac_textSignal
     map:^id(NSString *text) {
         text = [AMValidatorManager trim:text];
         return @(text.length);
     }] filter:^BOOL(NSNumber *length) {
         return [length integerValue] > 3;
     }] subscribeNext:^(NSNumber *number) {
         NSLog(@"%@", number);
     }];
}

+ (void)observeTextFieldWithValidation:(UITextField *)field {
     RACSignal *validFieldSignal = [field.rac_textSignal
                                   map:^id(NSString *text) {
                                       return @([AMValidatorManager isValidField:text]);
                                   }];

    [[validFieldSignal map:^id(NSNumber *number) {
        return [number boolValue] ? [UIColor clearColor] : [UIColor orangeColor];
    }] subscribeNext:^(UIColor *color) {
        field.backgroundColor = color;
    }];

}


+ (void)observeTextFieldWithMarco:(UITextField *)field {

    RACSignal *validFieldSignal = [field.rac_textSignal
                                   map:^id(NSString *text) {
                                       return @([AMValidatorManager isValidField:text]);
                                   }];

    RAC(field, textColor) = [validFieldSignal map:^id(NSNumber *number) {
        return [number boolValue] ? [UIColor blackColor] : [UIColor redColor];
    }];
}


+ (RACSignal *)observeTextFieldWithSignal:(UITextField *)field {

    RACSignal *validFieldSignal = [field.rac_textSignal
                                   map:^id(NSString *text) {
                                       return @([AMValidatorManager isValidField:text]);
                                   }];

    RAC(field, textColor) = [validFieldSignal map:^id(NSNumber *number) {
        return [number boolValue] ? [UIColor blackColor] : [UIColor redColor];
    }];
    return validFieldSignal;
}



+ (void)observeSignalsForButton:(UIButton *)goButton firstSignal:(RACSignal *)firstSignal lastSignal:(RACSignal *)lastSignal  {

    RACSignal *finalSignal = [RACSignal combineLatest:@[firstSignal,lastSignal] reduce:^id(NSNumber *validSignal, NSNumber *validSignalTwo){
        return @([validSignal boolValue] && [validSignalTwo boolValue]);
    }];
    [finalSignal subscribeNext:^(NSNumber *goSignal) {
        goButton.enabled = [goSignal boolValue];
    }];
}

+ (void)observeEventTouchUpInsideOnElemnt:(UIButton *)button uname:(UITextField *)uname password:(UITextField *)password message:(UILabel *)message compelete:(void(^)(BOOL))compelete {
    [[[[button rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x) {
           button.enabled = NO;
           message.hidden = YES;
       }]
      flattenMap:^RACStream *(id value) {
        return [self finalSignal:uname fieldTwo:password];
    }] subscribeNext:^(id x) {
        button.enabled = YES;
        message.hidden = [x boolValue];
        compelete([x boolValue]);
    }];
}

+ (RACSignal *)finalSignal:(UITextField *)fieldOne fieldTwo:(UITextField *)fieldTwo {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RWDummySignInService new] signInWithUsername:fieldOne.text password:fieldTwo.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}



























@end
