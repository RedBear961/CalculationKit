/*
 * CLTokenizedExpression.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLTokenizedExpression.h"

@interface CLTokenizedExpression ()

@property (nonatomic) NSMutableArray<CLToken *> *tokensArray;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation CLTokenizedExpression

- (instancetype)init {
	// Passes the call to the designated constructor.
	return [self initWithArray:@[]];
}

- (instancetype)initWithArray:(NSArray *)aArray {
	self = [super init];
	
	if (self) {
		_tokensArray = [aArray mutableCopy];
		_currentIndex = 0;
	}
	
	return self;
}

- (NSArray *)array {
	// Returns an immutable copy of the buffer.
	return [_tokensArray copy];
}

- (NSUInteger)count {
	return _tokensArray.count;
}

- (void)reset {
	// Resets the sequence number.
	_currentIndex = 0;
}

- (CLToken *)firstObject {
	// Clears the sequence number and returns the first element.
	_currentIndex = 0;
	return _tokensArray.firstObject;
}

- (CLToken *)nextObject {
	__kindof CLToken *token = nil;
	
	// Checks for the existence of the next element.
	if (_currentIndex < _tokensArray.count) {
		token = [_tokensArray objectAtIndex:_currentIndex];
		++_currentIndex;
	}
	
	return token;
}

- (id)mutableCopy {
	// Returns an heir - variable tokenized expression.
	return [[CLMutableTokenizedExpression alloc] initWithArray:_tokensArray];
}

- (NSString *)description {
	// Builds a class description. Identical to the array descriptor.
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@ %p>(\n", self.className, self];
	[description appendString:[_tokensArray componentsJoinedByString:@",\n"]];
	[description appendString:@"\n)\n"];
	return [description copy];
}

@end

@implementation CLMutableTokenizedExpression

@dynamic currentIndex;

- (id)copy {
	// Returns its immutable copy.
	return [[CLTokenizedExpression alloc] initWithArray:self.tokensArray];
}

- (id)mutableCopy {
	// Returns its copy.
	return [[CLMutableTokenizedExpression alloc] initWithArray:self.tokensArray];
}

- (void)addObject:(CLToken *)object {
	// Adds a new element to the end of the array.
	[self.tokensArray addObject:object];
}

- (void)removeObject:(CLToken *)object {
	// Checks for the occurrence of a sequence number in the range of existing sequence numbers.
	// Saves an object that has this sequence number.
	CLToken *currentObject = nil;
	if (self.currentIndex < self.tokensArray.count)
		 currentObject = [self.tokensArray objectAtIndex:self.currentIndex];
	
	// Deletes the passed object.
	[self.tokensArray removeObject:object];
	
	// Selects the new sequence number of the current item.
	if (currentObject)
		self.currentIndex = [self.tokensArray indexOfObject:currentObject];
	else
		self.currentIndex = 0;
}

@end
