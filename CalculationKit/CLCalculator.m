//
//  CLCalculator.m
//  CalculationKit
//
//  Created by God on 17.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLCalculator.h"

#import "CLBase.h"
#import "CLError.h"
#import "CLStack.h"
#import "CLTokenizedExpression.h"

#import "CLOperation.h"
#import "CLPrefixFunction.h"
#import "CLPostfixFunction.h"

@interface CLCalculator ()

@property (nonatomic) CLStack<NSNumber *> *stack;

@end

@implementation CLCalculator

- (instancetype)init {
	self = [super init];
	
	if (self) {
		_stack = [[CLStack alloc] init];
	}
	
	return self;
}

- (CGFloat)calcExpression:(CLExpression *)expression withError:(NSError * _Nullable __autoreleasing *)error {
	[_stack reset];
	
	CLTokenizedExpression *tokenizedExpression = [expression reversePolishNotation];
	
	NSUInteger index = 0;
	while (index < tokenizedExpression.count) {
		CLToken *token = [tokenizedExpression nextObject];
		
		NSError *calculatorError = nil;
		
		switch (token.type) {
			case CLTokenTypeConstant:
				[_stack push:@([token constant])];
				break;
				
			case CLTokenTypeOperation:
				[self processOperation:token
							 withError:&calculatorError];
				break;
				
			case CLTokenTypePrefixFunction:
				[self processPrefixFunction:token
								  withError:&calculatorError];
				break;
				
			case CLTokenTypePostfixFunction:
				[self processPostfixFunction:token
								   withError:&calculatorError];
				break;
				
			case CLTokenTypeUnknown:
			default:
				break;
		}
		
		if (calculatorError) {
			if (error)
				*error = calculatorError;
			return calculatorError.code;
		}
		
		++index;
	}
	
	if (_stack.count > 1) {
		if (error)
			*error = [NSError errorWithDomain:CLCalculatorDomain
										 code:CLExtraArguments
									 userInfo:nil];
		return CLExtraArguments;
	}
	
	NSNumber *lastValue = [_stack pop];
	CGFloat answer = [lastValue doubleValue];
	
	answer = [CLCalculator roundFractionPart:answer];
	return answer;
}

- (NSUInteger)processOperation:(CLToken *)token withError:(NSError **)error {
	if (_stack.count < 2) {
		if (error)
			*error = [NSError errorWithDomain:CLCalculatorDomain
										 code:CLNotEnoughArguments
									 userInfo:nil];
		return 0;
	}
	
	NSNumber *right = [_stack pop];
	NSNumber *left = [_stack pop];
	
	CGFloat result = [CLOperation calcOperation:token.stringValue
									  leftOperand:left.doubleValue
									 rightOperand:right.doubleValue];
	
	[_stack push:@(result)];
	return 0;
}

- (NSUInteger)processPrefixFunction:(CLToken *)token withError:(NSError **)error {
	CLPrefixFunction *function = [CLPrefixFunction prefixFunctionWithSignature:token.stringValue];
	
	if (_stack.count < function.argumentCount) {
		if (error)
			*error = [NSError errorWithDomain:CLCalculatorDomain
										 code:CLNotEnoughArguments
									 userInfo:nil];
		return 0;
	}
	
	NSMutableArray *operands = [@[] mutableCopy];
	for (int i = 0; i < function.argumentCount; ++i) {
		NSNumber *nextValue = [_stack pop];
		
		[operands addObject:nextValue];
	}
	
	CGFloat result = [function calcWithArguments:operands.reverseObjectEnumerator.allObjects];
	[_stack push:@(result)];
	return 0;
}

- (NSUInteger)processPostfixFunction:(CLToken *)token withError:(NSError **)error {
	CLPostfixFunction *function = [CLPostfixFunction postfixFunctionWithSignature:token.stringValue];
	
	if (!_stack.count) {
		if (error)
			*error = [NSError errorWithDomain:CLCalculatorDomain
										 code:CLNotEnoughArguments
									 userInfo:nil];
		return 0;
	}
	
	NSNumber *operand = [_stack pop];
	CGFloat result = [function calcWithOperand:operand.doubleValue];
	[_stack push:@(result)];
	return 0;
}

+ (CGFloat)roundFractionPart:(CGFloat)number {
	CLBase *base = [CLBase shared];
	NSUInteger signCount = [base countOfDecimalPlaces];
	
	if (!signCount) return (CGFloat)((unsigned long long)number);
	
	NSUInteger multi = 10;
	for (int i = 0; i < signCount; ++i, multi *= 10);
	return round(number * multi) / multi;
}

@end

@implementation CLExpression (CLCalculator)

- (CGFloat)calc:(NSError * _Nullable __autoreleasing *)error {
	NSError *calcError = nil;
	CLCalculator *calculator = [[CLCalculator alloc] init];
	CGFloat answer = [calculator calcExpression:self withError:&calcError];
	
	if (calcError && error)
		*error = calcError;
	
	return answer;
}

@end
