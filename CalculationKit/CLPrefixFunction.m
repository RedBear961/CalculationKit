//
//  CLPrefixFunction.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLPrefixFunction.h"

static CGFloat trigonometricOperand(CGFloat operand) {
	BOOL isRad = CalculationKitUsesRadians();
	return isRad ? operand : operand * (M_PI / 180.0);
}

static CGFloat toDegress(void) {
	BOOL isRad = CalculationKitUsesRadians();
	return isRad ? 1.0 : (180.0 / M_PI);
}

@interface CLPrefixFunction ()

@property (nonatomic) CLPrefixFunctionBlock block;

@end

@implementation CLPrefixFunction

@synthesize stringValue = _stringValue;

static NSMutableDictionary<NSString *, CLPrefixFunction *> *_userFunctions = nil;
static NSDictionary<NSString *, CLPrefixFunction *> *_allFunctions = nil;

#define CALC_BLOCK CGFloat(NSString *prefixFunction, NSUInteger argumentCount, NSArray<NSNumber *> *arguments)

+ (NSDictionary<NSString *, CLPrefixFunction *> *)allFunctions {
	if (!_allFunctions) {
		NSMutableDictionary<NSString *, CLPrefixFunction *> *aAllFunctions =
#pragma mark - Primitive functions
		[@{@"sqrt" : [self prefixFunctionWithSignature:@"sqrt"
										 argumentCount:1
											 calcBlock:^CALC_BLOCK {
												 return sqrt(arguments[0].doubleValue);
											 }],
		   
		   @"log" : [self prefixFunctionWithSignature:@"log"
										 argumentCount:2
											 calcBlock:^CALC_BLOCK {
												 return log(arguments[1].doubleValue) / log(arguments[0].doubleValue);
											 }],
		   
		   @"ln" : [self prefixFunctionWithSignature:@"ln"
										 argumentCount:1
											 calcBlock:^CALC_BLOCK {
												 return log2(arguments[0].doubleValue);
											 }],
		   
		   @"lg" : [self prefixFunctionWithSignature:@"lg"
										 argumentCount:1
											 calcBlock:^CALC_BLOCK {
												 return log10(arguments[0].doubleValue);
											 }],
		   
		   @"abs" : [self prefixFunctionWithSignature:@"abs"
										 argumentCount:1
											 calcBlock:^CALC_BLOCK {
												 return arguments[0].doubleValue >= 0.0 ?: -arguments[0].doubleValue;
											 }],
		   
#pragma mark - Trigonometric functions
		   @"sin" : [self prefixFunctionWithSignature:@"sin"
										argumentCount:1
											calcBlock:^CALC_BLOCK {
												return sin(trigonometricOperand(arguments[0].doubleValue));
											}],
		   
		   @"cos" : [self prefixFunctionWithSignature:@"cos"
										argumentCount:1
											calcBlock:^CALC_BLOCK {
												return cos(trigonometricOperand(arguments[0].doubleValue));
											}],
		   
		   @"tan" : [self prefixFunctionWithSignature:@"tan"
										argumentCount:1
											calcBlock:^CALC_BLOCK {
												return tan(trigonometricOperand(arguments[0].doubleValue));
											}],
		   
		   @"cot" : [self prefixFunctionWithSignature:@"cot"
										argumentCount:1
											calcBlock:^CALC_BLOCK {
												return cos(trigonometricOperand(arguments[0].doubleValue)) / sin(trigonometricOperand(arguments[0].doubleValue));
											}],
		   
		   @"sec" : [self prefixFunctionWithSignature:@"sec"
										argumentCount:1
											calcBlock:^CALC_BLOCK {
												return 1.0 / cos(trigonometricOperand(arguments[0].doubleValue));
											}],
		   
		   @"csc" : [self prefixFunctionWithSignature:@"csc"
										argumentCount:1
											calcBlock:^CALC_BLOCK {
												return 1.0 / sin(trigonometricOperand(arguments[0].doubleValue));
											}],
		   
#pragma mark - Inverse trigonometric functions
		   @"arcsin" : [self prefixFunctionWithSignature:@"arcsin"
										argumentCount:1
											calcBlock:^CALC_BLOCK {
												return (asin(trigonometricOperand(arguments[0].doubleValue)) * toDegress());
											}],
		   
		   @"arccos" : [self prefixFunctionWithSignature:@"arccos"
										   argumentCount:1
											   calcBlock:^CALC_BLOCK {
												   return (acos(trigonometricOperand(arguments[0].doubleValue)) * toDegress());
											   }],
		   
		   @"arctan" : [self prefixFunctionWithSignature:@"arctan"
										   argumentCount:1
											   calcBlock:^CALC_BLOCK {
												   return (atan(trigonometricOperand(arguments[0].doubleValue)) * toDegress());
											   }],
		   
		   @"arccot" : [self prefixFunctionWithSignature:@"arccot"
										   argumentCount:1
											   calcBlock:^CALC_BLOCK {
												   return (M_PI_2 - atan(trigonometricOperand(arguments[0].doubleValue)) * toDegress());
											   }],
		   
		   @"arcsec" : [self prefixFunctionWithSignature:@"arcsec"
										   argumentCount:1
											   calcBlock:^CALC_BLOCK {
												   return (acos(1.0 / trigonometricOperand(arguments[0].doubleValue)) * toDegress());
											   }],
		   
		   @"arccsc" : [self prefixFunctionWithSignature:@"arccsc"
										   argumentCount:1
											   calcBlock:^CALC_BLOCK {
												   return (asin(1.0 / trigonometricOperand(arguments[0].doubleValue)) * toDegress());
											   }],
		} mutableCopy];
		
		[aAllFunctions addEntriesFromDictionary:_userFunctions];
		_allFunctions = [aAllFunctions copy];
	}
	return _allFunctions;
}

