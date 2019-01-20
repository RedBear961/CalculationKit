//
//  CLExpressionFormatter.m
//  CalculationKit
//
//  Created by God on 19.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLExpressionFormatter.h"

#import "CLTokenizedExpression.h"
#import "CLAction.h"
#import "CLOperation.h"
#import "CLPrefixFunction.h"
#import "CLPostfixFunction.h"

@implementation CLExpressionFormatter

+ (instancetype)formatterWithExpression:(CLExpression *)expression {
	return [[self alloc] initWithExpression:expression];
}

- (instancetype)initWithExpression:(CLExpression *)expression {
	self = [super init];
	
	if (self) {
		_useSpace = YES;
	}
	
	return self;
}

- (NSAttributedString *)formattedExpressionWithFontName:(NSString *)name ofSize:(CGFloat)size {
	CLFont *font = [CLFont fontWithName:name size:size];
	return [self formattedExpressionWithFont:font];
}

- (NSAttributedString *)formattedExpressionWithFont:(NSFont *)font {
	NSCAssert(_expression, @"Attempt to format a null expression.");
	
	CLTokenizedExpression *expression = [_expression tokenizedExpression];
	[expression reset];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
	
	NSUInteger index = 0;
	while (index < expression.count) {
		CLToken *token = [expression nextObject];
		
		NSDictionary *attributes = nil;
		NSString *aString = nil;
		id<CLAction> action = nil;
		
		switch (token.type) {
			case CLTokenTypeConstant:
			case CLTokenTypeVariable:
			case CLTokenTypePrefixFunction:
			case CLTokenTypePostfixFunction:
			case CLTokenTypeSeparator:
				attributes = @{NSFontAttributeName : font};
				aString = token.stringValue;
				break;
				
			case CLTokenTypeOperation:
				action = [CLOperation operationWithSignature:token.stringValue];
				
				if ([action.stringValue isEqualToString:@"^"]) {
					NSAttributedString *power = [self processPower:&index tokenizedExpression:expression];
					[attributedString appendAttributedString:power];
					continue;
				}
				
				attributes = @{NSFontAttributeName : font};
				aString = action.formattedValue;
				break;
				
			case CLTokenTypeOpeningBrace:
				
				break;
				
			case CLTokenTypeClosingBrace:
				break;
				
			case CLTokenTypeUnknown:
				break;
		}
		
		NSAttributedString *appendString = [[NSAttributedString alloc] initWithString:aString attributes:attributes];
		[attributedString appendAttributedString:appendString];
		
		++index;
	}
	
	return [attributedString copy];
}

- (NSAttributedString *)processPower:(NSUInteger *)index tokenizedExpression:(CLTokenizedExpression *)expression {
	return nil;
}

- (NSString *)fastFormatting {
	NSCAssert(_expression, @"Attempt to format a null expression.");
	return nil;
}

@end
