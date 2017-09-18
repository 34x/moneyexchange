Sample money exchange app/screen.

- I mostly used programmatic auto layout instead of storyboard, because usually in real life applications storyboard editing with multiple developers is very difficult in case of merges. Also because I never actively used it before.
- No additional modules or components because no need, also to make things simple, and not to overload with CocoaPods or Carthage.
- Major methods are async because in actual app this type of actions will depend on network requests.
- Only one orientation device - to simplify UI part.

What else I have in mind:

- Exchange rows height and overall exchange screen depends on keyboard height.
- Some success animation when exchange is finished.
- Additional graphical info to make user clear view that he/she is exchanging from the top row to the bottom.
- Additional graphic symbols to show that user can switch currencies by swiping.
- In case of many currencies there should be a list instead of a scroll/swipe, because it’s easier.
