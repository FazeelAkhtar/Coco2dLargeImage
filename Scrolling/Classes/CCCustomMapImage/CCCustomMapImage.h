
//  CCCustomMapImage.h
//  PrettySimpleMap
//
//  Created by Fazeel Akhter on 10/28/13.//



#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface CCCustomMapImage : CCNode



+(id) nodeWithFileName: (NSString *) filename  // initialize Map with Tiles and return it as ccnode
                  zIndex: (int) index;
-(id) initWithFileName: (NSString *) _plistName // Load stuff from plist file , into CCCustomNode
				  zIndex: (int) index;

@property ( readwrite ) CGPoint currentScreenScrollPosition; //to check if screen move or not
@property ( readwrite ) CGRect visibleScreenArea;             // Screen Visible Area
@property ( readwrite ) CGSize singelTileSize;                // Single Tile Size
@property ( readwrite ) BOOL checkIfVisbileScreenChanges;     // if screen is scrolled or not
@property ( readwrite ) BOOL tileLoadingThreadSleeping;       // loading tiles thread status
@property ( retain , readwrite) NSThread *tilesLoadThread;
@property ( retain , readwrite) NSMutableArray * allTiles;    // contain all tiles

@end
