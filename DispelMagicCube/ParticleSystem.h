//
//  ParticleSystem.h
//  DispelMagicCube
//
//  Created by rui luo on 13-3-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Particle.h"

#define M_TAU (2*M_PI)

typedef struct {
	CGFloat start, length;
} Range;

static inline Range RangeMake(CGFloat start, CGFloat len)
{
	return (Range) {start,len};
}

static inline CGFloat RandomFloat(Range range) 
{
	CGFloat randPercent = ( (CGFloat)(random() % 1001) ) / 1000.0;
	CGFloat offset = randPercent * range.length;
	return offset + range.start;	
}

@interface ParticleSystem : NSObject
{
    NSMutableArray *_activeParticles;
	NSMutableArray *_objectsToRemove;
    NSMutableArray *_particlePool;
    
    GLfloat        *_colors;
    GLfloat        *_uvCoordinates;
    GLfloat        *_vertexes;
    
    NSInteger      _vertexIndex;
    
    GLenum         _blendSrc;
    GLenum         _blendDst;
    
    NSString       *_textureName;
    NSString       *_textureType;
    
    BOOL           _emit;
    NSInteger      _emitCounter;
    NSInteger      _maxParticles;
    Range          _emitRange;
    
    Range          _rotaRange;
    Range          _roveRange;
    
    Range          _posxRange;
    Range          _posyRange;
    Range          _poszRange;
    
    Range          _velxRange;
    Range          _velyRange;
    Range          _velzRange;
    
    Range          _accxRange;
    Range          _accyRange;
    Range          _acczRange;
    
    Range          _adexRange;
    Range          _adeyRange;
    Range          _adezRange;
    
    Range          _colxRange;
    Range          _colyRange;
    Range          _colzRange;
    Range          _colwRange;
    
    Range          _cdexRange;
    Range          _cdeyRange;
    Range          _cdezRange;
    Range          _cdewRange;
    
    Range          _sizeRange;
    Range          _growRange;
    Range          _lifeRange;
    Range          _deceRange;
    
    GLKBaseEffect *_effect;
}

@property (nonatomic, assign) GLenum    blendSrc;
@property (nonatomic, assign) GLenum    blendDst;

@property (nonatomic, copy)   NSString  *textureName;
@property (nonatomic, copy)   NSString  *textureType;

@property (nonatomic, assign) BOOL      emit;
@property (nonatomic, assign) NSInteger emitCounter;
@property (nonatomic, assign) NSInteger maxParticles;
@property (nonatomic, assign) Range     emitRange;

@property (nonatomic, assign) Range     rotaRange;
@property (nonatomic, assign) Range     roveRange;

@property (nonatomic, assign) Range     posxRange;
@property (nonatomic, assign) Range     posyRange;
@property (nonatomic, assign) Range     poszRange;

@property (nonatomic, assign) Range     velxRange;
@property (nonatomic, assign) Range     velyRange;
@property (nonatomic, assign) Range     velzRange;

@property (nonatomic, assign) Range     accxRange;
@property (nonatomic, assign) Range     accyRange;
@property (nonatomic, assign) Range     acczRange;

@property (nonatomic, assign) Range     adexRange;
@property (nonatomic, assign) Range     adeyRange;
@property (nonatomic, assign) Range     adezRange;

@property (nonatomic, assign) Range     colxRange;
@property (nonatomic, assign) Range     colyRange;
@property (nonatomic, assign) Range     colzRange;
@property (nonatomic, assign) Range     colwRange;

@property (nonatomic, assign) Range     cdexRange;
@property (nonatomic, assign) Range     cdeyRange;
@property (nonatomic, assign) Range     cdezRange;
@property (nonatomic, assign) Range     cdewRange;

@property (nonatomic, assign) Range     sizeRange;
@property (nonatomic, assign) Range     growRange;
@property (nonatomic, assign) Range     lifeRange;
@property (nonatomic, assign) Range     deceRange;


- (void)update;
- (void)awake;
- (void)draw;
- (void)setTexture;

@end