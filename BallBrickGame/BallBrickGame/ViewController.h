//
//  ViewController.h
//  BallBrickGame
//
//  Created by Samar Gupta on 9/8/13.
//  Copyright (c) 2013 Samar Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    UILabel *scoreLabel;
    int score;
    
    UIImageView *ball;
    UIImageView *paddle;
    CGPoint ballMovement;

}

@property (nonatomic,strong)IBOutlet UILabel *scoreLabel;
@property (nonatomic,strong)IBOutlet UIImageView *ball;
@property (nonatomic,strong)IBOutlet UIImageView *paddle;

-(void)initializeTimer;
-(void)accelerometerChanges;
-(void)animateBall:(NSTimer *)theTimer;
@end
