//
//  CLPostfixFunction.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLPostfixFunction.h"

@interface CLPostfixFunction ()

@property (nonatomic) CLPostfixFunctionBlock block;

@end

@implementation CLPostfixFunction

@synthesize stringValue = _stringValue;
@synthesize formattedValue = _formattedValue;

static NSMutableDictionary<NSString *, CLPostfixFunction *> *_userFunctions = nil;
static NSDictionary<NSString *, CLPostfixFunction *> *_allFunctions = nil;

#define CALC_BLOCK CGFloat(NSString * postfixFunction, CGFloat operand)

+ (NSDictionary<NSString *, CLPostfixFunction *> *)allFunctions {
	if (!_allFunctions) {
		CLPostfixFunction *factorial = [CLPostfixFunction postfixFunctionWithSignature:@"!" calcBlock:^CALC_BLOCK {
			return [CLCalculator factorial:operand];
		}];
		
		CLPostfixFunction *doubleFactorial = [CLPostfixFunction postfixFunctionWithSignature:@"!!" calcBlock:^CALC_BLOCK {
			return [CLCalculator doubleFactorial:operand];
		}];
		
		NSMutableDictionary<NSString *, CLPostfixFunction *> *aAllFunctions = [@{@"!"	: factorial,
																				 @"!!"	: doubleFactorial,
																				 } mutableCopy];
		[aAllFunctions addEntriesFromDictionary:_userFunctions];
		_allFunctions = [aAllFunctions copy];
	}
	
	return _allFunctions;
}

#undef CALC_BLOCK

+ (nullable CLPostfixFunction *)postfixFunctionWithSignature:(NSString *)signature {
	return [self.allFunctions valueForKey:signature];
}

- (instancetype)initWithSignature:(NSString *)signature calcBlock:(CLPostfixFunctionBlock)block {
	self = [super init];
	
	if (self) {
		_stringValue = signature;
		_block = block;
	}
	
	return self;
}

+ (instancetype)postfixFunctionWithSignature:(NSString *)signature calcBlock:(CLPostfixFunctionBlock)block {
	return [[self alloc] initWithSignature:signature calcBlock:block];
}

- (CGFloat)calcWithOperand:(CGFloat)operand {
	return self.block(self.stringValue, operand);
}

+ (CGFloat)calcPostfixFunction:(NSString *)signature withOperand:(CGFloat)operand {
	CLPostfixFunction *function = [self postfixFunctionWithSignature:signature];
	if (function) {
		return function.block(signature, operand);
	}
	
	NSString *reason = [NSString stringWithFormat:@"Attempting to execute an account of a postfix function \
						%@ whose signature is not a postfix function or has not been registered.", signature];
	@throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

+ (NSMutableDictionary<NSString *, CLPostfixFunction *> *)userFunctions {
	if (_userFunctions == nil)
		_userFunctions = [@{} mutableCopy];
	return _userFunctions;
}

+ (NSUInteger)containsAction:(NSString *)signature {
	NSUInteger lenght = 0;
	for (NSString *key in [self.allFunctions allKeys]) {
		if ([signature hasPrefix:key] && key.length > lenght)
			lenght = key.length;
	}
	return lenght;
}

+ (BOOL)isUserAction:(NSString *)signature {
	for (NSString *key in [self.userFunctions allKeys]) {
		if ([signature hasPrefix:key])
			return YES;
	}
	return NO;
}

+ (void)registerPostfixFunction:(NSString *)signature calcBlock:(CLPostfixFunctionBlock)block {
	if (![self.allFunctions valueForKey:signature]) {
		_allFunctions = nil;
		CLPostfixFunction *function = [CLPostfixFunction postfixFunctionWithSignature:signature calcBlock:block];
		[self.userFunctions setObject:function forKey:signature];
	}
}

+ (void)removePostfixFunction:(NSString *)signature {
	if ([self.userFunctions valueForKey:signature]) {
		_allFunctions = nil;
		[self.userFunctions removeObjectForKey:signature];
	}
}

@end

@implementation CLCalculator (CLPostfixFunction)

+ (NSUInteger)factorial:(NSUInteger)n {
	if (!n || n == 1) {
		return 1;
	}
	
	return n * [self factorial:(n - 1)];
}

+ (NSUInteger)doubleFactorial:(NSUInteger)n {
	if (!n || n == 1) return 1;
	
	NSUInteger answer = 1;
	NSUInteger factor = n % 2 ? 2 : 1;
	
	for (; answer <= n; factor += 2) {
		answer = answer * factor;
	}
	
	return answer;
}

@end
