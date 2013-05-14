#import "ParticleSystem.h"

@implementation ParticleSystem

@synthesize blendSrc     = _blendSrc;
@synthesize blendDst     = _blendDst;
@synthesize textureName  = _textureName;
@synthesize textureType  = _textureType;
@synthesize emit         = _emit;
@synthesize emitCounter  = _emitCounter;
@synthesize maxParticles = _maxParticles;
@synthesize emitRange    = _emitRange;
@synthesize rotaRange    = _rotaRange;
@synthesize roveRange    = _roveRange;
@synthesize posxRange    = _posxRange;
@synthesize posyRange    = _posyRange;
@synthesize poszRange    = _poszRange;
@synthesize velxRange    = _velxRange;
@synthesize velyRange    = _velyRange;
@synthesize velzRange    = _velzRange;
@synthesize accxRange    = _accxRange;
@synthesize accyRange    = _accyRange;
@synthesize acczRange    = _acczRange;
@synthesize adexRange    = _adexRange;
@synthesize adeyRange    = _adeyRange;
@synthesize adezRange    = _adezRange;
@synthesize colxRange    = _colxRange;
@synthesize colyRange    = _colyRange;
@synthesize colzRange    = _colzRange;
@synthesize colwRange    = _colwRange;
@synthesize cdexRange    = _cdexRange;
@synthesize cdeyRange    = _cdeyRange;
@synthesize cdezRange    = _cdezRange;
@synthesize cdewRange    = _cdewRange;
@synthesize sizeRange    = _sizeRange;
@synthesize growRange    = _growRange;
@synthesize lifeRange    = _lifeRange;
@synthesize deceRange    = _deceRange;

- (void)dealloc
{
    [_activeParticles release];
    [_objectsToRemove release];
    [_particlePool release];
    [_effect release];
    free(_colors);
    free(_vertexes);
    free(_uvCoordinates);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setDefaultSystem];
        _effect = [[GLKBaseEffect alloc] init];
        _effect.transform.modelviewMatrix  = GLKMatrix4MakeLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
        _effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 2.0/3.0, 2, -1);
    }
    
    return self;
}

- (void)update
{    
	[self buildVertexArrays];
	
	[self emitNewParticles];
    
    [self clearDeadQueue];
}

- (void)setDefaultSystem
{
    self.blendSrc = GL_ONE_MINUS_SRC_ALPHA;
    self.blendDst = GL_DST_ALPHA;
    
    self.textureName = [NSString stringWithString:@"particleStar"];
    self.textureType = [NSString stringWithString:@"png"];
    
    self.emit = YES;
    self.emitCounter = -1;
    self.maxParticles = 100;
    self.emitRange = RangeMake(1.0f, 3.0f);
    
    self.rotaRange = RangeMake(-90, 180);
    self.roveRange = RangeMake(0, 0);
    
    self.posxRange = RangeMake(-0.1f, 0.2f);
    self.posyRange = RangeMake(-0.9f, 0.1f);
    self.poszRange = RangeMake(-0.0f, 0.0f);
    
    self.velxRange = RangeMake(-0.003f, 0.005f);
    self.velyRange = RangeMake( 0.010f, 0.010f);
    self.velzRange = RangeMake(-0.005f, 0.010f);
    
    self.accxRange = RangeMake( 0.000f, 0.000f);
    self.accyRange = RangeMake( 0.000f, 0.000f);
    self.acczRange = RangeMake( 0.000f, 0.000f);
    
    self.adexRange = RangeMake( 0.000f, 0.000f);
    self.adeyRange = RangeMake( 0.000f, 0.000f);
    self.adezRange = RangeMake( 0.000f, 0.000f);
    
    self.colxRange = RangeMake(0.80f, 0.05f);
    self.colyRange = RangeMake(0.30f, 0.05f);
    self.colzRange = RangeMake(0.40f, 0.05f);
    self.colwRange = RangeMake(0.80f, 0.05f);
    
    self.cdexRange = RangeMake(0.0010f, 0.0020f);
    self.cdeyRange = RangeMake(0.0005f, 0.0005f);
    self.cdezRange = RangeMake(0.0005f, 0.0010f);
    self.cdewRange = RangeMake(0.0000f, 0.0000f);
    
    self.sizeRange = RangeMake(   0.02f, 0.02f);
    self.growRange = RangeMake(-0.0002f, 0.0001f);
    
    self.lifeRange = RangeMake( 1.0f, 1.0f);
    self.deceRange = RangeMake(0.05f, 0.05f);
    
}

