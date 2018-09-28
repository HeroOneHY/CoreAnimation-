//
//  ViewController.m
//  06_CAAnimation_Demo
//
//  Created by baoxu on 16/3/9.
//  Copyright © 2016年 BaoXu. All rights reserved.
//

#import "ViewController.h"
/**
 *  1.什么是核心动画？
    是苹果提供的非常强大的动画处理API，能够做出比较绚丽的动画效果，而且使用的代码量非常少
    2.核心动画是直接作用在CALayer上的
    3.核心动画的基础功能定义在CAAnimation中
    4.CAAnimation提供个三个子类：
 
        CAAnimationGroup
        CATransition
        CAPropertyAnimation:(提供了两个子类)
 CABasicAnimation,CAKeyframeAnimation
 */

@interface ViewController ()<CAAnimationDelegate>
@property (strong, nonatomic) CALayer *layer;
@property (strong, nonatomic) CAAnimation *pathAnimation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.首先要创建一个CALayer对象，因为核心动画是作用在layer上的
    CALayer *layer = [CALayer layer];
    [self.view.layer addSublayer:layer];
    layer.frame = CGRectMake(50, 50, 100, 100);
    layer.backgroundColor = [UIColor redColor].CGColor;
    self.layer = layer;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  //  [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
//    [self test7];
  //  [self test8];
    [self test9];
    
}

- (IBAction)pause:(id)sender {
    
    [self pauseLayer:self.layer];
}

- (IBAction)resume:(id)sender {
    
    [self resumeLayer:self.layer];
}
//暂停动画
-(void)pauseLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() toLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}
//继续动画
-(void)resumeLayer:(CALayer *)layer{

    CFTimeInterval pausedTime = [layer timeOffset];
    
    layer.speed = 1.0;
    
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    
    CFTimeInterval timePause = [layer convertTime:CACurrentMediaTime() toLayer:nil] - pausedTime;
    layer.beginTime = timePause;
}
//CATransition 转场动画
-(void)test9{
    CATransition *transtion = [CATransition animation];
//    1.#define定义的常量      kCATransitionFade   交叉淡化过渡
//         kCATransitionMoveIn 新视图移到旧视图上面
//         kCATransitionPush   新视图把旧视图推出去
//         kCATransitionReveal 将旧视图移开,显示下面的新视图
//       2.用字符串表示      pageCurl            向上翻一页
//         pageUnCurl          向下翻一页
//         rippleEffect        滴水效果
//         suckEffect          收缩效果，如一块布被抽走
//         cube                立方体效果
//         oglFlip             上下翻转效果
    
   transtion.type = @"cube";
  //  transtion.subtype = kCATransitionFromLeft;//kCATransitionFromLeft  kCATransitionFromRight
    transtion.duration = 1;
    _transtionIndex++;
    if (_transtionIndex > 1) {
        _transtionIndex = 0;
    }
    _layer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"u%@.jpg",@(_transtionIndex)]].CGImage;
    [_layer addAnimation:transtion forKey:@"transtion"];
}
//spring动画
-(void)test8{
    CASpringAnimation *springAni = [CASpringAnimation animationWithKeyPath:@"position"];
    springAni.damping = 2; //阻尼系数，地面的摩擦力
    springAni.stiffness = 50; //弹簧的劲度系数
    springAni.mass = 1;  //小球质量，影响惯性
    springAni.initialVelocity = 10; //初始速度，相当于给小球一个初始速度（可正可负，方向不同）
    springAni.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 400)];
    springAni.duration = springAni.settlingDuration;
    [_layer addAnimation:springAni forKey:@"springAnimation"];
}

/**
 *  试验7.layer绕着矩形循环跑（拓展）
 */
-(void)test7{
    //处理一下layer
    self.layer.frame = CGRectMake(15, 200, 30, 30);
    self.layer.cornerRadius = 15;
    
    //来一个帧动画
    
    
    CAKeyframeAnimation *rectRunAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //设定关键帧的位置，必须包含起点和终点
    rectRunAnimation.values = @[
        [NSValue valueWithCGPoint:self.layer.frame.origin],
        [NSValue valueWithCGPoint:CGPointMake(375-15, self.layer.frame.origin.y)],
        [NSValue valueWithCGPoint:CGPointMake(375-15, self.layer.frame.origin.y + 150)],
        [NSValue valueWithCGPoint:CGPointMake(15, self.layer.frame.origin.y + 150)],
        [NSValue valueWithCGPoint:self.layer.frame.origin]
        ];
    
    //设定每个关键帧的时长，如果没有明显设置，每个帧的时间 = 总时间/（values.count - 1）
    //时间分配范围从0到1，如果某个关键帧超过1那么将立刻回到原点
//    rectRunAnimation.keyTimes = @[
//        [NSNumber numberWithFloat:0.0],
//        [NSNumber numberWithFloat:0.5],
//        [NSNumber numberWithFloat:0.6],
//        [NSNumber numberWithFloat:0.7],
//        [NSNumber numberWithFloat:1.0]
//                                  ];
    
//    //使用时间函数，规定动画效果
    rectRunAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                         ];
    
    rectRunAnimation.repeatCount = MAXFLOAT;
    //动画结束后是否逆行动画
