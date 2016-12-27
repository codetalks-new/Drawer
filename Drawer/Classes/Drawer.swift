import Foundation

public enum ShowingState:Int{
  case leftInPresentationMode, left,front,right,rightInPresentation
}

public enum DrawerPosition:Int{
  case left
  case right
  
  var oppositePosition: DrawerPosition{
    switch self {
    case .left: return .right
    case .right: return .left
    }
  }
  static let allCases: [DrawerPosition] = [.left, .right]
}

final public class DrawerController: UIViewController{
  
  /// The view controller displayed on top of the left and right ones
  private let frontViewController: UIViewController
  
  /// drawer position and controller map
  private var drawerPositionControllerMap: [DrawerPosition: UIViewController] = [:]
  
  /// The controllers current state.
  public private(set) var state = ShowingState.front
  
  /// Whether to disable front view interaction whenever the controller's state does not equal front. Recommended for smaller screens.
  public var disablesFrontViewInteraction = false
  
  private let frontView = DrawerControllerView(frame:.zero)
  private let leftView = DrawerControllerView(frame:.zero)
  private let rightView = DrawerControllerView(frame:.zero)
  
  
  
  public init(frontVC:UIViewController, leftVC:UIViewController?, rightVC:UIViewController?){
    self.frontViewController = frontVC
    if let left = leftVC{
      drawerPositionControllerMap[.left] = left
      leftView.viewController = left
  
    }
    if let right = rightVC{
      drawerPositionControllerMap[.right] = right
      rightView.viewController = right
    }
    
    super.init(nibName: nil, bundle: nil)
  }
  
