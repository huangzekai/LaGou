//
//  NSObject+SafeOperation.h
//  Friday
//
//  Created by Vi on 14/10/29.
//  Copyright (c) 2014年 xtuone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeOperation)
- (void)safeOpSetValue:(id)value forKey:(NSString *)key;
- (id)safeOpValueForKey:(NSString *)key;

- (NSNumber *)safeOpIntegerNumberValue;
- (NSString *)safeOpStringValue;
@end

@interface NSArray (SafeOperation)
- (id)safeOpObjectAtIndex:(NSUInteger)index;
@end

@interface NSMutableDictionary (SafeOperation)
- (void)safeOpSetObject:(id)object forKey:(id)key;
@end


