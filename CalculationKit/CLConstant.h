/**
* CLConstant.h
* CalculationKit
*
* Copyright © 2019 WebView, Lab.
* All rights reserved.
*/

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLConstant : NSObject

@property (readonly, nonatomic) NSString *stringValue;
@property (readonly, nonatomic) NSString *formattedValue;
@property (readonly, nonatomic) CGFloat doubleValue;

+ (NSUInteger)hasConstant:(NSString *)string;

+ (CLConstant *)constantWithString:(NSString *)aString;

+ (void)addConstant:(NSString *)string value:(CGFloat)value formattedValue:(NSString *)formattedValue;
+ (void)removeConstant:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
