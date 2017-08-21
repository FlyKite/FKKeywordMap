//
//  main.m
//  FKKeywordMatcher
//
//  Created by 风筝 on 2017/8/14.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKKeywordMap.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        NSString *path = @"/Users/FlyKite/Desktop/word.plist";
        NSArray *array = [NSDictionary dictionaryWithContentsOfFile:path].allKeys;
        FKKeywordMap *map = [FKKeywordMap convert:array];
        
        NSString *text = @"前边是一大堆无用的字习大前边是一大堆无用的字习大前边是一大堆无用的字习大前边是一大堆无用的字习大前边是一大堆无用的字习大我爱习大大";
        NSTimeInterval time = [[[NSDate alloc] init] timeIntervalSince1970];
        for (NSString *keyword in array) {
            if ([text containsString:keyword]) {
                NSLog(@"匹配到关键词了");
            }
        }
        NSLog(@"%lf", [[[NSDate alloc] init] timeIntervalSince1970] - time);
        
        time = [[[NSDate alloc] init] timeIntervalSince1970];
        if ([map match:text]) {
            NSLog(@"匹配到关键词啦");
        }
        NSLog(@"%lf", [[[NSDate alloc] init] timeIntervalSince1970] - time);
    }
    return 0;
}
