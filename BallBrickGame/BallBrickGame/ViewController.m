//
//  ViewController.m
//  BallBrickGame
//
//  Created by Samar Gupta on 9/8/13.
//  Copyright (c) 2013 Samar Gupta. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>


@interface ViewController ()
{
    CMMotionManager *motionManager;
    NSOperationQueue *queue;

}
@end

@implementation ViewController
@synthesize scoreLabel;
@synthesize ball;
@synthesize paddle;
@synthesize livesLabel;
@synthesize messageLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ballMovement = CGPointMake(4.0, 4.0);
    [self startPlaying];
    [self accelerometerChanges];
    [self initializeBricks];
}

- (void)initializeBricks
{
    brickTypes[0] = @"bricktype1.png";
    brickTypes[1] = @"bricktype2.png";
    brickTypes[2] = @"bricktype3.png";
    brickTypes[3] = @"bricktype4.png";
    int count = 0;
    for (int y = 0; y < BRICKS_HEIGHT; y++)
    {
        for (int x = 0; x < BRICKS_WIDTH; x++)
        {
            UIImage *image = [UIImage imageNamed:
                              brickTypes[count++ % 4]];
            bricks[x][y] = [[UIImageView alloc] initWithImage:image];
            CGRect newFrame = bricks[x][y].frame;
            newFrame.origin = CGPointMake(x * 64, (y * 40) + 100);
            bricks[x][y].frame = newFrame;
            [self.view addSubview:bricks[x][y]];
        } }
}

- (void)startPlaying {
    if (!lives) {
        lives = 3;
        score = 0; }
    scoreLabel.text = [NSString stringWithFormat:@"%05d", score];
    livesLabel.text = [NSString stringWithFormat:@"%d", lives];
    ball.center = CGPointMake(159, 239);
    ballMovement = CGPointMake(4,4);
    // choose whether the ball moves left to right or right to left
    if (arc4random() % 100 < 50)
        ballMovement.x = -ballMovement.x;
    
    messageLabel.hidden = YES;
    isPlaying = YES;
    [self initializeTimer];
}
- (void)pauseGame {
    [theTimer invalidate];
    theTimer = nil;
}

-(void)accelerometerChanges
{
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval  = 1.0/10.0; // Update at 10Hz
    if (motionManager.accelerometerAvailable) {
        NSLog(@"Accelerometer avaliable");
        queue = [NSOperationQueue currentQueue];
        [motionManager startAccelerometerUpdatesToQueue:queue
                                            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                CMAcceleration acceleration = accelerometerData.acceleration;
                                                
                                                float newX = paddle.center.x + (acceleration.x * 12);
                                                if (newX > 30 && newX < 290)
                                                {
                                                    paddle.center = CGPointMake(newX, paddle.center.y);
                                                }
                                                
                                                }];
        
    }


}


- (void)initializeTimer
{
    if (theTimer == nil)
    {
        theTimer = [CADisplayLink displayLinkWithTarget:self
                                               selector:@selector(animateBall:)];
        theTimer.frameInterval = 2;
        [theTimer addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
    }
}

-(void)animateBall:(NSTimer *)theTimer1
{
    ball.center = CGPointMake(ball.center.x + ballMovement.x, ball.center.y + ballMovement.y);
    
    
    BOOL paddleCollision = ball.center.y >= paddle.center.y - 16 &&
    ball.center.y <= paddle.center.y + 16 &&
    ball.center.x > paddle.center.x - 32 &&
    ball.center.x < paddle.center.x + 32;
    
    if (paddleCollision)
    {
        ballMovement.y = -ballMovement.y;
        if (ball.center.y >= paddle.center.y - 16 && ballMovement.y < 0) {
            ball.center = CGPointMake(ball.center.x, paddle.center.y - 16);
        } else if (ball.center.y <= paddle.center.y + 16 && ballMovement.y > 0) {
            ball.center = CGPointMake(ball.center.x, paddle.center.y + 16);
        } else if (ball.center.x >= paddle.center.x - 32 && ballMovement.x < 0) {
            ball.center = CGPointMake(paddle.center.x - 32, ball.center.y);
        } else if (ball.center.x <= paddle.center.x + 32 && ballMovement.x > 0) {
            ball.center = CGPointMake(paddle.center.x + 32, ball.center.y);
        }
    }
    
    BOOL there_are_solid_bricks = NO;
    for (int y = 0; y < BRICKS_HEIGHT; y++)
    {
        for (int x = 0; x < BRICKS_WIDTH; x++)
        {
            if (1.0 == bricks[x][y].alpha)
            {
                there_are_solid_bricks = YES;
                if ( CGRectIntersectsRect(ball.frame, bricks[x][y].frame) )
                {
                    [self processCollision:bricks[x][y]];
                }
            } else {
                if (bricks[x][y].alpha > 0)
                    bricks[x][y].alpha -= 0.1;
            }
        }
    }
    
    if (!there_are_solid_bricks) {
        [theTimer invalidate];
        isPlaying = NO;
        lives = 0;
        messageLabel.text = @"You Win!";
        messageLabel.hidden = NO;
    }
    
    
    if (ball.center.x > 300 || ball.center.x < 20)
    {
        ballMovement.x = -ballMovement.x;
    }
    if (ball.center.y > 444 || ball.center.y < 40)
    {
        ballMovement.y = -ballMovement.y;
    }

    
    if (ball.center.y < 32)
        ballMovement.y = -ballMovement.y;
    if (ball.center.y > 444)
    {
        [self pauseGame];
        isPlaying = NO;
        lives--;
        livesLabel.text = [NSString stringWithFormat:@"%d", lives];
        if (!lives) {
            messageLabel.text = @"Game Over";
        } else {
            messageLabel.text = @"Ball Out of Bounds";
        }
        messageLabel.hidden = NO;
    }
}

- (void)processCollision:(UIImageView *)brick
{
    score += 10;
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    if (ballMovement.x > 0 && brick.frame.origin.x - ball.center.x <= 4)
        ballMovement.x = -ballMovement.x;
    else if (ballMovement.x < 0 && ball.center.x - (brick.frame.origin.x +
                                                    brick.frame.size.width) <= 4)
        ballMovement.x = -ballMovement.x;
    if (ballMovement.y > 0 && brick.frame.origin.y - ball.center.y <= 4)
        ballMovement.y = -ballMovement.y;
    else if (ballMovement.y < 0 && ball.center.y - (brick.frame.origin.y +
                                                    brick.frame.size.height) <= 4)
        ballMovement.y = -ballMovement.y;
    brick.alpha -= 0.1;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (isPlaying)
    {
        UITouch *touch = [[event allTouches] anyObject];
        touchOffset = paddle.center.x - [touch locationInView:touch.view].x;
    }
    else
    {
        [self startPlaying];
    }
    

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isPlaying)
    {
        UITouch *touch = [[event allTouches] anyObject];
        float distanceMoved = ([touch locationInView:touch.view].x + touchOffset) - paddle.center.x;
        float newX = paddle.center.x + distanceMoved;
        
        if (newX > 30 && newX < 290)
        {
            paddle.center = CGPointMake(newX, paddle.center.y);
        }
        if (newX > 290)
        {
            paddle.center = CGPointMake(290, paddle.center.y);
        }
        if (newX < 30)
        {
            paddle.center = CGPointMake(30, paddle.center.y);
        }

    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
