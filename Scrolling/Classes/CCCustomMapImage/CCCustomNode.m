//
//  CCCustomNode.m
//  PrettySimpleMap
//
//  Created by Fazeel Akhter on 10/28/13.//


#import "cocos2d.h"
#import "CCCustomNode.h"



@implementation CCCustomNode

//Return Node object with initilization
+ (id) nodeWithImage: (NSString *) inputImage forRect: (CGRect) imgRect
{
	return [[self alloc] initWithImage:inputImage forRect: imgRect] ;
}


    // do all node intializtion and set values.
- (id) initWithImage: (NSString *) inputImage forRect: (CGRect) imgRect
{
	if ( (self = [super init]) )
	{
		self.imageName = inputImage;
		self.myBounds = imgRect;
		self.anchorPoint = ccp(0,0);
		self.position = imgRect.origin;
	}
	return self;
}

//sprite Bounding Box
- (CGRect) boundingBox
{
	return self.myBounds;
}

// visit only visbile sprite
-(void) visit
{
	if (visible_)
    {
        kmGLPushMatrix();
        [self transform];
        [self.sprite visit];
        kmGLPopMatrix();
    }
}

- (void) onExit
{
	self.sprite = nil;
	self.imageName = nil;
}


// Unload Textures when not needed
- (void) unload
{
    self.sprite = nil;

}

// load Textures when needed and not present on screen
- (void) load
{
	if (!self.sprite)
    {
        if ([NSThread currentThread] == [[CCDirector sharedDirector] runningThread] )
        {
            [self loadedTexture:[[CCTextureCache sharedTextureCache] addImage:self.imageName]];
        }
        else
        {
            [[CCTextureCache sharedTextureCache] addImageAsync:self.imageName
                                                        target: self
                                                      selector: @selector(loadedTexture:)];
        }
    }
}

// Load Texures if sprite is not loaded yet
- (void) loadedTexture: ( CCTexture2D * ) texture_
{
	[texture_ setAntiAliasTexParameters];
	
	self.sprite = [[CCSprite alloc] initWithTexture: texture_];
	self.sprite.anchorPoint = ccp(0,0);
	self.sprite.position = ccp(0,0);
    self.sprite.scaleX = self.myBounds.size.width / [self.sprite contentSize].width; // Fill sprite according to scalex
	self.sprite.scaleY = self.myBounds.size.height / [self.sprite contentSize].height; // Fill sprite according to scaleY
}



@end

