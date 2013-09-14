//
//  ViewController.h
//  BallBrickGame
//
//  Created by Samar Gupta on 9/8/13.
//  Copyright (c) 2013 Samar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>

#define BRICKS_WIDTH 5
#define BRICKS_HEIGHT 4


@interface ViewController : UIViewController {
    UILabel *scoreLabel;
    int score;
    
    UIImageView *ball;
    UIImageView *paddle;
    CGPoint ballMovement;
    float touchOffset;
    
    int lives;
    UILabel *livesLabel;
    UILabel *messageLabel;
    BOOL isPlaying;
    CADisplayLink *theTimer;
    
    UIImageView *bricks[BRICKS_WIDTH][BRICKS_HEIGHT];
    NSString *brickTypes[4];

}

@property (nonatomic,strong)IBOutlet UILabel *scoreLabel;
@property (nonatomic,strong)IBOutlet UIImageView *ball;
@property (nonatomic,strong)IBOutlet UIImageView *paddle;
@property (nonatomic, retain) IBOutlet UILabel *livesLabel;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;


- (void)initializeTimer;
- (void)accelerometerChanges;
- (void)animateBall:(NSTimer *)theTimer;
- (void)startPlaying;
- (void)pauseGame;


- (void)initializeBricks;
@end
