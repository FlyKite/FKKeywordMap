//
//  FKKeywordMatcher.h
//  OCConsoleTest
//
//  Created by 风筝 on 2017/8/14.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef struct map {
//    uint8 value;
//    struct map *nextMaps[256];
//} KeywordMap;

@interface KeywordMap : NSObject
@property (assign, nonatomic) uint8 value;
@property (strong, nonatomic) NSMutableArray *subMaps;
@end

@interface FKKeywordMatcher : NSObject
- (BOOL)match:(NSString *)text withKeywordDict:(NSDictionary *)keywordDict;
- (BOOL)match:(NSString *)text withKeywordMap:(KeywordMap *)keywordMap;
- (NSDictionary *)convert:(NSArray *)keywordArray;
- (KeywordMap *)convertToMap:(NSArray *)keywordArray;
- (NSArray *)backToArray:(NSDictionary *)keywordDict;
@end
