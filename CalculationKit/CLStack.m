//
//  CLStack.m
//  CalculationLibrary
//
//  Created by Georgiy Cheremnykh on 27.11.2018.
//  Copyright © 2018 WebView, Lab. All rights reserved.
//

#import "CLStack.h"

@interface CLStack ()

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
	[_buffer addObject:object];
}

- (id)pop {
	id object = [_buffer lastObject];
	[_buffer removeLastObject];
	return object;
}

- (NSUInteger)count {
	return _buffer.count;
}

- (NSString *)description {
	return _buffer.description;
}

@end
