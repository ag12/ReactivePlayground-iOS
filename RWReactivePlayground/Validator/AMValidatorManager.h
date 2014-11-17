//
//  AMValidatorManager.h
//  RWReactivePlayground
//
//  Created by Amir Ghoreshi on 17/11/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMValidatorManager : NSObject

+ (NSString *)trim:(NSString *)string;
+ (BOOL)isValidField:(NSString *)text;
@end
