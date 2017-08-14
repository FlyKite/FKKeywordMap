//
//  FKKeywordMatcher.m
//  OCConsoleTest
//
//  Created by 风筝 on 2017/8/14.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

#import "FKKeywordMatcher.h"

@implementation KeywordMap

@end

@implementation FKKeywordMatcher

- (BOOL)match:(NSString *)text withKeywordDict:(NSDictionary *)keywordDict {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    const uint8 *bytes = data.bytes;
    for (NSInteger i = 0; i < data.length; i++) {
        uint8 byte = bytes[i];
        NSString *key = [NSString stringWithFormat:@"%u", byte];
        NSDictionary *currentDict = keywordDict[key];
        if (currentDict) {
            for (NSInteger j = i + 1; j < data.length; j++) {
                uint8 byte = bytes[j];
                NSString *key = [NSString stringWithFormat:@"%u", byte];
                currentDict = currentDict[key];
                if (!currentDict) {
                    break;
                }
                if (currentDict[@"end"]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

//- (BOOL)match:(NSString *)text withKeywordMap:(KeywordMap *)keywordMap {
//    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
//    const uint8 *bytes = data.bytes;
//    for (NSInteger i = 0; i < data.length; i++) {
//        uint8 byte = bytes[i];
//        KeywordMap *currentMap = keywordMap->nextMaps[byte];
//        if (currentMap != NULL) {
//            for (NSInteger j = i + 1; j < data.length; j++) {
//                uint8 byte = bytes[j];
//                currentMap = currentMap->nextMaps[byte];
//                if (currentMap == NULL) {
//                    break;
//                }
//                if (currentMap->nextMaps[0] != NULL) {
//                    return YES;
//                }
//            }
//        }
//    }
//    return NO;
//}

- (BOOL)match:(NSString *)text withKeywordMap:(KeywordMap *)keywordMap {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    const uint8 *bytes = data.bytes;
    for (NSInteger i = 0; i < data.length; i++) {
        uint8 byte = bytes[i];
        KeywordMap *currentMap = keywordMap.subMaps[byte];
        if ([currentMap isKindOfClass:[KeywordMap class]]) {
            for (NSInteger j = i + 1; j < data.length; j++) {
                uint8 byte = bytes[j];
                currentMap = currentMap.subMaps[byte];
                if (currentMap == @"") {
                    break;
                }
                if (currentMap.subMaps[0] != @"") {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (NSDictionary *)convert:(NSArray *)keywordArray {
    NSMutableDictionary *keywordDict = [[NSMutableDictionary alloc] init];
    for (NSString *keyword in keywordArray) {
        NSData *data = [keyword dataUsingEncoding:NSUTF8StringEncoding];
        const uint8 *bytes = data.bytes;
        NSMutableDictionary *currentDict = keywordDict;
        for (NSInteger i = 0; i < data.length; i++) {
            uint8 byte = bytes[i];
            NSString *key = [NSString stringWithFormat:@"%u", byte];
            NSMutableDictionary *dict = currentDict[key];
            if (!dict) {
                dict = [[NSMutableDictionary alloc] init];
                currentDict[key] = dict;
            }
            if (i == data.length - 1) {
                dict[@"end"] = @"";
            }
            currentDict = dict;
        }
    }
    return [keywordDict copy];
}

- (KeywordMap *)convertToMap:(NSArray *)keywordArray {
    KeywordMap *keywordMap = [self createEmptyMap];
    for (NSString *keyword in keywordArray) {
        NSData *data = [keyword dataUsingEncoding:NSUTF8StringEncoding];
        const uint8 *bytes = data.bytes;
        KeywordMap *currentMap = keywordMap;
        for (NSInteger i = 0; i < data.length; i++) {
            uint8 byte = bytes[i];
            KeywordMap *map = currentMap.subMaps[byte];
            if (![map isKindOfClass:[KeywordMap class]]) {
                map = [self createEmptyMap];
                currentMap.subMaps[byte] = map;
            }
            if (i == data.length - 1) {
                map.subMaps[0] = [self createEmptyMap];
            }
            currentMap = map;
        }
    }
    return keywordMap;
}

- (KeywordMap *)createEmptyMap {
    KeywordMap *keywordMap = [[KeywordMap alloc] init];
    keywordMap.subMaps = [[NSMutableArray alloc] initWithCapacity:256];
    for (NSInteger i = 0; i < 256; i++) {
        [keywordMap.subMaps addObject:@""];
    }
    return keywordMap;
}

//- (KeywordMap *)convertToMap:(NSArray *)keywordArray {
//    KeywordMap *keywordMap = [self createEmptyMap];
//    for (NSString *keyword in keywordArray) {
//        NSData *data = [keyword dataUsingEncoding:NSUTF8StringEncoding];
//        const uint8 *bytes = data.bytes;
//        KeywordMap *currentMap = keywordMap;
//        for (NSInteger i = 0; i < data.length; i++) {
//            uint8 byte = bytes[i];
//            KeywordMap *map = currentMap->nextMaps[byte];
//            if (map == NULL) {
//                map = [self createEmptyMap];
//                map->value = byte;
//                currentMap->nextMaps[byte] = map;
//            }
//            if (i == data.length - 1) {
//                map->nextMaps[0] = [self createEmptyMap];
//            }
//            currentMap = map;
//        }
//    }
//    return keywordMap;
//}

//- (KeywordMap *)createEmptyMap {
//    KeywordMap *keywordMap = (KeywordMap *)malloc(sizeof(KeywordMap));
//    for (int i = 0; i < 256; i++) {
//        keywordMap->nextMaps[i] = NULL;
//    }
//    return keywordMap;
//}

- (NSArray *)backToArray:(NSDictionary *)keywordDict {
    NSMutableArray *keywordArray = [[NSMutableArray alloc] init];
    NSMutableArray *dictStack = [[NSMutableArray alloc] initWithObjects:keywordDict, nil];
    NSMutableArray *bytesArray = [[NSMutableArray alloc] init];
    while (dictStack.count > 0) {
        NSDictionary *dict = dictStack.lastObject;
        [dictStack removeLastObject];
        NSArray *keys = dict.allKeys;
        for (NSInteger i = keys.count - 1; i >= 0; i++) {
            NSString *key = keys[i];
            [dictStack addObject:dict[key]];
        }
        
    }
    return [keywordArray copy];
}

@end
