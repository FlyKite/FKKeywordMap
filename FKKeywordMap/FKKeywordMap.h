//
//  FKKeywordMap.h
//  FKKeywordMap
//
//  Created by 风筝 on 2017/8/14.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKKeywordMap : NSObject<NSCoding>
@property (assign, nonatomic) UInt8 value;
@property (strong, nonatomic) NSMutableArray *subMaps;

/**
 * Convert keyword array to FKKeywordMap
 * @param keywordArray An array contains all keywords
 * @return FKKeywordMap object
 */
+ (FKKeywordMap *)convert:(NSArray *)keywordArray;

/**
 * Load FKKeywordMap from a local file
 * @param path Path of the file
 * @return FKKeywordMap object
 */
+ (FKKeywordMap *)loadFrom:(NSString *)path;

/**
 * Returns whether the text contains any keyword in KeywordMap
 * @param text The text to find keyword
 * @return The result of match, if text contains a keyword, return YES
 */
- (BOOL)match:(NSString *)text;

/**
 * Save FKKeywordMap to a local file
 * @param path Path of the file
 * @return Result of saving to file
 */
- (BOOL)saveTo:(NSString *)path;

/**
 * Convert self to an array contains all keywords
 * @return An array of all keywords
 */
- (NSArray *)keywordArray;
@end
