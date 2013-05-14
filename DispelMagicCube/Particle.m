//
//  Particle.m
//  DispelMagicCube
//
//  Created by rui luo on 13-3-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Particle.h"

@implementation Particle

@synthesize position       = _position;
@synthesize velocity       = _velocity;
@synthesize acceleration   = _acceleration;
@synthesize deltaAcceler   = _deltaAcceler;
@synthesize color          = _color;
@synthesize deltaColor     = _deltaColor;
@synthesize rotate         = _rotate;
@synthesize rotateVelocity = _rotateVelocity;
@synthesize life           = _life;
@synthesize decay          = _decay;
@synthesize size           = _size;
@synthesize grow           = _grow;

- (void)update
{
    _acceleration.x -= _acceleration.x > 0 ? _deltaAcceler.x : -_deltaAcceler.x;
    _acceleration.y -= _acceleration.y > 0 ? _deltaAcceler.y : -_deltaAcceler.y;
    _acceleration.z -= _acceleration.z > 0 ? _deltaAcceler.z : -_deltaAcceler.z;
    
    _velocity.x += _acceleration.x;
    _velocity.y += _acceleration.y;
    _velocity.z += _acceleration.z;
    
    _position.x += _velocity.x;
    _position.y += _velocity.y;
    _position.z += _velocity.z;
    
    _rotate += _rotateVelocity;
    
    _color.x -= _deltaColor.x;
    _color.y -= _deltaColor.y;
    _color.z -= _deltaColor.z;
    _color.w -= _deltaColor.w;
    
    _life -= _decay;
    _size += _grow;
    if (_size < 0.0) { 
        _size = 0.0;
    }
}

@end
