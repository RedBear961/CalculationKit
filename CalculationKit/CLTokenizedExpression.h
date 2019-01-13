//
//  CLTokenizedExpression.h
//  CalculationKit
//
//  Created by God on 13.01.2019.
//  Copyright © 2019 WebView, Lab. All rights reserved.
//

#import <CalculationKit/CLBase.h>
#import <CalculationKit/CLToken.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLTokenizedExpression<__covariant ObjectType : CLToken *> : NSObject

- (instancetype)initWithArray:(NSArray<ObjectType> *)aArray NS_DESIGNATED_INITIALIZER;

@property (readonly, nonatomic) NSUInteger count;

- (ObjectType)firstObject;
- (ObjectType)lastObject;

- (ObjectType)nextObject;
- (ObjectType)previousObject;

@end

NS_ASSUME_NONNULL_END
