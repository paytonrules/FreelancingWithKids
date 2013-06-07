#import <OCDSpec2/OCDSpec2.h>
#import "OCMock/OCMock.h"
#import "WorkdayView.h"
#import "WorkdayPresenter.h"
#import "ToDoList.h"
#import "Task.h"

@interface SimpleView : NSObject<WorkdayView>
@property (nonatomic, strong) NSString *timeAsString;
@property (assign) float progress;
@property (assign) BOOL showedYouWin;
@property (assign) BOOL showedYouLose;
@end

@implementation SimpleView

- (void)updateClockWith:(NSString *)timeAsString
{
  self.timeAsString = timeAsString;
}

- (void)showYouWin
{
  self.showedYouWin = YES;
}

- (void)showYouLose
{
  self.showedYouLose = YES;
}

- (void)updateProgress:(float)progress
{
  self.progress = progress;
}
@end

OCDSpec2Context(WorkdayPresenterSpec) {
  Describe(@"Workday Presenter", ^{

    It(@"gets a copy of the task list", ^{
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView:nil];

      ToDoList *tasks = [ToDoList new];
      [tasks add:[Task taskWithName:@"hello" andDuration:0]];

      presenter.todoList = tasks;

      [ExpectObj([presenter taskNameAt:0]) toBe:@"hello"];
    });

    It(@"updates the view when the clock ticks", ^{
      SimpleView *view = [SimpleView new];
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView: view];

      [presenter clockTicked];

      [ExpectObj(view.timeAsString) toBeEqualTo:@"9:15"];

      [presenter clockTicked];

      [ExpectObj(view.timeAsString) toBeEqualTo:@"9:30"];
    });

    It(@"allows reading of the time as a string as well", ^{
      SimpleView *view = [SimpleView new];
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView: view];

      [ExpectObj(presenter.currentTime) toBeEqualTo:@"9:00"];
    });

    It(@"updates the stress of daddy for the minimum", ^{
      SimpleView *view = [SimpleView new];
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView:view];

      [presenter updateStress:-50];

      [ExpectFloat(view.progress) toBe:0.0f withPrecision:0.0001f];
    });

    It(@"updates the stress for the maximum", ^{
      SimpleView *view = [SimpleView new];
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView:view];

      [presenter updateStress:50];

      [ExpectFloat(view.progress) toBe:1.0f withPrecision:0.0001f];
    });

    It(@"shows you win when the game is successful", ^{
      SimpleView *view = [SimpleView new];
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView: view];

      [presenter gameOver:Successful];

      [ExpectBool(view.showedYouWin) toBeTrue];
    });

    It(@"Shows you lose otherwise", ^{
      SimpleView *view = [SimpleView new];
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView:view];

      [presenter gameOver:Failed];

      [ExpectBool(view.showedYouLose) toBeTrue];
    });

    It(@"provides the task count", ^{
      ToDoList *tasks = [ToDoList new];
      [tasks add:[Task taskWithName:@"hello" andDuration:0]];
      [tasks add:[Task taskWithName:@"helloAgain" andDuration:0]];

      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView:nil];
      presenter.todoList = tasks;

      [ExpectInt(presenter.taskCount) toBe:2];
    });
  });
}
