//
//  CLPostfixFunction.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLPostfixFunction.h"

NSUInteger fact(NSUInteger n) {
	if (!n || n == 1) {
		return 1;
	}
	
	return n * fact(n - 1);
}

NSUInteger doubleFact(NSUInteger n) {
	if (!n) return 1;
	
	NSUInteger answer = 1;
	NSUInteger factor = n % 2 ? 2 : 1;
	
	for (; answer <= n; factor += 2) {
		answer = answer * factor;
	}
	
	return answer;
}

@interface CLPostfixFunction ()

@property (nonatomic) CLPostfixFunctionBlock block;

@end

@implementation CLPostfixFunction

@synthesize stringValue = _stringValue;

static NSMutableDictionary<NSString *, CLPostfixFunction *> *_userFunctions = nil;
static NSDictionary<NSString *, CLPostfixFunction *> *_allFunctions = nil;

#define CALC_BLOCK CGFloat(NSString * postfixFunction, CGFloat operand)

+ (NSDictionary<NSString *, CLPostfixFunction *> *)allFunctions {
	if (!_allFunctions) {
		CLPostfixFunction *factorial = [CLPostfixFunction postfixFunctionWithSignature:@"!" calcBlock:^CALC_BLOCK {
			return fact(operand);
		}];
		
		CLPostfixFunction *doubleFactorial = [CLPostfixFunction postfixFunctionWithSignature:@"!!" calcBlock:^CALC_BLOCK {
			return doubleFact(operand);
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

+ (NSDictionary<NSString *, CLPostfixFunction *> *)userFunctions {
	return [_userFunctions copy];
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
	for (NSString *key in [_userFunctions allKeys]) {
		if ([signature hasPrefix:key])
			return YES;
	}
	return NO;
}

+ (void)registerPostfixFunction:(NSString *)signature calcBlock:(CLPostfixFunctionBlock)block {
	if ([self.allFunctions valueForKey:signature]) {
		_allFunctions = nil;
		CLPostfixFunction *function = [CLPostfixFunction postfixFunctionWithSignature:signature calcBlock:block];
		[_userFunctions setObject:function forKey:signature];
	}
}

+ (void)removePostfixFunction:(NSString *)signature {
	if ([_userFunctions valueForKey:signature]) {
		_allFunctions = nil;
		[_userFunctions removeObjectForKey:signature];
	}
}

@end
