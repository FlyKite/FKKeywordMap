//
//  FKKeywordMatcher.m
//  OCConsoleTest
//
//  Created by 风筝 on 2017/8/14.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

#import "FKKeywordMatcher.h"

@implementation KeywordMap
+ (KeywordMap *)loadFrom:(NSString *)path {
    BOOL isDirectory = false;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (isDirectory) {
        NSLog(@"The path must be a file path, not a directory path.");
        return nil;
    } else if (isExist) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    } else {
        NSLog(@"The file is not exists.");
        return nil;
    }
}

- (BOOL)saveTo:(NSString *)path {
    BOOL isDirectory = false;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (isDirectory) {
        NSLog(@"The path must be a file path, not a directory path.");
        return NO;
    } else {
        return [NSKeyedArchiver archiveRootObject:self toFile:path];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.subMaps = [aDecoder decodeObjectForKey:@"subMaps"];
        self.value = (UInt8)[aDecoder decodeIntForKey:@"value"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.subMaps forKey:@"subMaps"];
    [aCoder encodeInt:self.value forKey:@"value"];
}
@end

@implementation FKKeywordMatcher

- (BOOL)match:(NSString *)text withKeywordMap:(KeywordMap *)keywordMap {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    const UInt8 *bytes = data.bytes;
    for (NSInteger i = 0; i < data.length; i++) {
        UInt8 byte = bytes[i];
        KeywordMap *currentMap = keywordMap.subMaps[byte];
        if ([currentMap isKindOfClass:[KeywordMap class]]) {
            for (NSInteger j = i + 1; j < data.length; j++) {
                UInt8 byte = bytes[j];
                currentMap = currentMap.subMaps[byte];
                if ([currentMap isKindOfClass:[NSString class]]) {
                    break;
                }
                if (![currentMap.subMaps[0] isKindOfClass:[NSString class]]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (KeywordMap *)convert:(NSArray *)keywordArray {
    KeywordMap *keywordMap = [self createEmptyMap];
    for (NSString *keyword in keywordArray) {
        NSData *data = [keyword dataUsingEncoding:NSUTF8StringEncoding];
        const UInt8 *bytes = data.bytes;
        KeywordMap *currentMap = keywordMap;
        for (NSInteger i = 0; i < data.length; i++) {
            UInt8 byte = bytes[i];
            KeywordMap *map = currentMap.subMaps[byte];
            if (![map isKindOfClass:[KeywordMap class]]) {
                map = [self createEmptyMap];
                map.value = byte;
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

- (NSArray *)backToArray:(KeywordMap *)keywodMap {
    NSMutableArray *keywordArray = [[NSMutableArray alloc] init];
    NSMutableArray *mapStack = [[NSMutableArray alloc] initWithObjects:keywodMap, nil];
    NSMutableArray *bytesArray = [[NSMutableArray alloc] init];
    while (mapStack.count > 0) {
        KeywordMap *map = mapStack.lastObject;
        [mapStack removeLastObject];
        if ([map isKindOfClass:[NSString class]]) {
            [bytesArray removeLastObject];
            continue;
        }
        if (map.value != 0) {
            [bytesArray addObject:[NSNumber numberWithUnsignedChar:map.value]];
        }
        [mapStack addObject:@""];
        if ([map.subMaps[0] isKindOfClass:[KeywordMap class]]) {
            NSString *text = [self convertBytes:bytesArray];
            if (text) {
                [keywordArray addObject:text];
            }
        }
        for (NSInteger i = 1; i < 256; i++) {
            KeywordMap *m = map.subMaps[i];
            if ([m isKindOfClass:[KeywordMap class]]) {
                [mapStack addObject:m];
            }
        }
    }
    return [keywordArray copy];
}

- (NSString *)convertBytes:(NSArray *)bytes {
    NSMutableData *data = [[NSMutableData alloc] init];
    for (NSNumber *num in bytes) {
        const char byte = [num unsignedCharValue];
        [data appendBytes:&byte length:1];
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
