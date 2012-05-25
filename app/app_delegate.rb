class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    tableView = NewTableController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(tableView)
    @window.makeKeyAndVisible
    
    true
  end


end
