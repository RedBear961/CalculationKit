/*
 * CLOperation.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLOperation.h"

@interface CLOperation ()

// Operation calculation block.
@property (nonatomic) CLOperationBlock block;

// The priority of the operation.
@property (nonatomic) CLOperationPriority priority;

@end

@implementation CLOperation

@synthesize stringValue = _stringValue;

// Buffer storage of the user operations.
static NSMutableDictionary<NSString *, CLOperation *> *_userOperations = nil;

// Storage buffer for all operations.
static NSDictionary<NSString *, CLOperation *> *_allOperations = nil;

#define CALC_BLOCK CGFloat(NSString *op, CGFloat left, CGFloat right)

+ (NSDictionary<NSString *, CLOperation *> *)allOperations {
	if (!_allOperations) {
		// Generate a standard set of supported operations.
		CLOperation *plus 	= [[CLOperation alloc] initWithSignature:@"+" calcBlock:^CALC_BLOCK {
			return left + right;
		} priority:CLOperationPriorityLower];
		
		CLOperation *minus 	= [[CLOperation alloc] initWithSignature:@"-" calcBlock:^CALC_BLOCK {
			return left - right;
		} priority:CLOperationPriorityLower];
		
		CLOperation *power	= [[CLOperation alloc] initWithSignature:@"^" calcBlock:^CALC_BLOCK {
			return pow(left, right);
		} priority:CLOperationPriorityHigh];
		
		CLOperation *multi	= [[CLOperation alloc] initWithSignature:@"*" calcBlock:^CALC_BLOCK {
			return left * right;
		} priority:CLOperationPriorityMedium];
		
		CLOperation *div	= [[CLOperation alloc] initWithSignature:@"/" calcBlock:^CALC_BLOCK {
			return left / right;
		} priority:CLOperationPriorityMedium];
		
		NSMutableDictionary<NSString *, CLOperation *> *aAllOperations = [@{@"+" : plus,
																			@"-" : minus,
																			@"^" : power,
																			@"*" : multi,
																			@"/" : div,
																			} mutableCopy];
		
		// Enable user operations.
		[aAllOperations addEntriesFromDictionary:[self userOperations]];
		_allOperations = [aAllOperations copy];
	}
	
	return _allOperations;
}

#undef CALC_BLOCK

+ (NSMutableDictionary<NSString *, CLOperation *> *)userOperations {
	if (_userOperations == nil)
		_userOperations = [@{} mutableCopy];
	return _userOperations;
}

+ (NSUInteger)containsAction:(NSString *)signature {
	NSUInteger lenght = 0;
	for (NSString *key in [self.allOperations allKeys]) {
		if ([signature hasPrefix:key] && key.length > lenght)
			lenght = key.length;
	}
	return lenght;
}

+ (BOOL)isUserAction:(NSString *)signature {
	for (NSString *key in [self.userOperations allKeys]) {
		if ([signature hasPrefix:key])
			return YES;
	}
	return NO;
}

+ (nullable CLOperation *)operationWithSignature:(NSString *)signature {
	return [self.allOperations valueForKey:signature];
}

+ (CLOperationPriority)priorityForOperation:(NSString *)signature {
	CLOperation *operation = [self.allOperations objectForKey:signature];
	if (operation)
		return operation.priority;
	
	return CLOperationPriorityUnknown;
}

- (CGFloat)calcWithLeftOperand:(CGFloat)left rightOperand:(CGFloat)right {
	return self.block(self.stringValue, left, right);
}

+ (CGFloat)calcOperation:(NSString *)signature leftOperand:(CGFloat)left rightOperand:(CGFloat)right {
	CLOperation *operation = [self.allOperations objectForKey:signature];
	if (operation) {
		return operation.block(signature, left, right);
	}
	
	NSString *reason = [NSString stringWithFormat:@"An attempt to execute an account \
						operation '%@' whose signature is not a binary operation or has not been registered.", signature];
	@throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
}

- (instancetype)initWithSignature:(NSString *)signature calcBlock:(CLOperationBlock)block priority:(CLOperationPriority)priority {
	self = [super init];
	
	if (self) {
		_stringValue = signature;
		_block = block;
		_priority = priority;
	}
	
	return self;
}

+ (void)registerOperation:(NSString *)signature calcBlock:(CLOperationBlock)block priority:(CLOperationPriority)priority {
	if (![self.allOperations valueForKey:signature]) {
		_allOperations = nil;
		CLOperation *operation = [[CLOperation alloc] initWithSignature:signature calcBlock:block priority:priority];
		[self.userOperations setObject:operation forKey:signature];
	}
}

+ (void)removeOperation:(NSString *)signature {
	if ([self.userOperations valueForKey:signature]) {
		_allOperations = nil;
		[self.userOperations removeObjectForKey:signature];
	}
}

@end
