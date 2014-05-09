//
//  BackgroundLayer.m
//  PrettySimpleMap
//
//  Created by Fazeel Akhter on 10/29/13.//


#import "MapTestLayer.h"
#import "CCCustomMapImage.h"
#import "CCCustomNode.h"

@implementation MapTestLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    MapTestLayer *layer = [MapTestLayer node];
    [scene addChild: layer];
    return scene;
}

-(void) onEnter {
    [super onEnter];
    [self initializeStuff];
}


- (void) updateForScreenReshape
{
	CGSize s = [[CCDirectorIOS sharedDirector] winSize];
	CCNode *node = [self.containLayer getChildByTag:120];
	node.anchorPoint = ccp(0.5f, 0.5f);
	node.position = ccp(0.5f * s.width, 0.5f * s.height);
}



-(void) initializeStuff {
    
    CCCustomMapImage *mapNode = [ CCCustomMapImage nodeWithFileName:Map_Layer_Input_File_Name  zIndex:0];
    sprite  = [CCSprite spriteWithFile:Map_Layer_Top_Selected_File_Name rect:CGRectMake(0, 0, 146, 140)];
    [sprite setAnchorPoint:CGPointMake(.5, .5)];
    [sprite setPosition:CGPointMake(1447, 3110)];
    
    CGSize windDowSize = [[CCDirectorIOS sharedDirector] winSize];
    self.position = CGPointZero;
    self.anchorPoint = CGPointZero;
    self.contentSize = windDowSize;
    self.containLayer = [[CCLayer alloc] init];
    self.containLayer.anchorPoint = CGPointZero;
    
    
    self.containLayer.position = CGPointZero;
    self.containLayer.anchorPoint = CGPointZero;
    self.containLayer.contentSize = mapNode.contentSize;
    CCLayerColor * backgroundColor = [CCLayerColor layerWithColor:ccc4(20, 120, 120, 1)];
    [backgroundColor setContentSize:self.containLayer.contentSize];
    [self.containLayer addChild:backgroundColor z:100];
    [mapNode addChild:sprite];
    [mapNode setTag:Map_Layer_Node_Tag];
    [self.containLayer addChild:mapNode z:120];
    
    
    self.containLayer.scale = .5;
    self.myScrollView = [[CCScrollView alloc] initWithViewSize:windDowSize container:self.containLayer];
    self.myScrollView.position = CGPointZero;
    self.myScrollView.anchorPoint= CGPointZero;
    self.myScrollView.direction = CCScrollViewDirectionBoth;
    self.myScrollView.contentOffset = CGPointMake(0 , 0);
    
    [self.myScrollView setDelegate:self];
    [self.myScrollView setMinZoomScale:.3];
    [self.myScrollView setMaxZoomScale:1];
    [self addChild:self.myScrollView];
    
}


-(void) scrollViewDidTouched :(UITouch *) touch{
    
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGPoint point =  [self.containLayer convertToNodeSpace:location];
    
        // Check if Upper Layer is tapped or not.
    if (CGRectContainsPoint([sprite boundingBox], point)) {
        CCNode * textNode = [self.containLayer getChildByTag:Map_Text_Message_Tag];
        if(!textNode){
            CCLabelTTF * messageLabel = [CCLabelTTF labelWithString:Map_Text_Message
                                                           fontName:Map_Text_Message_FONT_NAME
                                                           fontSize:Map_Text_Message_FONT_SIZE
                                                         dimensions:CGSizeMake(100,100)
                                                         hAlignment:kCCTextAlignmentLeft];
            [messageLabel setPosition:point];
            [self.containLayer addChild:messageLabel
                                      z:5000
                                    tag:Map_Text_Message_Tag];
        }else{
            [textNode removeFromParentAndCleanup:TRUE];
        }
    }
    
}

-(void)scrollViewDidScroll:(CCScrollView *)view{
        // NSLog(@" Scroll");
    
}
-(void)scrollViewDidZoom:(CCScrollView *)view{
    
        // NSLog(@" zoom");
}


@end
