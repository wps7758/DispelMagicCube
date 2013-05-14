//
//  Particle.h
//  DispelMagicCube
//
//  Created by rui luo on 13-3-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Particle : NSObject
{
    GLKVector3 _position;
    GLKVector3 _velocity;
    GLKVector3 _acceleration;
    GLKVector3 _deltaAcceler;
    GLKVector4 _color;
    GLKVector4 _deltaColor;
    CGFloat    _rotate;
    CGFloat    _rotateVelocity;
    CGFloat    _life;
    CGFloat    _decay;
    CGFloat    _size;
    CGFloat    _grow;
}

@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic, assign) GLKVector3 velocity;
@property (nonatomic, assign) GLKVector3 acceleration;
@property (nonatomic, assign) GLKVector3 deltaAcceler;
@property (nonatomic, assign) GLKVector4 color;
@property (nonatomic, assign) GLKVector4 deltaColor;
@property (nonatomic, assign) CGFloat    rotate;
@property (nonatomic, assign) CGFloat    rotateVelocity;
@property (nonatomic, assign) CGFloat    life;
@property (nonatomic, assign) CGFloat    decay;
@property (nonatomic, assign) CGFloat    size;
@property (nonatomic, assign) CGFloat    grow;

- (void)update;

@end

