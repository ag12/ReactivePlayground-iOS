//
//  AMCocoaManager.m
//  RWReactivePlayground
//
//  Created by Amir Ghoreshi on 17/11/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "AMCocoaManager.h"
#import "AMValidatorManager.h"

@implementation AMCocoaManager

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

















@end
