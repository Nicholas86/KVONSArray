//
//  Student.m
//  TestKVOArray
//
//  Created by lanouhn on 15/9/7.
//  Copyright (c) 2015年 LiYang. All rights reserved.
//

#import "Student.h"

@implementation Student
- (void)dealloc {
    [_name release];
    [super dealloc];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        int num = arc4random() % 55;
        self.name = [NSString stringWithFormat:@"28班同学学号:%d", num];
    }
    return self;
}
@end