#undef CALC_BLOCK

+ (NSDictionary<NSString *, CLPrefixFunction *> *)userFunctions {
	return [_userFunctions copy];
}

+ (CLPrefixFunction *)prefixFunctionWithSignature:(NSString *)signature {
	return [self.allFunctions valueForKey:signature];
}

- (instancetype)initWithSignature:(NSString *)signature argumentCount:(NSUInteger)count calcBlock:(CLPrefixFunctionBlock)block {
	self = [super init];
	
	if (self) {
		_stringValue = signature;
		_argumentCount = count;
		_block = block;
	}
	
	return self;
}

+ (NSUInteger)argumentCountForPrefixFunction:(NSString *)signature {
	return [self.allFunctions valueForKey:signature].argumentCount;
}

- (CGFloat)calcWithArguments:(NSArray<NSNumber *> *)arguments {
	return self.block(_stringValue, _argumentCount, arguments);
}

+ (CGFloat)calcFunction:(NSString *)signature arguments:(NSArray<NSNumber *> *)arguments {
	CLPrefixFunction *function = [self prefixFunctionWithSignature:signature];
	if (function) {
		return function.block(function.stringValue, function.argumentCount, arguments);
	}
	
	NSString *reason = [NSString stringWithFormat:@"Attempting to execute an account of a prefix function \
						%@ whose signature is not a prefix function or has not been registered.", signature];
	@throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

+ (instancetype)prefixFunctionWithSignature:(NSString *)signature argumentCount:(NSUInteger)count calcBlock:(CLPrefixFunctionBlock)block {
	return [[self alloc] initWithSignature:signature argumentCount:count calcBlock:block];
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

+ (void)registerPrefixFunction:(NSString *)signature argumentCount:(NSUInteger)count calcBlock:(CLPrefixFunctionBlock)block {
	if ([self.allFunctions valueForKey:signature]) {
		_allFunctions = nil;
		CLPrefixFunction *function = [CLPrefixFunction prefixFunctionWithSignature:signature argumentCount:count calcBlock:block];
		[_userFunctions setObject:function forKey:signature];
	}
}

+ (void)removePrefixFunction:(NSString *)signature {
	if ([_userFunctions valueForKey:signature]) {
		_allFunctions = nil;
		[_userFunctions removeObjectForKey:signature];
	}
}

@end
