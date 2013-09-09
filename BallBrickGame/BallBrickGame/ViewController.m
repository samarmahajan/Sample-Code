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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ballMovement = CGPointMake(4.0, 4.0);
    [self initializeTimer];
    [self accelerometerChanges];
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


-(void)initializeTimer
{
    float theInterval = 1.0/30.0;
    [NSTimer scheduledTimerWithTimeInterval:theInterval target:self selector:@selector(animateBall:) userInfo:nil repeats:YES];


}

-(void)animateBall:(NSTimer *)theTimer
{
    ball.center = CGPointMake(ball.center.x + ballMovement.x, ball.center.y + ballMovement.y);
    
    if (ball.center.x > 300 || ball.center.x < 20)
    {
        ballMovement.x = -ballMovement.x;
    }
    if (ball.center.y > 440 || ball.center.y < 40)
    {
        ballMovement.y = -ballMovement.y;
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
