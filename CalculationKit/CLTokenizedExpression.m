//
//  CLTokenizedExpression.m
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import "CLTokenizedExpression.h"

@interface CLTokenizedExpression ()

@property (nonatomic) NSMutableArray<CLToken *> *tokensArray;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation CLTokenizedExpression

- (instancetype)init {
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
	return [_tokensArray copy];
}

- (NSUInteger)count {
	return _tokensArray.count;
}

- (void)reset {
	_currentIndex = 0;
}

- (CLToken *)firstObject {
	_currentIndex = 0;
	return _tokensArray.firstObject;
}

- (CLToken *)nextObject {
	__kindof CLToken *token = nil;
	
	if (_currentIndex < _tokensArray.count) {
		token = [_tokensArray objectAtIndex:_currentIndex];
		++_currentIndex;
	}
	
	return token;
}

- (id)mutableCopy {
	return [[CLMutableTokenizedExpression alloc] initWithArray:_tokensArray];
}

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@ %p>(\n", self.className, self];
	[description appendString:[_tokensArray componentsJoinedByString:@",\n"]];
	[description appendString:@"\n)\n"];
	return description;
}

@end

@implementation CLMutableTokenizedExpression

@dynamic currentIndex;

- (id)copy {
	return [[CLTokenizedExpression alloc] initWithArray:self.tokensArray];
}

- (id)mutableCopy {
	return [[CLMutableTokenizedExpression alloc] initWithArray:self.tokensArray];
}

- (void)addObject:(CLToken *)object {
	[self.tokensArray addObject:object];
}

- (void)addObjectsFromArray:(NSArray<CLToken *> *)anArray {
	[self.tokensArray addObjectsFromArray:anArray];
}

- (void)removeObject:(CLToken *)object {
	CLToken *currentObject = nil;
	if (self.currentIndex < self.tokensArray.count)
		 currentObject = [self.tokensArray objectAtIndex:self.currentIndex];
	
	[self.tokensArray removeObject:object];
	
	if (currentObject)
		self.currentIndex = [self.tokensArray indexOfObject:currentObject];
}

- (void)removeObjectsInArray:(NSArray<CLToken *> *)anArray {
	CLToken *currentObject = nil;
	if (self.currentIndex < self.tokensArray.count)
		currentObject = [self.tokensArray objectAtIndex:self.currentIndex];
	
	[self.tokensArray removeObjectsInArray:anArray];
	
	if (currentObject)
		self.currentIndex = [self.tokensArray indexOfObject:currentObject];
}

@end
