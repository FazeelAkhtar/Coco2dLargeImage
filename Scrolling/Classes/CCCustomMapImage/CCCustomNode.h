
//
//  CCCustomNode.h
//  PrettySimpleMap
//
//  Created by Fazeel Akhter on 10/28/13.//


#import "cocos2d.h"

@interface CCCustomNode : CCNode


+ (id) nodeWithImage: (NSString *) anImage forRect: (CGRect) aRect; // get Custom CCNode with Image
- (id) initWithImage: (NSString *) anImage forRect: (CGRect) aRect; // Custom CCNode initialization
- (CGRect) boundingBox;
- (void) load;                 // Load Texure when needed
- (void) unload;               // unLoad Texure when needed

@property (readwrite) CGRect myBounds;   // Box of the Tile , width , Heigh and Position
@property(strong) CCSprite *sprite;    // sprrite file of the Tile ,
@property(copy , readwrite)  NSString *imageName;  // name of the Image or Texure file

@end

