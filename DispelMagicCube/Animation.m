//
//  Animation.m
//  DispelMagicCube
//
//  Created by rui luo on 13-3-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Animation.h"

@implementation Animation

@synthesize gameScore = _gameScore;

- (void)dealloc
{
    [_particleStar release];
    [_cubes release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _cubes = [[NSMutableArray alloc] init];
        
        for (NSInteger j = 0; j < 3; ++j)
        {
            for (NSInteger k = 0; k < 3; ++k)
            {
                for (NSInteger i = 0; i < 3; ++i)
                {
                    _rotMatrix[i][j][k] = GLKMatrix4Identity;
                    
                    _cube[i][j][k] = [[[Cube alloc] init] autorelease];
                    
                    _cube[i][j][k].position = GLKVector3Make(-0.25+0.25*i, -0.25+0.25*j, -0.25+0.25*k);
                    _cube[i][j][k].scale    = GLKVector3Make(0.22, 0.22, 0.22);
                    
                    _cube[i][j][k].color1 = [self keepAttr:[self chooseColor] :i :j :k :1]; // Front
                    _cube[i][j][k].color2 = [self keepAttr:[self chooseColor] :i :j :k :2]; // Right
                    _cube[i][j][k].color3 = [self keepAttr:[self chooseColor] :i :j :k :3]; // Back
                    _cube[i][j][k].color4 = [self keepAttr:[self chooseColor] :i :j :k :4]; // Left
                    _cube[i][j][k].color5 = [self keepAttr:[self chooseColor] :i :j :k :5]; // Top
                    _cube[i][j][k].color6 = [self keepAttr:[self chooseColor] :i :j :k :6]; // Bottom
                    
                    [_cubes addObject:_cube[i][j][k]];
                }
            }
        }
        
        _particleStar = [[ParticleStar alloc] init];

    }
    
    return self;
}

// alpha通道标示
- (GLKVector4)keepAttr:(GLKVector4)v4 :(NSInteger)x :(NSInteger)y :(NSInteger)z :(NSInteger)f
{
    v4.w = ( (CGFloat)(x * 54 + y * 18 + z * 6 + f - 1) ) / 255.0f;
    
    return v4;
}

// 方块颜色
- (GLKVector4)chooseColor
{
    GLKVector4 color[6];
    color[0] = GLKVector4Make(220.0f/255.0f, 159.0f/255.0f, 180.0f/255.0f, 255.0f/255.0f);
    color[1] = GLKVector4Make(225.0f/255.0f, 177.0f/255.0f,  27.0f/255.0f, 255.0f/255.0f);
    color[2] = GLKVector4Make(152.0f/255.0f, 129.0f/255.0f, 195.0f/255.0f, 255.0f/255.0f);
    color[3] = GLKVector4Make(190.0f/255.0f, 194.0f/255.0f,  63.0f/255.0f, 255.0f/255.0f);
    color[4] = GLKVector4Make(218.0f/255.0f,  77.0f/255.0f, 109.0f/255.0f, 255.0f/255.0f);
    color[5] = GLKVector4Make(237.0f/255.0f, 120.0f/255.0f,  74.0f/255.0f, 255.0f/255.0f);
    
    return color[arc4random()%6];
}

- (GLKMatrix4)Matrix: (NSInteger)i: (NSInteger)j: (NSInteger)k
{
    return _rotMatrix[i][j][k];
}

- (void)draw
{
    [_cubes makeObjectsPerformSelector:@selector(draw)];
    
    if (_emitterTime > 0) {
        [_particleStar draw];
    }
}

- (void)update
{
    for (NSInteger j = 0; j < 3; ++j) 
    {
        for (NSInteger k = 0; k < 3; ++k) 
        {
            for (NSInteger i = 0; i < 3; ++i) 
            {
                _cube[i][j][k].rotMatrix = _rotMatrix[i][j][k];
            }
        }
    }
    
    if (_emitterTime > 0) {
        [_particleStar update];
    }
}

