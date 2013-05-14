//
//  ParticleFire.m
//  DispelMagicCube
//
//  Created by rui luo on 13-3-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ParticleFire.h"

@implementation ParticleFire

- (id)init
{
    self = [super init];
    if (self) {
        _particleSystem = [[ParticleSystem alloc] init];
        
        _particleSystem.textureName = [NSString stringWithString:@"particleFire"];
        
        _particleSystem.maxParticles = 100;
        _particleSystem.emitRange = RangeMake(4.0f, 2.0f);
        _particleSystem.sizeRange = RangeMake(0.08f, 0.04f);
        _particleSystem.colxRange = RangeMake(0.25f, 0.02f);
        _particleSystem.colyRange = RangeMake(0.20f, 0.06f);
        _particleSystem.colzRange = RangeMake(0.75f, 0.10f);
        _particleSystem.colwRange = RangeMake(1.00f, 0.00f);
        _particleSystem.cdexRange = RangeMake(0.002f, 0.00f);
        _particleSystem.cdeyRange = RangeMake(0.002f, 0.00f);
        _particleSystem.cdezRange = RangeMake(0.007f, 0.00f);
        _particleSystem.cdewRange = RangeMake(0.000f, 0.00f);
        
        [_particleSystem awake];
    }
    
    return self;
}

- (void)dealloc
{
    [_particleSystem release];
    [super dealloc];
}

- (void)draw
{
    [_particleSystem draw];
}

- (void)update
{
    [_particleSystem update];
}

@end