- (void)awake
{
    if (_activeParticles == nil) {
        _activeParticles = [[NSMutableArray alloc] init];
    }
    
    _particlePool = [[NSMutableArray alloc] initWithCapacity:_maxParticles];
    for (NSInteger i = 0; i < _maxParticles; ++i)
    {
        Particle *particle = [[Particle alloc] init];
        [_particlePool addObject:particle];
        [particle release];
    }
    
    _colors        = (CGFloat *) malloc(4 * 6 * _maxParticles * sizeof(CGFloat));
    _vertexes      = (CGFloat *) malloc(3 * 6 * _maxParticles * sizeof(CGFloat));
	_uvCoordinates = (CGFloat *) malloc(2 * 6 * _maxParticles * sizeof(CGFloat));
    
    [self setTexture];
}

- (void)setTexture
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
                             GLKTextureLoaderOriginBottomLeft, nil];
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:_textureName ofType:_textureType];
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    _effect.texture2d0.name = info.name;
    _effect.texture2d0.enabled = GL_TRUE;
}

- (BOOL)activeParticles
{
    if ([_activeParticles count] > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)buildVertexArrays
{
    _vertexIndex = 0;
    for (Particle *p in _activeParticles)
    {
        [p update];
        
        if ((p.life < 0) || (p.size < 0.003)) {
			[self removeChildParticle:p];
			continue;
		}
        
        // 代码可精简
        // 可直接用矩阵相乘计算
        CGFloat s = sin(p.rotate);
        CGFloat c = sin(p.rotate);
        CGFloat zRotation[2][2] = { c, s, -s, c };
        
        GLKVector2 pSize00 = GLKVector2Make(-p.size, -p.size);
        GLKVector2 pSize01 = GLKVector2Make(-p.size,  p.size);
        GLKVector2 pSize10 = GLKVector2Make( p.size, -p.size);
        GLKVector2 pSize11 = GLKVector2Make( p.size,  p.size);
        
        CGFloat p00x = pSize00.x * zRotation[0][0] + pSize00.y * zRotation[1][0];
        CGFloat p00y = pSize00.x * zRotation[0][1] + pSize00.y * zRotation[1][1];
        CGFloat p01x = pSize01.x * zRotation[0][0] + pSize01.y * zRotation[1][0];
        CGFloat p01y = pSize01.x * zRotation[0][1] + pSize01.y * zRotation[1][1];
        CGFloat p10x = pSize10.x * zRotation[0][0] + pSize10.y * zRotation[1][0];
        CGFloat p10y = pSize10.x * zRotation[0][1] + pSize10.y * zRotation[1][1];
        CGFloat p11x = pSize11.x * zRotation[0][0] + pSize11.y * zRotation[1][0];
        CGFloat p11y = pSize11.x * zRotation[0][1] + pSize11.y * zRotation[1][1];
        
        [self addVertex:p.position.x + p01x
                       :p.position.y + p01y
                       :p.position.z :0 :1 :p.color];
        [self addVertex:p.position.x + p10x
                       :p.position.y + p10y
                       :p.position.z :1 :0 :p.color];
        [self addVertex:p.position.x + p00x
                       :p.position.y + p00y
                       :p.position.z :0 :0 :p.color];
        
        [self addVertex:p.position.x + p01x
                       :p.position.y + p01y
                       :p.position.z :0 :1 :p.color];
        [self addVertex:p.position.x + p11x
                       :p.position.y + p11y
                       :p.position.z :1 :1 :p.color];
        [self addVertex:p.position.x + p10x
                       :p.position.y + p10y
                       :p.position.z :1 :0 :p.color];
    }
    
}

- (void)emitNewParticles
{
    if (!_emit) {
        return;
    }
    if (_emitCounter > 0) {
        --_emitCounter;
    }
    else if (_emitCounter == 0) {
        _emit = NO;
    }
    
    NSInteger newParticles = RandomFloat(_emitRange);
    
    for (NSInteger i = 0; i < newParticles; ++i)
    {
        if ([_particlePool count] == 0) {
            return;
        }
        
        Particle *p = [_particlePool lastObject];
        
        p.rotate         = RandomFloat(_rotaRange);
        p.rotateVelocity = RandomFloat(_roveRange);
        
        p.position     = GLKVector3Make(RandomFloat(_posxRange), RandomFloat(_posyRange), RandomFloat(_poszRange));
        p.velocity     = GLKVector3Make(RandomFloat(_velxRange), RandomFloat(_velyRange), RandomFloat(_velzRange));
        p.acceleration = GLKVector3Make(RandomFloat(_accxRange), RandomFloat(_accyRange), RandomFloat(_acczRange));
        p.deltaAcceler = GLKVector3Make(RandomFloat(_adexRange), RandomFloat(_adeyRange), RandomFloat(_adezRange));
        
        p.color        = GLKVector4Make(RandomFloat(_colxRange), RandomFloat(_colyRange), 
                                        RandomFloat(_colzRange), RandomFloat(_colwRange));
        p.deltaColor   = GLKVector4Make(RandomFloat(_cdexRange), RandomFloat(_cdeyRange), 
                                        RandomFloat(_cdezRange), RandomFloat(_cdewRange));
        
        p.size  = RandomFloat(_sizeRange);
        p.grow  = RandomFloat(_growRange);
        p.life  = RandomFloat(_lifeRange);
        p.decay = RandomFloat(_deceRange);
        
        [_activeParticles addObject:p];
        
        [_particlePool removeLastObject];
    }
}

- (void)removeChildParticle:(Particle*)particle
{
	if (_objectsToRemove == nil) {
        _objectsToRemove = [[NSMutableArray alloc] init];
    }
	[_objectsToRemove addObject:particle];
}

- (void)clearDeadQueue
{
    if ([_objectsToRemove count] > 0) {
		[_activeParticles removeObjectsInArray:_objectsToRemove];
		[_particlePool addObjectsFromArray:_objectsToRemove];
		[_objectsToRemove removeAllObjects];
	}
}

- (void)addVertex:(CGFloat)x :(CGFloat)y :(CGFloat)z :(CGFloat)u :(CGFloat)v :(GLKVector4)c
{
	NSInteger pos = _vertexIndex * 3.0;
	_vertexes[pos]   = x;
	_vertexes[pos+1] = y;
	_vertexes[pos+2] = z;
	
	pos = _vertexIndex * 2.0;
	_uvCoordinates[pos]   = u;
	_uvCoordinates[pos+1] = v;
    
    pos = _vertexIndex * 4;
    _colors[pos]   = c.x;
    _colors[pos+1] = c.y;
    _colors[pos+2] = c.z;
    _colors[pos+3] = c.w;
    
	++_vertexIndex;
}

- (void)draw
{    
    [_effect prepareToDraw];
    
    //glEnable(GL_DEPTH_TEST);
    //glDepthMask(GL_FALSE);
    glEnable(GL_BLEND);
    glBlendFunc(_blendSrc, _blendDst);
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, _colors);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, _vertexes);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, _uvCoordinates);
    
    glDrawArrays(GL_TRIANGLES, 0, _vertexIndex);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    //glDepthMask(GL_TRUE);
    //glDisable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);
    
}

@end