- (void)isDispel
{
    if (_alpha == 0) {
    
    GLKVector4 color[3][12];
    BOOL isSame = NO;
    BOOL isDispel = NO;
    
    NSInteger dispelChar[3][3][3][6] = {0};
    
        
    // 绕x轴，检测是否有三个相同的方块
    GLKVector3 xIndex[12];
    xIndex[0]  = GLKVector3Make(0, 2, 1);
    xIndex[1]  = GLKVector3Make(1, 2, 1);
    xIndex[2]  = GLKVector3Make(2, 2, 1);
    xIndex[3]  = GLKVector3Make(2, 2, 5);
    xIndex[4]  = GLKVector3Make(2, 1, 5);
    xIndex[5]  = GLKVector3Make(2, 0, 5);
    xIndex[6]  = GLKVector3Make(2, 0, 3);
    xIndex[7]  = GLKVector3Make(1, 0, 3);
    xIndex[8]  = GLKVector3Make(0, 0, 3);
    xIndex[9]  = GLKVector3Make(0, 0, 6);
    xIndex[10] = GLKVector3Make(0, 1, 6);
    xIndex[11] = GLKVector3Make(0, 2, 6);
    
    for (NSInteger i = 0; i < 3;  ++i) 
    {
        for (NSInteger n = 0; n < 12; ++n)
        {
            color[i][n] = [self colorAttr:i :xIndex[n].x :xIndex[n].y :xIndex[n].z];
        }
    }
    
    for (NSInteger i = 0; i < 3;  ++i) 
    {
        for (NSInteger n = 0; n < 12; ++n)
        {
            isSame = [self isSameColor:color[i][n] :color[i][(n+1)%12] :color[i][(n+2)%12]];
            if (isSame) {
                NSInteger x1 = i;
                NSInteger y1 = xIndex[n].x;
                NSInteger z1 = xIndex[n].y;
                NSInteger f1 = xIndex[n].z - 1;
                ++dispelChar[x1][y1][z1][f1];
                
                NSInteger x2 = i;
                NSInteger y2 = xIndex[(n+1)%12].x;
                NSInteger z2 = xIndex[(n+1)%12].y;
                NSInteger f2 = xIndex[(n+1)%12].z - 1;
                ++dispelChar[x2][y2][z2][f2];
                
                NSInteger x3 = i;
                NSInteger y3 = xIndex[(n+2)%12].x;
                NSInteger z3 = xIndex[(n+2)%12].y;
                NSInteger f3 = xIndex[(n+2)%12].z - 1;
                ++dispelChar[x3][y3][z3][f3];
                
                isDispel = YES;
            }
        }
    }
    
    // 绕y轴，检测是否有三个相同的方块
    GLKVector3 yIndex[12];
    yIndex[0]  = GLKVector3Make(0, 2, 1);
    yIndex[1]  = GLKVector3Make(1, 2, 1);
    yIndex[2]  = GLKVector3Make(2, 2, 1);
    yIndex[3]  = GLKVector3Make(2, 2, 2);
    yIndex[4]  = GLKVector3Make(2, 1, 2);
    yIndex[5]  = GLKVector3Make(2, 0, 2);
    yIndex[6]  = GLKVector3Make(2, 0, 3);
    yIndex[7]  = GLKVector3Make(1, 0, 3);
    yIndex[8]  = GLKVector3Make(0, 0, 3);
    yIndex[9]  = GLKVector3Make(0, 0, 4);
    yIndex[10] = GLKVector3Make(0, 1, 4);
    yIndex[11] = GLKVector3Make(0, 2, 4);
    
    for (NSInteger j = 0; j < 3;  ++j) 
    {
        for (NSInteger n = 0; n < 12; ++n)
        {
            color[j][n] = [self colorAttr:yIndex[n].x :j :yIndex[n].y :yIndex[n].z];
        }
    }
    
    for (NSInteger j = 0; j < 3;  ++j) 
    {
        for (NSInteger n = 0; n < 12; ++n)
        {
            isSame = [self isSameColor:color[j][n] :color[j][(n+1)%12] :color[j][(n+2)%12]];
            if (isSame) {
                NSInteger x1 = yIndex[n].x;
                NSInteger y1 = j;
                NSInteger z1 = yIndex[n].y;
                NSInteger f1 = yIndex[n].z - 1;
                ++dispelChar[x1][y1][z1][f1];
                
                NSInteger x2 = yIndex[(n+1)%12].x;
                NSInteger y2 = j;
                NSInteger z2 = yIndex[(n+1)%12].y;
                NSInteger f2 = yIndex[(n+1)%12].z - 1;
                ++dispelChar[x2][y2][z2][f2];
                
                NSInteger x3 = yIndex[(n+2)%12].x;
                NSInteger y3 = j;
                NSInteger z3 = yIndex[(n+2)%12].y;
                NSInteger f3 = yIndex[(n+2)%12].z - 1;
                ++dispelChar[x3][y3][z3][f3];
                
                isDispel = YES;
            }
        }
    }
    
    // 绕z轴，检测是否有三个相同的方块
    GLKVector3 zIndex[12];
    zIndex[0]  = GLKVector3Make(0, 2, 5);
    zIndex[1]  = GLKVector3Make(1, 2, 5);
    zIndex[2]  = GLKVector3Make(2, 2, 5);
    zIndex[3]  = GLKVector3Make(2, 2, 2);
    zIndex[4]  = GLKVector3Make(2, 1, 2);
    zIndex[5]  = GLKVector3Make(2, 0, 2);
    zIndex[6]  = GLKVector3Make(2, 0, 6);
    zIndex[7]  = GLKVector3Make(1, 0, 6);
    zIndex[8]  = GLKVector3Make(0, 0, 6);
    zIndex[9]  = GLKVector3Make(0, 0, 4);
    zIndex[10] = GLKVector3Make(0, 1, 4);
    zIndex[11] = GLKVector3Make(0, 2, 4);
    
    for (NSInteger k = 0; k < 3;  ++k) 
    {
        for (NSInteger n = 0; n < 12; ++n)
        {
            color[k][n] = [self colorAttr:zIndex[n].x :zIndex[n].y :k :zIndex[n].z];
        }
    }
    
    for (NSInteger k = 0; k < 3;  ++k) 
    {
        for (NSInteger n = 0; n < 12; ++n)
        {
            isSame = [self isSameColor:color[k][n] :color[k][(n+1)%12] :color[k][(n+2)%12]];
            if (isSame) {
                NSInteger x1 = zIndex[n].x;
                NSInteger y1 = zIndex[n].y;
                NSInteger z1 = k;
                NSInteger f1 = zIndex[n].z - 1;
                ++dispelChar[x1][y1][z1][f1];
                
                NSInteger x2 = zIndex[(n+1)%12].x;
                NSInteger y2 = zIndex[(n+1)%12].y;
                NSInteger z2 = k;
                NSInteger f2 = zIndex[(n+1)%12].z - 1;
                ++dispelChar[x2][y2][z2][f2];
                
                NSInteger x3 = zIndex[(n+2)%12].x;
                NSInteger y3 = zIndex[(n+2)%12].y;
                NSInteger z3 = k;
                NSInteger f3 = zIndex[(n+2)%12].z - 1;
                ++dispelChar[x3][y3][z3][f3];
                
                isDispel = YES;
            }
        }
    }
    
    // 消除方块数组初始化
    for (NSInteger i = 0; i < 162; ++i)
    {
        _dispelFace[i] = 0;
    }
    
    if (isDispel) 
    {
        NSInteger  emitterCounter = 0;
        
        for (NSInteger i = 0; i < 3; ++i)
        {
            for (NSInteger j = 0; j < 3; ++j)
            {
                for (NSInteger k = 0; k < 3; ++k)
                {
                    NSInteger dispelFaceSum = 0;
                    GLKVector3 cubePosition;
                    GLKVector4 cubeColor;
                    for (NSInteger l = 0; l < 6; ++l)
                    {
                        dispelFaceSum += dispelChar[i][j][k][l];
                        if (dispelChar[i][j][k][l] > 0)
                        {
                            // 标记消除
                            _dispelFace[54*i+18*j+6*k+l] = 1;
                            cubePosition = _cube[i][j][k].position;
                            cubePosition = GLKMatrix4MultiplyVector3(_rotMatrix[i][j][k], cubePosition);
                            switch (l) {
                                case 0:
                                    cubeColor = _cube[i][j][k].color1;
                                    break;
                                case 1:
                                    cubeColor = _cube[i][j][k].color2;
                                    break;
                                case 2:
                                    cubeColor = _cube[i][j][k].color3;
                                    break;
                                case 3:
                                    cubeColor = _cube[i][j][k].color4;
                                    break;
                                case 4:
                                    cubeColor = _cube[i][j][k].color5;
                                    break;
                                case 5:
                                    cubeColor = _cube[i][j][k].color6;
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                    
                    // 设置粒子发射器
                    if (dispelFaceSum > 0) {
                        [_particleStar setEmitterPosition:cubePosition :emitterCounter];
                        [_particleStar setEmitterColor:cubeColor :emitterCounter];
                        ++emitterCounter;
                    }
                }
            }
        }
        
        // 更新游戏分数
        for (NSInteger i = 0; i < 162; ++i)
        {
            if (_dispelFace[i] > 0)
            {
                _gameScore += 100;
            }
        }
        
        // 粒子发射器个数
        _particleStar.emitterNumber = emitterCounter;
        
        [_particleStar awake];
        
        // 动画播放时锁定
        if (_emitterTime == 0)
        {
            _emitterTime = 90;
            CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self 
                                                                     selector:@selector(dispelAnimation:)];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }
    
    
    // 方块颜色渐变
    for (NSInteger i = 0; i < 3; ++i)
    {
        for (NSInteger j = 0; j < 3; ++j)
        {
            for (NSInteger k = 0; k < 3; ++k)
            {
                for (NSInteger l = 0; l < 6; ++l)
                {
                    if (dispelChar[i][j][k][l] > 0)
                    {
                        NSLog(@"dispel is %d, %d, %d, %d. \n", i, j, k, l+1);
                        
                        switch (l) {
                            case 0:
                                _srcColor[i*54+j*18+6*k+l] = _cube[i][j][k].color1;
                                _dstColor[i*54+j*18+6*k+l] = [self chooseColor];
                                break;
                            case 1:
                                _srcColor[i*54+j*18+6*k+l] = _cube[i][j][k].color1;
                                _dstColor[i*54+j*18+6*k+l] = [self chooseColor];
                                break;
                            case 2:
                                _srcColor[i*54+j*18+6*k+l] = _cube[i][j][k].color1;
                                _dstColor[i*54+j*18+6*k+l] = [self chooseColor];
                                break;
                            case 3:
                                _srcColor[i*54+j*18+6*k+l] = _cube[i][j][k].color1;
                                _dstColor[i*54+j*18+6*k+l] = [self chooseColor];
                                break;
                            case 4:
                                _srcColor[i*54+j*18+6*k+l] = _cube[i][j][k].color1;
                                _dstColor[i*54+j*18+6*k+l] = [self chooseColor];
                                break;
                            case 5:
                                _srcColor[i*54+j*18+6*k+l] = _cube[i][j][k].color1;
                                _dstColor[i*54+j*18+6*k+l] = [self chooseColor];
                                break;
                                
                            default:
                                break;
                        }
                    }
                }
            }
        }
    }
    
     
    if (isDispel) {
        
        //if (_alpha == 0)
        //{
            _alpha = 100;
            CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self 
                                                                     selector:@selector(changeColorAnimation:)];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        //}
    }
    
    }
}

// 粒子发射器时间
- (void)dispelAnimation: (CADisplayLink *)displayLink
{
    --_emitterTime;
    if (_emitterTime <= 0) {
        _emitterTime = 0;
        [displayLink invalidate];
        displayLink = nil;
    }
}

// 混合颜色
- (GLKVector4)blendColor: (GLKVector4)src: (GLKVector4)dst: (CGFloat)alpha
{
    GLKVector4 blend = GLKVector4Make(0, 0, 0, 0);
    CGFloat a = ((CGFloat)alpha) * 0.01f;
    
    blend.x = src.x * a + dst.x * (1-a);
    blend.y = src.y * a + dst.y * (1-a);
    blend.z = src.z * a + dst.z * (1-a);
    
    return blend;
}

// 渐变动画
- (void)changeColorAnimation: (CADisplayLink *)displayLink
{
    --_alpha;
    
    GLKVector4 blendColor;
    
    for (NSInteger i = 0; i < 162; ++i)
    {
        if (_dispelFace[i] > 0)
        {
            blendColor = [self blendColor:_srcColor[i] :_dstColor[i] :_alpha];
            
            int x =  i / 54;
            int y = (i % 54) / 18;
            int z = (i % 18) / 6;
            int f =  i % 6;
            
            switch (f) {
                case 0:
                    _cube[x][y][z].color1 = [self keepAttr:blendColor :x :y :z :f+1];
                    break;
                case 1:
                    _cube[x][y][z].color2 = [self keepAttr:blendColor :x :y :z :f+1];
                    break;
                case 2:
                    _cube[x][y][z].color3 = [self keepAttr:blendColor :x :y :z :f+1];
                    break;
                case 3:
                    _cube[x][y][z].color4 = [self keepAttr:blendColor :x :y :z :f+1];
                    break;
                case 4:
                    _cube[x][y][z].color5 = [self keepAttr:blendColor :x :y :z :f+1];
                    break;
                case 5:
                    _cube[x][y][z].color6 = [self keepAttr:blendColor :x :y :z :f+1];
                    break;
                default:
                    break;
            }
        }
    }
    
    
    if (_alpha <= 0)
    {
        _alpha = 0;
        [displayLink invalidate];
        displayLink = nil;
        
        [self isDispel];
    }

}

// 判断连续三个方块颜色是否相同
// 可优化，先判断两个方块颜色是否相同，再判断第三个
- (BOOL)isSameColor: (GLKVector4)c1: (GLKVector4)c2: (GLKVector4)c3 
{
    NSInteger c1r = (NSInteger)(c1.x * 255) / 10 * 10;
    NSInteger c1g = (NSInteger)(c1.y * 255) / 10 * 10;
    NSInteger c1b = (NSInteger)(c1.z * 255) / 10 * 10;
    
    NSInteger c2r = (NSInteger)(c2.x * 255) / 10 * 10;
    NSInteger c2g = (NSInteger)(c2.y * 255) / 10 * 10;
    NSInteger c2b = (NSInteger)(c2.z * 255) / 10 * 10;
    
    NSInteger c3r = (NSInteger)(c3.x * 255) / 10 * 10;
    NSInteger c3g = (NSInteger)(c3.y * 255) / 10 * 10;
    NSInteger c3b = (NSInteger)(c3.z * 255) / 10 * 10;
    
    if (c1r == c2r && c1g == c2g && c1b == c2b &&
        c3r == c2r && c3g == c2g && c3b == c2b) 
    {
        return YES;
    }
    else 
    {
        return NO;
    }
}

// 返回魔方面对应的颜色
- (GLKVector4)colorAttr: (NSInteger)i: (NSInteger)j: (NSInteger)k: (NSInteger)l
{
    GLKVector4 color;
    switch (l) {
        case 1:
            color = _cube[i][j][k].color1;
            break;
        case 2:
            color = _cube[i][j][k].color2;
            break;
        case 3:
            color = _cube[i][j][k].color3;
            break;
        case 4:
            color = _cube[i][j][k].color4;
            break;
        case 5:
            color = _cube[i][j][k].color5;
            break;
        case 6:
            color = _cube[i][j][k].color6;
            break;
        default:
            break;
    }
    return color;
}

// 旋转整个魔方
- (void)RotateCube: (CGFloat)rotX: (CGFloat)rotY
{
    for (NSInteger j = 0; j < 3; ++j)
    {
        for (NSInteger k = 0; k < 3; ++k)
        {
            for (NSInteger i = 0; i < 3; ++i)
            {
                bool isInvertible;
                GLKVector3 xAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(_rotMatrix[i][j][k], &isInvertible),
                                                             GLKVector3Make(1, 0, 0));
                GLKVector3 yAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(_rotMatrix[i][j][k], &isInvertible),
                                                             GLKVector3Make(0, 1, 0));
                
                _rotMatrix[i][j][k] = GLKMatrix4Rotate(_rotMatrix[i][j][k], rotX, xAxis.x, xAxis.y, xAxis.z);
                _rotMatrix[i][j][k] = GLKMatrix4Rotate(_rotMatrix[i][j][k], rotY, yAxis.x, yAxis.y, yAxis.z);
            }
        }
    }
}

