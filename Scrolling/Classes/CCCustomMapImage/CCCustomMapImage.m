
//  CCCustomMapImage.m
//  PrettySimpleMap
//
//  Created by Fazeel Akhter on 10/28/13.//



#import <Foundation/Foundation.h>
#import "CCCustomMapImage.h"
#import "CCCustomNode.h"


@implementation  CCCustomMapImage

#pragma mark ---- CCCustomNode Init Node and Creation Metion ------

+ (id) nodeWithFileName: (NSString *) filename zIndex: (int) index
{
	return [[[self alloc] initWithFileName:filename
                                	 zIndex: index ] autorelease] ;
}

- (id) initWithFileName: (NSString *) filename zIndex: (int) index
{
	if ( (self = [super init]) )
	{
		self.visibleScreenArea = CGRectZero;
		self.singelTileSize = CGSizeZero;
        NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath: filename];
		[self prepareTilesWithFile:path  zIndex: index ];
	}
	return self;
}

#pragma mark ---- End Creation   ------

/**
 * prepareTilesWithFile
 * loding Tiles and information of tiles form Plist file.
 * create all other sprites and tiles
 * Also create needed Texrues for visbile Sprites.
 **/




- (void) prepareTilesWithFile: (NSString *) plistFile  zIndex: (int) tilesZ
{
    
    @autoreleasepool {
            // load plist with image & tiles info
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: plistFile ];
        if (dict.allKeys.count > 0 )
        {
            NSString *size = [[dict objectForKey:Map_Image_Tile_Source_Key] objectForKey:Map_Image_Size_Key];
            self.contentSize = CGSizeFromString(size);
            
            NSMutableArray * childTiles;
            if([dict objectForKey:Map_Image_Tiles_Key])
                childTiles = [NSMutableArray arrayWithArray:[dict objectForKey:Map_Image_Tiles_Key]] ;
            self.allTiles =[NSMutableArray arrayWithCapacity:childTiles.count];
            
            // set Tile Size
            if ([childTiles count] > 0)
            {
                    self.singelTileSize = CGRectFromString( [[childTiles objectAtIndex:0] valueForKey: Map_Image_Tile_Size_Key] ).size;
                    for ( NSDictionary *tileDict in childTiles )
                    {
                        NSString *spriteName = [ tileDict valueForKey:Map_Image_Tile_Name_Key];

                        if([CCCustomMapImage checkIfImageFileExist:spriteName])
                        {
                            CGRect tileRect = CGRectFromString( [tileDict valueForKey:Map_Image_Tile_Size_Key] );
                            tileRect.origin.y = self.contentSize.height - tileRect.origin.y - tileRect.size.height;         // convert top-left to bottom-left
                            id tile = [CCCustomNode nodeWithImage: spriteName forRect: tileRect];
                            [self addChild: tile z: tilesZ];
                            [self.allTiles addObject: tile ];
                        }
                    }
             }
            else{
                   NSLog(@"Warning : input Tiles is zero");
            }
        }else{
                NSLog(@"Warning : input file is not correct Plese Check");
        }
  }
}


/**
    node life cyle methods over loaded as needed
 **/



- (void) onEnter
{
	[super onEnter];
    [self startTilesUpdatingThread];
}

- (void) onExit
{
        // turn off dynamic thread
	[self stopTilesUpdatingThread];
    self.allTiles = nil;
	[super onExit];
}

-(void) visit
{
	[super visit];
	[self updateScreenLoadingRec];
    // remove unused textures periodically
    static int i = TEXTURE_UNLOAD_PERIOD;
    if (--i <= 0)
    {
        i = TEXTURE_UNLOAD_PERIOD;
        if (self.tileLoadingThreadSleeping)
            [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    }
}



/**
  Start Loading stuff , tiles , create sprites , texures
 **/

- (void) startTilesUpdatingThread
{
	if (!self.tilesLoadThread)
	{
        self.tilesLoadThread = [[[NSThread alloc] initWithTarget: self
                                                        selector: @selector(updateCurrentScreenWithThread:)
                                                          object: nil] autorelease];
        self.tileLoadingThreadSleeping = NO;
        [self.tilesLoadThread start];
    }
}

/**
 stop loading Thread
**/

- (void) stopTilesUpdatingThread
{
	[self.tilesLoadThread cancel];
	self.tilesLoadThread = nil;
}


/**
 update Current Screen Visble Area Rect.To laod only visible Tiles.
 Also check that if we need to unload/Load unsed Texures
**/

- (void) updateScreenLoadingRec
{
	CGRect screenRect = CGRectZero;
	screenRect.size = [[CCDirector sharedDirector] winSize];

        // get Current Screen WorlD Rect.
	screenRect = CGRectApplyAffineTransform(screenRect, [self worldToNodeTransform] );

        // getVisibileArea
	self.visibleScreenArea = CGRectMake(screenRect.origin.x - self.singelTileSize.width,
							 screenRect.origin.y - self.singelTileSize.height,
							 screenRect.size.width + 2.0f * self.singelTileSize.width,
							 screenRect.size.height + 2.0f * self.singelTileSize.height);

}

/**
 Check Current Screen Visble Area Rect.To laod only visible Tiles.
 Also check that if we need to unload/Load unsed Texures
 **/

- (void) updateCurrentScreenWithThread: (NSObject *) notUsed
{
	while( ![[NSThread currentThread] isCancelled] )
	{
        @autoreleasepool
        {
            self.tileLoadingThreadSleeping = NO;
            for (CCCustomNode *tile in self.allTiles)
            { if (  0 == ( CGRectIntersection([tile boundingBox], self.visibleScreenArea).size.width )  )
                    [tile unload];
                else
                    [tile load];
            }
            self.tileLoadingThreadSleeping = YES;
            [NSThread sleepForTimeInterval: 0.03  ];  // check update at 30 frame per second
        }
    }
}


/**
 load / Unload Tiles that are in visible areas and which are not.
 **/

- (void) updateCurrentScreen
{	
	for (CCCustomNode * tile in self.allTiles)
    {
        if (  0 == ( CGRectIntersection([tile boundingBox], self.visibleScreenArea).size.width )  )
			[tile unload];  // not visible in current Area
		else 
			[tile load];   // Visible in Current Area
    }
}



/**
 utill Method to check tiles texture exists.
**/


+(BOOL) checkIfImageFileExist : ( NSString * ) _name{
    
    NSString *resourcesDirectoryPath = [ [NSBundle mainBundle] resourcePath ];
    NSString *filePath = [resourcesDirectoryPath stringByAppendingPathComponent: _name];
    return [[NSFileManager defaultManager] fileExistsAtPath: filePath];
}

/**
  Dealloc Method
 **/


- (void) dealloc
{
	self.allTiles = nil;
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[super dealloc];
}


@end

@interface CCCustomMapImage (Private)

- (void) prepareTilesWithFile: (NSString *) plistFile  zIndex:(int) tilesZ;
- (void) updateScreenLoadingRec;
- (void) updateCurrentScreen;
- (void) startTilesUpdatingThread;
- (void) stopTilesUpdatingThread;

@end