//    rectRunAnimation.autoreverses = YES;
    
    //运动方式
    rectRunAnimation.calculationMode = kCAAnimationLinear;
    
    rectRunAnimation.duration = 6.0;
    //添加动画
    [self.layer addAnimation:rectRunAnimation forKey:nil];
    
}
/**
 CAKeyFrameAnimation的使用中有以下主要的属性需要注意
 （1）values属性
 
 values属性指明整个动画过程中的关键帧点，例如上例中的A-E就是通过values指定的。需要注意的是，起点必须作为values的第一个值。
 
 （2）path属性
 
 作用与values属性一样，同样是用于指定整个动画所经过的路径的。需要注意的是，values与path是互斥的，当values与path同时指定时，path会覆盖values，即values属性将被忽略。例如上述pathAnimation例子
 
 （3）keyTimes属性
 
 该属性是一个数组，用以指定每个子路径(AB,BC,CD)的时间。如果你没有显式地对keyTimes进行设置，则系统会默认每条子路径的时间为：ti=duration/(5-1)，即每条子路径的duration相等，都为duration的1\4。当然，我们也可以传个数组让物体快慢结合。例如，你可以传入{0.0, 0.1,0.6,0.7,1.0}，其中首尾必须分别是0和1，因此tAB=0.1-0, tCB=0.6-0.1, tDC=0.7-0.6, tED=1-0.7.....
 
 （4）timeFunctions属性
 
 用过UIKit层动画的同学应该对这个属性不陌生，这个属性用以指定时间函数，类似于运动的加速度，有以下几种类型。上例子的AB段就是用了淡入淡出效果。记住，这是一个数组，你有几个子路径就应该传入几个元素
 
 1 kCAMediaTimingFunctionLinear//线性
 2 kCAMediaTimingFunctionEaseIn//淡入
 3 kCAMediaTimingFunctionEaseOut//淡出
 4 kCAMediaTimingFunctionEaseInEaseOut//淡入淡出
 5 kCAMediaTimingFunctionDefault//默认
 
 （5）calculationMode属性
 
 该属性决定了物体在每个子路径下是跳着走还是匀速走，跟timeFunctions属性有点类似
 
 1 const kCAAnimationLinear//线性，默认
 2 const kCAAnimationDiscrete//离散，无中间过程，但keyTimes设置的时间依旧生效，物体跳跃地出现在各个关键帧上
 3 const kCAAnimationPaced//平均，keyTimes跟timeFunctions失效
 4 const kCAAnimationCubic//平均，同上
 5 const kCAAnimationCubicPaced//平均，同上
 
 */



/**
 *  试验6.组合动画
 */
-(void)test6{
//创建组动画
    CAAnimationGroup *ainmaGroup = [CAAnimationGroup animation];
    
//缩放
    CABasicAnimation *ban2 = [CABasicAnimation animation];
    //    ban2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    ban2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 1.5, 1)];
    ban2.duration = 3;
    ban2.delegate = self;
    
    ban2.removedOnCompletion = NO;
    ban2.fillMode = kCAFillModeForwards;
    
    ban2.keyPath = @"transform";
    
//旋转
    CABasicAnimation *ban3 = [CABasicAnimation animationWithKeyPath:@"transform"];
    ban3.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //CATransform3DIdentity是单位矩阵，没有缩放，旋转，等改动，都是默认值
    ban3.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/4, 0, 0, 1)];
    ban3.duration = 3.0;
    
    //动画效果是否累计（下一次的动画执行是否接着上次结束的动画）
    ban3.cumulative = YES;
    //动画次数
    ban3.repeatCount = 2;
    
//透明度
    CABasicAnimation *ban4 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ban4.fromValue = [NSNumber numberWithFloat:1.0];
    ban4.toValue = [NSNumber numberWithFloat:0.1];
    
    ban4.duration = 3.0;
    
    ban4.removedOnCompletion = NO;
    ban4.fillMode = kCAFillModeForwards;
    
    ainmaGroup.animations = [NSArray arrayWithObjects:ban2,ban3,ban4,self.pathAnimation, nil];
    
    ainmaGroup.duration = 5;
    
    [self.layer addAnimation:ainmaGroup forKey:nil];
}


