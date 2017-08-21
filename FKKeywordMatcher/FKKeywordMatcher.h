//
//  FKKeywordMatcher.h
//  FKKeywordMatcher
//
//  Created by 风筝 on 2017/8/14.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeywordMap : NSObject<NSCoding>
@property (assign, nonatomic) UInt8 value;
@property (strong, nonatomic) NSMutableArray *subMaps;

/**
 * Convert keyword array to KeywordMap
 * @param keywordArray An array contains all keywords
 * @return KeywordMap object
 */
+ (KeywordMap *)convert:(NSArray *)keywordArray;

/**
 * Load KeywordMap from a local file
 * @param path Path of the file
 * @return KeywordMap object
 */
+ (KeywordMap *)loadFrom:(NSString *)path;

/**
 * Save KeywordMap to a local file
 * @param path Path of the file
 * @return Result of saving to file
 */
- (BOOL)saveTo:(NSString *)path;
@end

@interface FKKeywordMatcher : NSObject
- (BOOL)match:(NSString *)text withKeywordMap:(KeywordMap *)keywordMap;
- (NSArray *)backToArray:(KeywordMap *)keywordMap;
@end