  func  containerView(ofPosition position: DrawerPosition) -> DrawerControllerView{
    switch position {
    case .left:
      return leftView
    case .right:
      return rightView
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Controller Containment
  
  func put(childController: UIViewController,into container: UIView){
    if childViewControllers.contains(childController){
      return
    }
    addChildViewController(childController)
    childController.view.frame = container.bounds
    childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    container.addSubview(childController.view)
    
    if let drawerView = container as? DrawerControllerView{
      drawerView.viewController = childController
    }
    
    childController.didMove(toParentViewController: self)
    
  }
  
  func remove(childController:UIViewController){
    if childViewControllers.contains(childController){
      childController.willMove(toParentViewController: nil)
      childController.view.removeFromSuperview()
      childController.removeFromParentViewController()
    }
  }
  
  // MARK: View Lifecycle
  
  public override func loadView() {
    super.loadView()
    for childView in [rightView, leftView, frontView]{
       childView.frame = view.bounds
       childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       childView.isHidden = true
       view.addSubview(childView)
    }
    frontView.isHidden = false
    frontView.hasShadow = true
    
  }
  
  

  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    put(childController: frontViewController, into: frontView)
    for position in DrawerPosition.allCases{
      if let vc = viewController(atPosition: position){
        put(childController: vc, into: containerView(ofPosition: position))
      }
    }
    
    // setup Gesture Recognizers
    let drawerTapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(didRecognizeTapGesture))
     frontView.addGestureRecognizer(drawerTapGestureRecognizer)
    
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    leftView.frame   = view.bounds.divided(atDistance: leftViewWidthRange.lowerBound, from: .minXEdge).slice
    rightView.frame   = view.bounds.divided(atDistance: rightViewWidthRange.lowerBound, from: .maxXEdge).slice
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle{
    var controller: UIViewController?
    switch state {
    case .left, .leftInPresentationMode:
       controller = viewController(atPosition: .left)
    case .right, .rightInPresentation:
      controller = viewController(atPosition: .right)
    case .front:
      controller = frontViewController
    default:
      break
    }
    return controller?.preferredStatusBarStyle ?? .default
  }

  // MARK: Gesture Recognition

  func didRecognizeTapGesture(sender: UITapGestureRecognizer){
    if self.state != .front{
      transition(toState: .front)
    }
  }
  
  
  public func showLeftDrawer(){
    showDrawer(atPosition: .left)
  }
  
  public func showRightDrawer(){
    showDrawer(atPosition: .right)
  }
  
  public func showFront(){
    transition(toState: .front)
  }
  
  public func showDrawer(atPosition position: DrawerPosition){
    guard let controller = viewController(atPosition: position) else{
      fatalError("NO Controller at posistion \(position)")
    }
    switch position {
    case .left:
      transition(toState: .left)
    case .right:
      transition(toState: .right)
    }
  }
  
  func transition(toState state:ShowingState){
    if self.state == state{
      return
    }
    
    UIView.animate(withDuration: 0.25, animations: {
      if let position = self.drawerPosition(ofState: state){
        self.showView(atPosition:position)
      }
      let toPoint = self.frontViewCenter(forState: state)
      self.frontView.layer.position = toPoint
    }) { (finished) in
      self.state = self.stateForCurrentFrontViewPosition()
      if state == .front{
        self.hideRearViews()
      }
    }
    
  }
  
  func drawerPosition(ofState state: ShowingState) -> DrawerPosition?{
    switch state {
    case .left,.leftInPresentationMode: return .left
    case .right, .rightInPresentation: return .right
    default: return nil
    }
  }
  
  
  func hideRearViews(){
    for position in DrawerPosition.allCases{
      containerView(ofPosition: position).isHidden = true
      if let controller = viewController(atPosition: position){
        remove(childController: controller)
      }
    }
    frontView.updateViewController(enableUserInteraction: true)
  }
  
  func showView(atPosition position:DrawerPosition){
    let oppositePosition = position.oppositePosition
    let drawerView = containerView(ofPosition: position)
    let oppositeView = containerView(ofPosition: oppositePosition)
    
    drawerView.isHidden = false
    oppositeView.isHidden = true
    if let oppositeController = viewController(atPosition: oppositePosition){
      remove(childController: oppositeController)
    }
    if let controller = viewController(atPosition: position){
      put(childController: controller, into: drawerView)
    }
    
    frontView.updateViewController(enableUserInteraction: false)
  }
  
  var frontViewLayer:CALayer{
    return frontView.layer.presentation() ?? frontView.layer
  }
  
  var isLeftViewVisible:Bool{
    return frontViewLayer.position.x > view.bounds.midX
  }
  
  var isRightViewVisible: Bool{
    return frontViewLayer.position.x < view.bounds.midX
  }
  
  
  
  // MARK: Positioning and Sizing
  public var leftViewWidthRange = CGFloat(260)...CGFloat(300)
  public var rightViewWidthRange = CGFloat(260)...CGFloat(300)
  
  func frontViewCenter(forState state: ShowingState) -> CGPoint{
    var center  = frontView.layer.position
    let boundMidX = view.bounds.midX
    switch state {
    case .front: center.x = boundMidX
    case .left: center.x = boundMidX + leftViewWidthRange.lowerBound
    case .leftInPresentationMode: center.x  = boundMidX + leftViewWidthRange.upperBound
    case .right: center.x = boundMidX - rightViewWidthRange.lowerBound
    case .rightInPresentation: center.x = boundMidX - rightViewWidthRange.upperBound
    }
    return center
  }
  
  func stateForCurrentFrontViewPosition() -> ShowingState{
    let x = frontView.layer.position.x
    if x <= frontViewCenter(forState: .rightInPresentation).x {
      return .rightInPresentation
    }else if x < frontViewCenter(forState: .front).x {
      return .right
    }else if x == frontViewCenter(forState: .front).x {
      return .front
    }else if x < frontViewCenter(forState: .leftInPresentationMode).x {
      return .left
    }else{
      return .leftInPresentationMode
    }
  }
  
  public func viewController(atPosition position: DrawerPosition) -> UIViewController?{
    return drawerPositionControllerMap[position]
  }
  
  public var hasLeftViewController: Bool{
    return drawerPositionControllerMap[.left] != nil
  }
  
  public var hasRightViewController: Bool{
    return drawerPositionControllerMap[.right] != nil
  }
  
  
  // MARK: Autoration
  var allDrawerControllers: [UIViewController]{
    return Array(drawerPositionControllerMap.values) + [frontViewController]
  }
  
  public override var shouldAutorotate: Bool{
    let bools =  allDrawerControllers.map{ $0.shouldAutorotate }
    return bools.reduce(true){ $0.0 && $0.1 }
  }
  
  public override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
    return allDrawerControllers.map { $0.supportedInterfaceOrientations }.reduce(UIInterfaceOrientationMask.all){ $0.0.intersection($0.1) }
  }
  
  
  
}

extension UIViewController{
  public var drawerController: DrawerController?{
    var vc: UIViewController? = self
    while vc != nil {
      if let drawerVC = vc as? DrawerController{
        return drawerVC
      }
      vc = vc?.parent
    }
    return nil
  }
}
