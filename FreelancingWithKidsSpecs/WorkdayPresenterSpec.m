#import <OCDSpec2/OCDSpec2.h>
#import "OCMock/OCMock.h"
#import "WorkdayView.h"
#import "WorkdayPresenter.h"
#import "Daddy.h"

OCDSpec2Context(WorkdayPresenterSpec) {
  
  Describe(@"Workday Presenter", ^{
    
    It(@"delegates starting a workday to its day", ^{
      id view = [OCMockObject mockForProtocol:@protocol(WorkdayView)];
      id day = [OCMockObject mockForClass:[Daddy class]];
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithView:nil];
      presenter.day = day;
      
      [[day expect] startWorkingOn:@"task" withDelegate:view];
      
      [presenter startWorkingOn:@"task" withDelegate:view];
      
      [day verify];
    });
    
  });
  
}
