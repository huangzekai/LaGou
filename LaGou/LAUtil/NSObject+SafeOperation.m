//
//  NSObject+SafeOperation.m
//  Friday
//
//  Created by Vi on 14/10/29.
//  Copyright (c) 2014年 xtuone. All rights reserved.
//

#import "NSObject+SafeOperation.h"

@implementation NSObject (SafeOperation)
- (void)safeOpSetValue:(id)value forKey:(NSString *)key {
    //等价于
    //if ([objectA respondsToSelector:@selector(setItem:)]) {
    //  [objectA setValue:anObject forKey:@"item"];
    //}
    if (!value || !key.length) {
        return;
    }
    NSMutableString *keyCopy = key.mutableCopy;
    NSString *initial = [key substringWithRange:NSMakeRange(0, 1)];
    NSString *replacement = initial.uppercaseString;
    [keyCopy replaceCharactersInRange:NSMakeRange(0, 1) withString:replacement];
    NSString *selectorString = [NSString stringWithFormat:@"set%@:", keyCopy];
    SEL selector = NSSelectorFromString(selectorString);
    if ([self respondsToSelector:selector]) {
        [self setValue:value forKey:key];
    }
}

- (id)safeOpValueForKey:(NSString *)key {
    SEL selector = NSSelectorFromString(key);
    if ([self respondsToSelector:selector]) {
        return [self valueForKey:key];
    }
    return nil;
}

- (NSNumber *)safeOpIntegerNumberValue {
    id value = [self safeOpValueForKey:@"integerValue"];
    if (value) {
        return value;
    }
    return @([NSString stringWithFormat:@"%@", self].integerValue);
}

- (NSString *)safeOpStringValue {
    id value = [self safeOpValueForKey:@"stringValue"];
    if (value) {
        return value;
    }
    return [NSString stringWithFormat:@"%@", self];
}

@end

@implementation NSArray (SafeOperation)

- (id)safeOpObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return self[index];
}

@end

@implementation NSMutableDictionary (SafeOperation)
- (void)safeOpSetObject:(id)object forKey:(id)key {
    if (object && key) {
        self[key] = object;
    }
}
@end