// 旋转魔方的一个面
- (void)RotateFace: (NSInteger)axi: (NSInteger)val: (NSInteger)dir
{
    // 旋转时锁定魔方
    if (_currentAngle == 0)
    {
        _axis      = axi;
        _value     = val;
        _direction = dir;
        
        _currentAngle = 90;
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self 
                                                                 selector:@selector(updateAnimation:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

// 魔方面旋转动画
- (void)updateAnimation:(CADisplayLink*) displayLink
{
    CGFloat rot = -1 * GLKMathDegreesToRadians(_direction*6);
    
    if (_axis == 0) 
    {
        for (NSInteger j = 0; j < 3; ++j) 
        {
            for (NSInteger k = 0; k < 3; ++k) 
            {
                _rotMatrix[_value][j][k] = GLKMatrix4Rotate(_rotMatrix[_value][j][k], rot, 1, 0, 0);
            }
        }
    }
    else if (_axis == 1)
    {
        for (NSInteger k = 0; k < 3; ++k)
        {
            for (NSInteger i = 0; i < 3; ++i)
            {
                _rotMatrix[i][_value][k] = GLKMatrix4Rotate(_rotMatrix[i][_value][k], rot, 0, 1, 0);
            }
        }
    }
    else if (_axis == 2)
    {
        for (NSInteger j = 0; j < 3; ++j)
        {
            for (NSInteger i = 0; i < 3; ++i)
            {
                _rotMatrix[i][j][_value] = GLKMatrix4Rotate(_rotMatrix[i][j][_value], rot, 0, 0, 1);
            }
        }
    }
    
    _currentAngle -= 6;
    
    if (_currentAngle <= 0) {
        [displayLink invalidate];
        displayLink = nil;
        
        [self reversalFace];
        
        [self swapColor];
    }
}

// 反转面
- (void)reversalFace
{
    CGFloat rot = -1 * GLKMathDegreesToRadians(-_direction*90);
    if (_axis == 0) 
    {
        for (NSInteger j = 0; j < 3; ++j) 
        {
            for (NSInteger k = 0; k < 3; ++k) 
            {
                _rotMatrix[_value][j][k] = GLKMatrix4Rotate(_rotMatrix[_value][j][k], rot, 1, 0, 0);
            }
        }
    }
    else if (_axis == 1)
    {
        for (NSInteger k = 0; k < 3; ++k)
        {
            for (NSInteger i = 0; i < 3; ++i)
            {
                _rotMatrix[i][_value][k] = GLKMatrix4Rotate(_rotMatrix[i][_value][k], rot, 0, 1, 0);
            }
        }
    }
    else if (_axis == 2)
    {
        for (NSInteger j = 0; j < 3; ++j)
        {
            for (NSInteger i = 0; i < 3; ++i)
            {
                _rotMatrix[i][j][_value] = GLKMatrix4Rotate(_rotMatrix[i][j][_value], rot, 0, 0, 1);
            }
        }
    }
}

// 交换方块颜色
- (void)swapColor
{
    GLKVector4 attribute1[3][3][3];
    GLKVector4 attribute2[3][3][3];
    GLKVector4 attribute3[3][3][3];
    GLKVector4 attribute4[3][3][3];
    GLKVector4 attribute5[3][3][3];
    GLKVector4 attribute6[3][3][3];
    
    for (NSInteger j = 0; j < 3; ++j)
    {
        for (NSInteger k = 0; k < 3; ++k)
        {
            for (NSInteger i = 0; i < 3; ++i)
            {
                attribute1[i][j][k] = _cube[i][j][k].color1;
                attribute2[i][j][k] = _cube[i][j][k].color2;
                attribute3[i][j][k] = _cube[i][j][k].color3;
                attribute4[i][j][k] = _cube[i][j][k].color4;
                attribute5[i][j][k] = _cube[i][j][k].color5;
                attribute6[i][j][k] = _cube[i][j][k].color6;
            }
        }
    }
    
    // x轴固定
    if (_axis == 0)
    {
        // 绕x轴顺时针旋转
        if (_direction < 0)
        {
            for (NSInteger j = 0; j < 3; ++j)
            {
                for (NSInteger k = 0; k < 3; ++k)
                {
                    _cube[_value][j][k].color1 = [self keepAttr:attribute5[_value][k][2-j] :_value :j :k :1];
                    _cube[_value][j][k].color2 = [self keepAttr:attribute2[_value][k][2-j] :_value :j :k :2];
                    _cube[_value][j][k].color3 = [self keepAttr:attribute6[_value][k][2-j] :_value :j :k :3];
                    _cube[_value][j][k].color4 = [self keepAttr:attribute4[_value][k][2-j] :_value :j :k :4];
                    _cube[_value][j][k].color5 = [self keepAttr:attribute3[_value][k][2-j] :_value :j :k :5];
                    _cube[_value][j][k].color6 = [self keepAttr:attribute1[_value][k][2-j] :_value :j :k :6];
                }
            }
        }
        // 绕x轴逆时针旋转
        else 
        {
            for (NSInteger j = 0; j < 3; ++j)
            {
                for (NSInteger k = 0; k < 3; ++k)
                {
                    _cube[_value][j][k].color1 = [self keepAttr:attribute6[_value][2-k][j] :_value :j :k :1];
                    _cube[_value][j][k].color2 = [self keepAttr:attribute2[_value][2-k][j] :_value :j :k :2];
                    _cube[_value][j][k].color3 = [self keepAttr:attribute5[_value][2-k][j] :_value :j :k :3];
                    _cube[_value][j][k].color4 = [self keepAttr:attribute4[_value][2-k][j] :_value :j :k :4];
                    _cube[_value][j][k].color5 = [self keepAttr:attribute1[_value][2-k][j] :_value :j :k :5];
                    _cube[_value][j][k].color6 = [self keepAttr:attribute3[_value][2-k][j] :_value :j :k :6];
                }
            }
        }
    }
    
    // y轴固定
    if (_axis == 1)
    {
        // 绕y轴顺时针旋转
        if (_direction < 0)
        {
            for (NSInteger k = 0; k < 3; ++k)
            {
                for (NSInteger i = 0; i < 3; ++i)
                {
                    _cube[i][_value][k].color1 = [self keepAttr:attribute4[2-k][_value][i] :i :_value :k :1];
                    _cube[i][_value][k].color2 = [self keepAttr:attribute1[2-k][_value][i] :i :_value :k :2];
                    _cube[i][_value][k].color3 = [self keepAttr:attribute2[2-k][_value][i] :i :_value :k :3];
                    _cube[i][_value][k].color4 = [self keepAttr:attribute3[2-k][_value][i] :i :_value :k :4];
                    _cube[i][_value][k].color5 = [self keepAttr:attribute5[2-k][_value][i] :i :_value :k :5];
                    _cube[i][_value][k].color6 = [self keepAttr:attribute6[2-k][_value][i] :i :_value :k :6];
                }
            }
        }
        // 绕y轴逆时针旋转 
        else 
        {
            for (NSInteger k = 0; k < 3; ++k)
            {
                for (NSInteger i = 0; i < 3; ++i)
                {
                    _cube[i][_value][k].color1 = [self keepAttr:attribute2[k][_value][2-i] :i :_value :k :1];
                    _cube[i][_value][k].color2 = [self keepAttr:attribute3[k][_value][2-i] :i :_value :k :2];
                    _cube[i][_value][k].color3 = [self keepAttr:attribute4[k][_value][2-i] :i :_value :k :3];
                    _cube[i][_value][k].color4 = [self keepAttr:attribute1[k][_value][2-i] :i :_value :k :4];
                    _cube[i][_value][k].color5 = [self keepAttr:attribute5[k][_value][2-i] :i :_value :k :5];
                    _cube[i][_value][k].color6 = [self keepAttr:attribute6[k][_value][2-i] :i :_value :k :6];
                }
            }
        }
    }
    
    // z轴固定
    if (_axis == 2)
    {
        // 绕z轴顺时针旋转
        if (_direction < 0)
        {
            for (NSInteger j = 0; j < 3; ++j)
            {
                for (NSInteger i = 0; i < 3; ++i)
                {
                    _cube[i][j][_value].color1 = [self keepAttr:attribute1[j][2-i][_value] :i :j :_value: 1];
                    _cube[i][j][_value].color2 = [self keepAttr:attribute6[j][2-i][_value] :i :j :_value: 2];
                    _cube[i][j][_value].color3 = [self keepAttr:attribute3[j][2-i][_value] :i :j :_value: 3];
                    _cube[i][j][_value].color4 = [self keepAttr:attribute5[j][2-i][_value] :i :j :_value: 4];
                    _cube[i][j][_value].color5 = [self keepAttr:attribute2[j][2-i][_value] :i :j :_value: 5];
                    _cube[i][j][_value].color6 = [self keepAttr:attribute4[j][2-i][_value] :i :j :_value: 6];
                    
                }
            }
        }
        // 绕z轴逆时针旋转
        else 
        {
            for (NSInteger j = 0; j < 3; ++j)
            {
                for (NSInteger i = 0; i < 3; ++i)
                {
                    _cube[i][j][_value].color1 = [self keepAttr:attribute1[2-j][i][_value] :i :j :_value: 1];
                    _cube[i][j][_value].color2 = [self keepAttr:attribute5[2-j][i][_value] :i :j :_value: 2];
                    _cube[i][j][_value].color3 = [self keepAttr:attribute3[2-j][i][_value] :i :j :_value: 3];
                    _cube[i][j][_value].color4 = [self keepAttr:attribute6[2-j][i][_value] :i :j :_value: 4];
                    _cube[i][j][_value].color5 = [self keepAttr:attribute4[2-j][i][_value] :i :j :_value: 5];
                    _cube[i][j][_value].color6 = [self keepAttr:attribute2[2-j][i][_value] :i :j :_value: 6];
                }
            }
        }
    }
    
    [self isDispel];
}

@end
