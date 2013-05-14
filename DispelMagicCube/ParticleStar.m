//
//  ParticleStar.m
//  DispelMagicCube
//
//  Created by rui luo on 13-3-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ParticleStar.h"

@implementation ParticleStar

@synthesize emitterNumber   = _emitterNumber;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


- (void)setDefaultEmitter: (int)i
{
    _particleSystem[i].blendSrc = GL_SRC_ALPHA;
    _particleSystem[i].blendDst = GL_ONE_MINUS_SRC_ALPHA;
    
    _particleSystem[i].textureName = [NSString stringWithString:@"particleDefault"];
    
    _particleSystem[i].maxParticles = 30;
    _particleSystem[i].emitRange = RangeMake(3.0f, 2.0f);
    _particleSystem[i].lifeRange = RangeMake(8.0f, 2.0f);
    _particleSystem[i].sizeRange = RangeMake(0.01f, 0.01f);
    _particleSystem[i].colwRange = RangeMake(1.00f, 0.00f);
    _particleSystem[i].cdewRange = RangeMake(0.000f, 0.000f);
    _particleSystem[i].velxRange = RangeMake(-0.08f, 0.16f);
    _particleSystem[i].velyRange = RangeMake(-0.02f, 0.08f);
    _particleSystem[i].accxRange = RangeMake(-0.0001f, 0.0002f);
    _particleSystem[i].accyRange = RangeMake(-0.0004f, 0.0002f);
    
    _particleSystem[i].posxRange = RangeMake(0.9f*_emitterPosition[i].x, 0.2f*_emitterPosition[i].x);
    _particleSystem[i].posyRange = RangeMake(0.9f*_emitterPosition[i].y, 0.2f*_emitterPosition[i].y);
    _particleSystem[i].poszRange = RangeMake(0.9f*_emitterPosition[i].z, 0.2f*_emitterPosition[i].z);
    
    _particleSystem[i].colxRange = RangeMake(_emitterColor[i].x, 0.0f);
    _particleSystem[i].colyRange = RangeMake(_emitterColor[i].y, 0.0f);
    _particleSystem[i].colzRange = RangeMake(_emitterColor[i].z, 0.0f);
    
    _particleSystem[i].cdexRange = RangeMake(0.005f*_emitterColor[i].x, 0.0f);
    _particleSystem[i].cdeyRange = RangeMake(0.005f*_emitterColor[i].y, 0.0f);
    _particleSystem[i].cdezRange = RangeMake(0.005f*_emitterColor[i].z, 0.0f);
}

- (void)awake
{
    for (NSInteger i = 0; i < _emitterNumber; ++i)
    {
        _particleSystem[i] = [[ParticleSystem alloc] init];
        [self setDefaultEmitter:i];
        
        [_particleSystem[i] awake];
    }
    
}

- (void)dealloc
{
    for (NSInteger i = 0; i < _emitterNumber; ++i)
    {
        [_particleSystem[i] release];
    }
    [super dealloc];
}

- (void)draw
{
    for (NSInteger i = 0; i < _emitterNumber; ++i)
    {
        [_particleSystem[i] draw];
    }
}

- (void)update
{
    for (NSInteger i = 0; i < _emitterNumber; ++i)
    {
        [_particleSystem[i] update];
    }
}

- (void)setEmitterPosition: (GLKVector3)position: (int)i
{
    _emitterPosition[i] = position;
}

- (void)setEmitterColor: (GLKVector4)color: (int)i
{
    _emitterColor[i] = color;
}

@end
