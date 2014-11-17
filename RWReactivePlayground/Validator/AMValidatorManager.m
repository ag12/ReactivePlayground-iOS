//
//  AMValidatorManager.m
//  RWReactivePlayground
//
//  Created by Amir Ghoreshi on 17/11/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "AMValidatorManager.h"

@implementation AMValidatorManager

+ (NSString *)trim:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}


+ (BOOL)isValidField:(NSString *)text {
    text = [self trim:text];
    return text.length > 3;
}

@end
