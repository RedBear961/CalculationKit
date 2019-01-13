//
//  CLStack.h
//  CalculationLibrary
//
//  Created by Georgiy Cheremnykh on 27.11.2018.
//  Copyright © 2018 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLStack<__covariant ObjectType> : NSObject

@property (readonly, nonatomic) NSUInteger count;

- (void)push:(ObjectType)object;
- (ObjectType)pop;

@end

NS_ASSUME_NONNULL_END