//CAKeyframeAnimation
- (CAAnimation *)pathAnimation
{
    if (!_pathAnimation) {
        /**
         CAKeyframeAnimation
         
         在画线的时候，方法的内部默认创建一个path。它把路径都放到了path里面去。
         1.创建路径  CGMutablePathRef 调用该方法相当于创建了一个路径，这个路径用来保存绘图信息。
         2.把绘图信息添加到路径里边。
         以前的方法是点的位置添加到ctx（图形上下文信息）中，ctx 默认会在内部创建一个path用来保存绘图信息。
         在图形上下文中有一块存储空间专门用来存储绘图信息，其实这块空间就是CGMutablePathRef。
         3.把路径添加到上下文中。
         */
        
        //键帧动画开发分为两种形式：一种是通过设置不同的属性值进行关键帧控制，另一种是通过绘制路径进行关键帧控制。后者优先级高于前者，如果设置了路径则属性值就不再起作用。
        

        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 50, 120);
        CGPathAddLineToPoint(path, NULL, 300, 488);
        CGPathAddCurveToPoint(path,NULL,50.0,275.0,150.0,275.0,150.0,120.0);
        CGPathAddCurveToPoint(path,NULL,150.0,275.0,250.0,275.0,250.0,120.0);
        CGPathAddCurveToPoint(path,NULL,250.0,275.0,350.0,275.0,350.0,120.0);
        CGPathAddCurveToPoint(path,NULL,350.0,275.0,450.0,275.0,450.0,120.0);
        
        [animation setPath:path];
        [animation setDuration:3.0];
        
        CFRelease(path);
        //ARC的诞生大大简化了我们针对内存管理的开发工作，但是只支持管理 Objective-C 对象, 不支持 Core Foundation 对象。Core Foundation 对象必须使用CFRetain和CFRelease来进行内存管理
        //http://blog.csdn.net/yiyaaixuexi/article/details/8553659
        

        
        _pathAnimation = animation;
    }
    return _pathAnimation;
}

/**
 *  试验5.帧动画演示
 */
-(void)test5{

    [self.layer addAnimation:self.pathAnimation forKey:nil];
}

/**
 *  试验4.透明度属性
 */
-(void)test4{
//    self.layer.opacity
    CABasicAnimation *ban4 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ban4.fromValue = [NSNumber numberWithFloat:1.0];
    ban4.toValue = [NSNumber numberWithFloat:0.1];

    ban4.duration = 3.0;
    
    ban4.removedOnCompletion = NO;
    ban4.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:ban4 forKey:nil];
}

/**
 *  试验3.旋转属性
 */
-(void)test3{
    //初始化的时候就定制好动画的类型
    CABasicAnimation *ban3 = [CABasicAnimation animationWithKeyPath:@"transform"];
    ban3.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //CATransform3DIdentity是单位矩阵，没有缩放，旋转，等改动，都是默认值
    ban3.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/4, 0, 0, 1)];
    ban3.duration = 3.0;
    
    //动画效果是否累计（下一次的动画执行是否接着上次结束的动画）
    ban3.cumulative = YES;
    //动画次数
    ban3.repeatCount = 2;
    
    [self.layer addAnimation:ban3 forKey:nil];
    
}

/**
 *  试验2.缩放属性
 */
-(void)test2{
    CABasicAnimation *ban2 = [CABasicAnimation animation];
//    ban2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    ban2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 1.5, 1)];
    ban2.duration = 3;
    ban2.delegate = self;
    
    ban2.removedOnCompletion = NO;
    ban2.fillMode = kCAFillModeForwards;
    
    ban2.keyPath = @"transform";
    //如果已经设置了keyPath属性，后面forKey值可以穿空
    [self.layer addAnimation:ban2 forKey:nil];
}

/**
 *  试验1.（位移类型，以position为参考点执行动画）
 */
-(void)test1{
    //创建基础动画
    CABasicAnimation *ban1 = [CABasicAnimation animation];
    //设置动画路径
    //锚点的位置，如果不设置起始位置，则从当前位置开始
//    ban1.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];

    //变化到什么值结束
    ban1.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 500)];
    //设置动画时间
    ban1.duration = 3;
    ban1.delegate = self;
    
    //当前动画完成后，还会回到最初的位置，这个是核心动画的特点
    //禁止归位,不删除动画效果,保留最新状态
    ban1.removedOnCompletion = NO;
    ban1.fillMode = kCAFillModeForwards;
    
    
    //设置动画属性值
    NSString *keyPath = @"position";
    //keyPath决定了执行怎样的动画
    
    //使用KVC的方式来告示动画，要使用layer的哪个属性变化值来执行动画
    [self.layer addAnimation:ban1 forKey:keyPath];
    
}
-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"%@",NSStringFromCGRect(self.layer.frame));
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"%@",NSStringFromCGRect(self.layer.frame));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
