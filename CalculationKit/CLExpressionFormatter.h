//
//  CLExpressionFormatter.h
//  CalculationKit
//
//  Created by God on 19.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLExpression.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLExpressionFormatter : NSObject

@property (nonatomic, getter=isUseSpace) BOOL useSpace;
// @property (nonatomic, getter=isFormatPower) BOOL formatPower;

@property (nonatomic) CLExpression *expression;

- (instancetype)initWithExpression:(CLExpression *)expression;
+ (instancetype)formatterWithExpression:(CLExpression *)expression;

- (NSAttributedString *)formattedExpressionWithFontName:(NSString *)name ofSize:(CGFloat)size;
- (NSAttributedString *)formattedExpressionWithFont:(CLFont *)font;

- (NSString *)fastFormatting;

@end

NS_ASSUME_NONNULL_END
