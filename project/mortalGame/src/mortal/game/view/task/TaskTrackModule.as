/**
 * 2014-2-14
 * @author chenriji
 **/
package mortal.game.view.task
{
	import com.gengine.global.Global;
	import com.gengine.utils.HTMLUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTabBar;
	import com.mui.core.GlobalClass;
	import com.mui.events.MuiEvent;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.DisplayUtil;
	import mortal.common.net.CallLater;
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.BaseWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.view.render.TaskTrackBase;
	import mortal.game.view.task.view.render.TaskTrackDoing;
	import mortal.game.view.task.view.track.BtnShowTaskDetial;
	import mortal.game.view.task.view.track.BtnShowTaskTrack;
	import mortal.game.view.task.view.track.BtnViewTaskModule;
	import mortal.game.view.task.view.track.TaskTrackContainer;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	/**
	 * 桌面的任务追踪面板
	 * @author chenriji
	 * 
	 */	
	public class TaskTrackModule extends View
	{
		public static const taskTabData:Array = 
			[	
				{label:Language.getString(20121),name:"1"},//当前任务
				{label:Language.getString(20122),name:"2"}//可接任务
			];
		
		//  进行中的任务
		private var _taskDoing:TaskTrackContainer;
		//  可接任务
		private var _taskCanGet:TaskTrackContainer;
		
		private var _showTrack:Boolean = true;
		
		private var _bodySprite:Sprite;
		private var _bgSprite:Sprite;
		private var _hideBtn:BtnShowTaskTrack;
		
		private var _moveBtn:GLoadedButton;
		private var _tabBar:GTabBar;
		private var _alphaBtn:GButton;
		private var _openBtn:BtnShowTaskDetial;
		private var _shrinkBtn:GLoadedButton;
		private var _upLine:Bitmap;
		private var _bottomLine:Bitmap;
		private var _bgImg:Bitmap;
		private var _dragRect:Rectangle = new Rectangle();
		private var _viewTaskModule:BtnViewTaskModule;
		
		private var _myHeightChange:int = 1;//高度变化趋势
		private var _myHeight:int = midHeight;//高度变化步长
		
		private var _hideTween:TweenMax;
		private var _showTween:TweenMax;
		
		private static const maxHeight:int = 230;
		private static const midHeight:int = 145;
		private static const minHieght:int = 0;
		
		// 默认情况下， 会根据当前栏目的高度自动调整，但是用户点击过调整高度的话就不调整了
		private var _isAutoChange:Boolean = true;
		
		public function TaskTrackModule()
		{
			super();
			this.layer = LayerManager.uiLayer;
			mouseEnabled = false;
			
			_bodySprite = new Sprite();
			addChild(_bodySprite);
			_bodySprite.mouseEnabled = false;
			
			_bgSprite = new Sprite();
			_bodySprite.addChild(_bgSprite);
			_bgSprite.mouseEnabled = false;
			_bgSprite.mouseChildren = false;
			
			_moveBtn = UIFactory.gLoadedButton(ImagesConst.TaskTrackMove_upSkin, 0, 0, 24, 22, _bodySprite);
			
			_tabBar = new GTabBar();
			_tabBar.x = 53;
			//			_tabBar.y = 1;
			_tabBar.buttonWidth = 60;
			_tabBar.buttonHeight = 22;
			_tabBar.horizontalGap = -2;
			_tabBar.buttonFilters = [FilterConst.glowFilter];
			_tabBar.dataProvider = taskTabData;
			_bodySprite.addChild(_tabBar);
			_tabBar.addEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE,onTabBarChangeHandler);
			_tabBar.buttonStyleName = "Button";
			
			_viewTaskModule = new BtnViewTaskModule();
			_viewTaskModule.x = 22;
			//			_viewTaskModule.y = 1;
			_viewTaskModule.setSize(32,22);
			_viewTaskModule.label = Language.getString(20146);//"全部";
			_bodySprite.addChild(_viewTaskModule);
			_viewTaskModule.addEventListener(MouseEvent.CLICK, viewTaskModuleHandler);
			
			_openBtn = new BtnShowTaskDetial();
			_openBtn.x = 167;
			_openBtn.y = 0;
			_bodySprite.addChild(_openBtn);
			_openBtn.addEventListener(MouseEvent.CLICK,onOpenNameBtnClickHandler);
			
			_shrinkBtn = UIFactory.gLoadedButton(ImagesConst.Shrink_upSkin, 187, -2, 26, 26, _bodySprite);
			_shrinkBtn.label = "";
			_shrinkBtn.addEventListener(MouseEvent.CLICK,onShrinkBtnClickHandler);
			
			
			_bgImg = GlobalClass.getBitmap("TaskTrackBg");
			_bgImg.y = 20;
			_bgImg.width = width;
			_bgImg.height = 145;
			_bgSprite.addChild(_bgImg);
			
			_upLine = GlobalClass.getBitmap(ImagesConst.SplitLine);
			_upLine.y = 20;
			_upLine.x = -20;
			_upLine.width = 300;
			_bgSprite.addChild(_upLine);
			
			_bottomLine = GlobalClass.getBitmap(ImagesConst.SplitLine);
			_bottomLine.y = 164;
			_bottomLine.x = -20;
			_bottomLine.width = 300;
			_bgSprite.alpha = 1.6;
			_bgSprite.addChild(_bottomLine);
			
			_hideBtn = new BtnShowTaskTrack();
			_hideBtn.x = _shrinkBtn.x + _shrinkBtn.width + 2;
			_hideBtn.y = 2;
			addChild(_hideBtn);
			
			_moveBtn.addEventListener(MouseEvent.MOUSE_DOWN,onMoveBtnMouseHandler);
			_hideBtn.addEventListener(MouseEvent.CLICK,onHideBtnClickHandler);
			
			_moveBtn.toolTipData = HTMLUtil.addColor(Language.getString(20713),"#FFFFFF");//"按住可拖动界面"
			//			_alphaBtn.toolTipData = HTMLUtil.addColor("设置界面透明度","#ffffff");
			_shrinkBtn.toolTipData = HTMLUtil.addColor(Language.getString(20714),"#ffffff");//设置界面高度
			
			_taskCanGet = new TaskTrackContainer();
			_taskCanGet.x = 4;
			_taskCanGet.y = 25;
			_taskCanGet.render = TaskTrackBase;
//			_bodySprite.addChild(_taskCanGet);
			_taskDoing = new TaskTrackContainer();
			_bodySprite.addChild(_taskDoing);
			_taskDoing.x = 4;
			_taskDoing.y = 25;
			_taskDoing.render = TaskTrackDoing;
			_taskDoing.canShowHide = true;
			
		}
		
		/**
		 * 循环任务按钮点击事件 
		 * @param event
		 * 
		 */
		private function viewTaskModuleHandler(event:MouseEvent):void
		{
//			GameManager.instance.popupWindow(ModuleType.Tasks);
			Dispatcher.dispatchEvent(new DataEvent(EventName.TaskShowHideModule));
		}
		
		/**
		 * tab切换 
		 * @param e
		 * 
		 */
		private function onTabBarChangeHandler(e:MuiEvent):void
		{
			var index:int = _tabBar.selectedIndex;
			if(index == 0)
			{
				showDoingTasks();	
			}
			else
			{
				showCanGetTasks();
			}
		}
		
		public function get taskCanGet():TaskTrackContainer
		{
			if(_isAutoChange)
			{
				CallLater.addCallBack(nextFrameAfterHeightChange);
			}
			return _taskCanGet;
		}
		
		public function get taskDoing():TaskTrackContainer
		{
			if(_isAutoChange)
			{
				CallLater.addCallBack(nextFrameAfterHeightChange);
			}
			return _taskDoing;
		}
		
		private function nextFrameAfterHeightChange():void
		{
			autoChangeHeight();
		}
		
		public function showDoingTasks():void
		{
			_bodySprite.addChild(_taskDoing);
			DisplayUtil.removeMe(_taskCanGet);
		}
		
		public function showCanGetTasks():void
		{
			_bodySprite.addChild(_taskCanGet);
			DisplayUtil.removeMe(_taskDoing);
		}
		
		/**
		 * 隐藏/显示
		 * @param event
		 * 
		 */
		private function onHideBtnClickHandler(event:MouseEvent):void
		{
			if(_showTrack)//隐藏
			{
				hideTrack();
			}
			else//显示
			{
				showTrack();
			}
//			this.dispatchEvent(new DataEvent(EventName.TrackClick, _showTrack));
//			
//			//cjx加的，爬塔副本用
//			Dispatcher.dispatchEvent(new DataEvent(EventName.TrackClick, _showTrack));
		}
		
		/**
		 * 拖动按下 
		 * @param event
		 * 
		 */
		private function onMoveBtnMouseHandler(event:MouseEvent):void
		{
			_dragRect.x = 0;
			_dragRect.y = 0;
			_dragRect.width = SceneRange.display.width - 30;
			_dragRect.height = SceneRange.display.height - 30;
			startDrag(false,_dragRect);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUpHandler);
		}
		
		/**
		 * 拖动释放 
		 * @param event
		 * 
		 */
		private function onStageMouseUpHandler(event:MouseEvent):void
		{
			stopDrag();
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUpHandler);
		}
		
		/**
		 * 显示追踪 
		 * 
		 */
		public function showTrack():void
		{
			if(_hideTween && _hideTween.active)
			{
				_hideTween.kill();
			}
			
			x = SceneRange.display.width - width;
			y = 180 + 20 *(SceneRange.display.height/1000);
			_showTween = TweenMax.to(_bodySprite,0.2,{x:0,ease:Quint.easeIn});
			_hideBtn.show = true;
			_showTrack = true;
			
			if(!_bodySprite.parent)
			{
				addChild(_bodySprite);
			}
		}
		
		/**
		 * 隐藏追踪 
		 * 
		 */
		public function hideTrack():void
		{
			if(_showTween && _showTween.active)
			{
				_showTween.kill();
			}
			
			x = SceneRange.display.width - width;
			y = 180 + 20 *(SceneRange.display.height/1000);
			_hideTween = TweenMax.to(_bodySprite,0.2,{x:width,ease:Quint.easeOut,onComplete:onHideEnd});
			_hideBtn.show = false;
			_showTrack = false;
		}
		
		/**
		 * 隐藏完成 
		 * 
		 */
		private function onHideEnd():void
		{
			if(_bodySprite.parent)
			{
				removeChild(_bodySprite);
			}
		}
		
		/**
		 * 显示任务详情打开或关闭 
		 * @param event
		 * 
		 */
		private function onOpenNameBtnClickHandler(event:MouseEvent):void
		{
			if(_taskDoing.parent != null)
			{
				_taskDoing.showHide();
			}
		}
		
		/**
		 * 高度变换 
		 * @param event
		 * 
		 */
		private function onShrinkBtnClickHandler(event:MouseEvent):void
		{
			if(_myHeightChange == 1)
			{
				if(_myHeight == minHieght)
				{
					_myHeight = midHeight;
				}
				else if(_myHeight == midHeight)
				{
					_myHeight = maxHeight;
				}
				else if(_myHeight == maxHeight)
				{
					_myHeight = midHeight;
					_myHeightChange = -1;
				}
			}
			else
			{
				if(_myHeight == minHieght)
				{
					_myHeight = midHeight;
					_myHeightChange = 1;
				}
				else if(_myHeight == midHeight)
				{
					_myHeight = minHieght;
				}
				else if(_myHeight == maxHeight)
				{
					_myHeight = midHeight;
				}
			}
			
			changHeight();
		}
		
		/**
		 * 自动改变高度 
		 * 
		 */
		private function autoChangeHeight():void
		{
			var isChange:Boolean = false;
			if(_tabBar.selectedIndex == 0)//当前任务
			{
				if(_taskDoing.bodyHeight > _myHeight && _myHeight == midHeight)//超过了高度
				{
					_myHeight = maxHeight;
					isChange = true;
				}
				else if(_taskDoing.bodyHeight < midHeight && _myHeight == maxHeight)//高度足够小
				{
					_myHeight = midHeight;
					isChange = true;
				}
			}
			else//可接任务
			{
				if(_taskCanGet.bodyHeight > _myHeight && _myHeight == midHeight)//超过了高度
				{
					_myHeight = maxHeight;
					isChange = true;
				}
				else if(_taskCanGet.bodyHeight < midHeight && _myHeight == maxHeight)//高度足够小
				{
					_myHeight = midHeight;
					isChange = true;
				}
			}
			if(isChange)
			{
				changHeight();
			}
		}
		
		/**
		 * 改变高度 
		 * 
		 */
		private function changHeight():void
		{
			var change:int = _myHeight - _bgImg.height;
			
			_bgImg.height += change;
			_bottomLine.y += change;
			
			if(_myHeight > 20)
			{
				_taskDoing.setScrollPaneHight(_myHeight - 4);
				_taskCanGet.setScrollPaneHight(_myHeight - 4);
				
				if(_tabBar.selectedIndex == 0)
				{
					showDoingTasks();
				}
				else
				{
					showCanGetTasks();
				}
			}
			else
			{
				DisplayUtil.removeMe(_taskDoing);
				DisplayUtil.removeMe(_taskCanGet);
			}
		}
		
	
		/**
		 * 舞台大小改变 
		 * 
		 */
		public override function stageResize():void
		{
			super.stageResize();
			x = Global.stage.stageWidth - width;
			y = 180 + 20 * ( Global.stage.stageHeight / 1000 );
//			x = 200;
//			y = 300;
		}
		
		/**
		 * 指引 
		 * @param info
		 * 
		 */
		public function guideTips(info:TaskInfo):void
		{
			//			_taskCurrent.guideTips(info);
		}
		
		/**
		 * 隐藏指引 
		 * 
		 */
		public function guideHide():void
		{
			//			_taskCurrent.guideHide();
		}
		
		/**
		 * 引导体验vip小飞鞋 
		 * @param task
		 * 
		 */
		public function guideVipFly(task:TaskInfo):void
		{
			//			if(!TaskCache.showTrack)
			//			{
			//				showTrack();
			//			}
//			showCurrent(false);
			guideTips(task);
		}
		
		/**
		 * 引导完成活动可获得大量经验 
		 * @param task
		 * 
		 */
		public function guideDailyAct(task:TaskInfo):void
		{
			//			if(!TaskCache.showTrack)
			//			{
			//				showTrack();
			//			}
//			showCurrent(false);
			guideTips(task);
		}
		
		/**
		 * F8改变舞台大小 
		 * 
		 */
		public function onStageResizeF8():void
		{
			_myHeight = midHeight;
			changHeight();
		}
		
		override public function show(x:int=0,y:int=0):void
		{
			super.show();
			stageResize();
		}
		
		override public function get width():Number
		{
			return 232;
		}
	}
}