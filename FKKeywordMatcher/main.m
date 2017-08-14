//
//  main.m
//  OCConsoleTest
//
//  Created by 风筝 on 2017/8/14.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKKeywordMatcher.h"

typedef struct ab {
    char value;
    struct ab *nextABs[256];
} AB;

void test() {
    NSString *path = @"/Users/FlyKite/Desktop/OCConsoleTest/word.plist";
    NSArray *array = [NSDictionary dictionaryWithContentsOfFile:path].allKeys;
    FKKeywordMatcher *matcher = [[FKKeywordMatcher alloc] init];
    KeywordMap *map = [matcher convertToMap:array];
    NSLog(@"abc");
//    free(map);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        test();
        NSLog(@"fff");
        
//        AB *ab = (AB *)malloc(sizeof(AB));
//        ab->value = 48;
//        ab->nextABs[119] = malloc(sizeof(AB));
//        (ab->nextABs[119])->value = 55;
////        (&(ab->nextABs[128]))->value = 52;
////        (&(ab->nextABs[130]))->value = 55;
//        NSLog(@"%u", ab->nextABs[119]->value);
//        if (ab->nextABs[120] != NULL) {
//            NSLog(@"fds");
//        } else {
//            NSLog(@"asd");
//        }
        
        NSString *path = @"/Users/FlyKite/Desktop/OCConsoleTest/word.plist";
        NSArray *array = [NSDictionary dictionaryWithContentsOfFile:path].allKeys;
        FKKeywordMatcher *matcher = [[FKKeywordMatcher alloc] init];
        KeywordMap *map = [matcher convertToMap:array];
//        NSDictionary *dict = [matcher convert:array];
//        path = @"/Users/FlyKite/Desktop/OCConsoleTest/word1.plist";
//        [dict writeToFile:path atomically:true];
        
//        FKKeywordMatcher *matcher = [[FKKeywordMatcher alloc] init];
        NSString *text = @"前边是一大堆无用的字习大前边是一大堆无用的字习大前边是一大堆无用的字习大前边是一大堆无用的字习大前边是一大堆无用的字习大我爱习大大";
        NSTimeInterval time = [[[NSDate alloc] init] timeIntervalSince1970];
        for (NSString *keyword in array) {
            if ([text containsString:keyword]) {
                NSLog(@"匹配到关键词了");
            }
        }
        NSLog(@"%lf", [[[NSDate alloc] init] timeIntervalSince1970] - time);
        
        
        path = @"/Users/FlyKite/Desktop/OCConsoleTest/word1.plist";
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        time = [[[NSDate alloc] init] timeIntervalSince1970];
        if ([matcher match:text withKeywordMap:map]) {
            NSLog(@"匹配到关键词啦");
        }
        NSLog(@"%lf", [[[NSDate alloc] init] timeIntervalSince1970] - time);
    }
    return 0;
}
