/*
 * CLStack.m
 * CalculationKit
 *
 * Copyright © 2019 WebView, Lab.
 * All rights reserved.
 */

#import "CLStack.h"

@interface CLStack ()

// Buffer with elements.
@property (nonatomic) NSMutableArray *buffer;

@end

@implementation CLStack

- (instancetype)init {
	if (self = [super init]) {
		_buffer = [@[] mutableCopy];
	}
	return self;
}

- (void)push:(id)object {
	// Adds an element to the top of the stack.
	[_buffer addObject:object];
}

- (id)pop {
	// Removes the element from the top of the stack and returns it.
	id object = [_buffer lastObject];
	[_buffer removeLastObject];
	return object;
}

- (NSUInteger)count {
	// The number of elements in the stack.
	return _buffer.count;
}

- (void)reset {
	// Removes all items.
	[_buffer removeAllObjects];
}

- (NSString *)description {
	// Builds a class description. Identical to the array descriptor.
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@ %p>(\n", self.className, self];
	[description appendString:[_buffer componentsJoinedByString:@",\n"]];
	[description appendString:@"\n)\n"];
	return [description copy];
}

@end
