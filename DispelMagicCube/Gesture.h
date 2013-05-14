//
//  GestureAnalysis.h
//  DispelMagicCube
//
//  Created by rui luo on 13-3-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Gesture : NSObject
{
    NSInteger _axis;
    NSInteger _value;
    NSInteger _direction;
    BOOL      _isRotate;
}

@property (nonatomic, assign) NSInteger axis;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) BOOL      isRotate;

- (void)resolve: (CGPoint)p1: (CGPoint)p2 :(GLKMatrix4)centreRotMatrix;

@end
