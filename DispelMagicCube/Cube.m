//
//  Cube.m
//  DispelMagicCube
//
//  Created by rui luo on 13-2-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Cube.h"

static BOOL initialized = NO;
static GLKBaseEffect *effect;
static GLKVector3 vertices[8];
static GLKVector4 colors[6];
static GLKVector2 texture[4];
static GLKVector3 cNormal[6];
static GLKVector3 triangleVertices[36];
static GLKVector4 triangleColors[36];
static GLKVector2 triangleTexture[36];
static GLKVector3 triangleCNormal[36];

@implementation Cube

@synthesize rotMatrix = _rotMatrix;
@synthesize position  = _position;
@synthesize rotation  = _rotation;
@synthesize scale     = _scale;
@synthesize color1    = _color1;
@synthesize color2    = _color2;
@synthesize color3    = _color3;
@synthesize color4    = _color4;
@synthesize color5    = _color5;
@synthesize color6    = _color6;

- (void)dealloc
{
    [effect release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _position = GLKVector3Make(0,0,0);
        _rotation = GLKVector3Make(0,0,0);
        _scale    = GLKVector3Make(1,1,1);
    }
    
    return self;
}

+ (void)initialize 
{
    if (!initialized) 
    {
        vertices[0] = GLKVector3Make(-0.5, -0.5,  0.5); // Left  bottom front
        vertices[1] = GLKVector3Make( 0.5, -0.5,  0.5); // Right bottom front
        vertices[2] = GLKVector3Make( 0.5,  0.5,  0.5); // Right top    front
        vertices[3] = GLKVector3Make(-0.5,  0.5,  0.5); // Left  top    front
        vertices[4] = GLKVector3Make(-0.5, -0.5, -0.5); // Left  bottom back
        vertices[5] = GLKVector3Make( 0.5, -0.5, -0.5); // Right bottom back
        vertices[6] = GLKVector3Make( 0.5,  0.5, -0.5); // Right top    back
        vertices[7] = GLKVector3Make(-0.5,  0.5, -0.5); // Left  top    back
        
        texture[0] = GLKVector2Make(1, 0);
        texture[1] = GLKVector2Make(1, 1);
        texture[2] = GLKVector2Make(0, 1);
        texture[3] = GLKVector2Make(0, 0);
        
        cNormal[0] = GLKVector3Make( 0,  0,  1); // Front
        cNormal[1] = GLKVector3Make( 1,  0,  0); // Right
        cNormal[2] = GLKVector3Make( 0,  0, -1); // Back
        cNormal[3] = GLKVector3Make(-1,  0,  0); // Left
        cNormal[4] = GLKVector3Make( 0,  1,  0); // Top
        cNormal[5] = GLKVector3Make( 0, -1,  0); // Bottom
        
        NSInteger vertexIndices[36] = {
            // Front
            0, 1, 2,
            0, 2, 3,
            // Right
            1, 5, 6,
            1, 6, 2,
            // Back
            5, 4, 7,
            5, 7, 6,
            // Left
            4, 0, 3,
            4, 3, 7,
            // Top
            3, 2, 6,
            3, 6, 7,
            // Bottom
            4, 5, 1,
            4, 1, 0,
        };
        
        NSInteger textureIndices[36] = {
            // Front
            0, 1, 2,
            0, 2, 3,
            // Right
            0, 1, 2,
            0, 2, 3,
            // Back
            0, 1, 2,
            0, 2, 3,
            // Left
            0, 1, 2,
            0, 2, 3,
            // Top
            0, 1, 2,
            0, 2, 3,
            // Bottom
            0, 1, 2,
            0, 2, 3,
        };
        
        NSInteger cNormalIndices[36] = {
            // Front
            0, 0, 0,
            0, 0, 0,
            // Right
            1, 1, 1,
            1, 1, 1,
            // Back
            2, 2, 2,
            2, 2, 2,
            // Left
            3, 3, 3,
            3, 3, 3,
            // Top
            4, 4, 4,
            4, 4, 4,
            // Bottom
            5, 5, 5,
            5, 5, 5,
        };
        
        for (NSInteger i = 0; i < 36; i++) {
            triangleVertices[i] = vertices[vertexIndices[i]];
            triangleTexture[i] = texture[textureIndices[i]];
            triangleCNormal[i] = cNormal[cNormalIndices[i]];
        }
        
        effect = [[GLKBaseEffect alloc] init];
        
        initialized = YES;
        
        // 纹理
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], 
                                 GLKTextureLoaderOriginBottomLeft, nil];
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"texture3" ofType:@"png"];
        GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if (info == nil) {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
        }
        effect.texture2d0.name = info.name;
        effect.texture2d0.enabled = GL_TRUE;
        
        // 光照
        effect.light0.enabled = GL_TRUE;
        effect.colorMaterialEnabled = YES;
        effect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
        effect.light0.position = GLKVector4Make(1.0f, 1.0f, 0.0f, 1.0f);
    }
}

- (void)draw
{    
    colors[0] = _color1; // Front
    colors[1] = _color2; // Right
    colors[2] = _color3; // Back
    colors[3] = _color4; // Left
    colors[4] = _color5; // Top
    colors[5] = _color6; // Bottom
    
    for (NSInteger i = 0; i < 36; i++) {
        triangleColors[i] = colors[i/6];
    }
    
    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(_rotation.x);
    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(_rotation.y);
    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(_rotation.z);
    GLKMatrix4 scaleMatrix     = GLKMatrix4MakeScale(_scale.x, _scale.y, _scale.z);
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(_position.x, _position.y, _position.z);
    
    GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translateMatrix,GLKMatrix4Multiply(scaleMatrix,GLKMatrix4Multiply(zRotationMatrix, GLKMatrix4Multiply(yRotationMatrix, xRotationMatrix))));
    
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
    viewMatrix = GLKMatrix4Multiply(viewMatrix, _rotMatrix);
    effect.transform.modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    
    effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 2.0/3.0, 2, -1);
    
    [effect prepareToDraw];
    
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    // 顶点
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, triangleVertices);
    
    // 颜色
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_TRUE, 0, triangleColors);
    
    // 纹理
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, triangleTexture);
    
    // 光照
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, triangleCNormal);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    glDisableVertexAttribArray(GLKVertexAttribNormal);
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
}

@end