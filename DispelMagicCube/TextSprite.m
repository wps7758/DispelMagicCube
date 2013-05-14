//
//  TextSprite.m
//  DispelMagicCube
//
//  Created by rui luo on 13-3-29.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "TextSprite.h"

static BOOL initialized = NO;
static GLKBaseEffect *effect;

@implementation TextSprite

@synthesize word       = _word;
@synthesize wordNumber = _wordNumber;
@synthesize position   = _position;
@synthesize size       = _size;

- (void)dealloc
{
    [effect release];
    free(_vertices);
    free(_texture);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (void)initialize
{
    if (!initialized) 
    {
        effect = [[GLKBaseEffect alloc] init];
        effect.transform.modelviewMatrix  = GLKMatrix4MakeLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
        effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 2.0/3.0, 2, -1);
    }
}


- (void)update
{
    [self buildVertexArrays];
}

- (void)awake
{
    if (_wordNumber == 0)
    {
        _vertices      = (CGFloat *) malloc(3 * 6 * 1 * sizeof(CGFloat));
        _texture       = (CGFloat *) malloc(2 * 6 * 1 * sizeof(CGFloat));
    }
    else 
    {
        _vertices      = (CGFloat *) malloc(3 * 6 * 10 * sizeof(CGFloat));
        _texture       = (CGFloat *) malloc(2 * 6 * 10 * sizeof(CGFloat));
    }
    
    [self setTexture];
    
    [self buildVertexArrays];
}

- (void)setTexture
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
                             GLKTextureLoaderOriginBottomLeft, nil];
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"text" ofType:@"png"];
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    effect.texture2d0.name = info.name;
    effect.texture2d0.enabled = GL_TRUE;
}

- (void)buildVertexArrays
{
    _verticesIndex = 0;
    if (_wordNumber == 0)
    {
        GLKVector4 t = [self textureCoordinate:_word];
        [self addVertex:GLKVector3Make(_position.x-0.5*_size.x, _position.y-0.5*_size.y, 0) :GLKVector2Make(t.x, t.z)];
        [self addVertex:GLKVector3Make(_position.x+0.5*_size.x, _position.y-0.5*_size.y, 0) :GLKVector2Make(t.y, t.z)];
        [self addVertex:GLKVector3Make(_position.x-0.5*_size.x, _position.y+0.5*_size.y, 0) :GLKVector2Make(t.x, t.w)];
        
        [self addVertex:GLKVector3Make(_position.x-0.5*_size.x, _position.y+0.5*_size.y, 0) :GLKVector2Make(t.x, t.w)];
        [self addVertex:GLKVector3Make(_position.x+0.5*_size.x, _position.y-0.5*_size.y, 0) :GLKVector2Make(t.y, t.z)];
        [self addVertex:GLKVector3Make(_position.x+0.5*_size.x, _position.y+0.5*_size.y, 0) :GLKVector2Make(t.y, t.w)];

    }
    else
    {
        NSInteger scores = _word;
        NSInteger score[_wordNumber];
        for (NSInteger i = 0; i < _wordNumber; ++i)
        {
            score[i] = (scores % powi(10, i+1)) / powi(10, i);
            
            GLKVector4 t = [self textureCoordinate:score[i]];
            
            // 每个字的大小
            GLKVector2 sSize = GLKVector2Make(_size.x/_wordNumber, _size.y);
            // 中间字的位置
            GLKVector2 cPosi = GLKVector2Make(((_wordNumber-1)%2)*(0.5*sSize.x)+_position.x, _position.y);
            // 当前字的位置
            GLKVector2 sPosi = GLKVector2Make(((_wordNumber-1)/2-i)*sSize.x+cPosi.x, cPosi.y);
            
            [self addVertex:GLKVector3Make(sPosi.x-0.5*sSize.x, sPosi.y-0.5*sSize.y, 0) :GLKVector2Make(t.x, t.z)];
            [self addVertex:GLKVector3Make(sPosi.x+0.5*sSize.x, sPosi.y-0.5*sSize.y, 0) :GLKVector2Make(t.y, t.z)];
            [self addVertex:GLKVector3Make(sPosi.x-0.5*sSize.x, sPosi.y+0.5*sSize.y, 0) :GLKVector2Make(t.x, t.w)];
            
            [self addVertex:GLKVector3Make(sPosi.x-0.5*sSize.x, sPosi.y+0.5*sSize.y, 0) :GLKVector2Make(t.x, t.w)];
            [self addVertex:GLKVector3Make(sPosi.x+0.5*sSize.x, sPosi.y-0.5*sSize.y, 0) :GLKVector2Make(t.y, t.z)];
            [self addVertex:GLKVector3Make(sPosi.x+0.5*sSize.x, sPosi.y+0.5*sSize.y, 0) :GLKVector2Make(t.y, t.w)];
        }
        
    }
    
}

- (void)addVertex:(GLKVector3)p :(GLKVector2)t
{
	NSInteger pos = _verticesIndex * 3.0;
	_vertices[pos]   = p.x;
	_vertices[pos+1] = p.y;
	_vertices[pos+2] = p.z;
	
	pos = _verticesIndex * 2.0;
	_texture[pos]   = t.x;
	_texture[pos+1] = t.y;
    
	++_verticesIndex;
}

- (void)draw
{
    [effect prepareToDraw];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, _vertices);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, _texture);
    
    glDrawArrays(GL_TRIANGLES, 0, _verticesIndex);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glDisable(GL_BLEND);
}

- (GLKVector4)textureCoordinate: (NSInteger)num
{
    CGFloat    minU;
    CGFloat    minV;
    CGFloat    maxU;
    CGFloat    maxV;
    
    switch (num) {
        case 0:
            minU = 0.83f;
            minV = 0.78f;
            maxU = 0.98f;
            maxV = 0.98f;
            break;
        case 1:
            minU = 0.82f;
            minV = 0.53f;
            maxU = 0.97f;
            maxV = 0.73f;
            break;
        case 2:
            minU = 0.07f;
            minV = 0.23f;
            maxU = 0.22f;
            maxV = 0.43f;
            break;
        case 3:
            minU = 0.32f;
            minV = 0.23f;
            maxU = 0.47f;
            maxV = 0.45f;
            break;
        case 4:
            minU = 0.57f;
            minV = 0.23f;
            maxU = 0.72f;
            maxV = 0.43f;
            break;
        case 5:
            minU = 0.82f;
            minV = 0.23f;
            maxU = 0.97f;
            maxV = 0.43f;
            break;
        case 6:
            minU = 0.05f;
            minV = 0.00f;
            maxU = 0.20f;
            maxV = 0.20f;
            break;
        case 7:
            minU = 0.32f;
            minV = 0.00f;
            maxU = 0.47f;
            maxV = 0.20f;
            break;
        case 8:
            minU = 0.60f;
            minV = 0.00f;
            maxU = 0.75f;
            maxV = 0.20f;
            break;
        case 9:
            minU = 0.83f;
            minV = 0.00f;
            maxU = 0.98f;
            maxV = 0.20f;
            break;
        case 10:
            minU = 0.00f;
            minV = 0.75f;
            maxU = 0.75f;
            maxV = 1.00f;
            break;
        case 11:
            minU = 0.00f;
            minV = 0.50f;
            maxU = 0.75f;
            maxV = 0.75f;
            break;
        default:
            break;
    }
    
    return GLKVector4Make(minU, maxU, minV, maxV);
}

@end
