/**
 * 2014-2-14
 * @author chenriji
 **/
package mortal.game.view.task
{
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.motionPaths.Direction;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTileList;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mortal.common.DisplayUtil;
	import mortal.common.display.LoaderHelp;
	import mortal.common.net.CallLater;
	import mortal.component.GCatogeryList.CatogeryListHead;
	import mortal.component.GCatogeryList.GCatogeryList;
	import mortal.component.window.BaseWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.view.TaskItemDesc;
	import mortal.game.view.task.view.render.TaskItemCellrender;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	/**
	 * 任务面板，Q键弹出的任务功能面板
	 * @author chenriji
	 * 
	 */	
	public class TaskModule extends BaseWindow
	{
		private var _list:GCatogeryList;
		private var _bg:GBitmap;
		private var _tab:GTabBar;
		// 右边的任务描述、奖励等
		private var _desc:TaskItemDesc;
		
		public function TaskModule()
		{
			super();
			
			this.setSize(625, 454);
			this.title = Language.getString(20120);
			this.titleHeight = 60;
		}
		
		public function expand(index:int=0):void
		{
//			CallLater.addCallBack(nextFrameToExpand);
			setTimeout(nextFrameToExpand, 100);
			function nextFrameToExpand():void
			{
				_list.expandItem(index);
			}
		}
		
		public function resetList():void
		{
//			_list.dispose(false);
			DisplayUtil.removeMe(_list);
			_list = new GCatogeryList(192, 375);
			_list.x = 14;
			_list.y = 67;
			
			_list.tileList.direction = GBoxDirection.VERTICAL;
			_list.tileList.columnWidth = 181;
			_list.tileList.columnCount = 1;
			_list.headGap = -3;
			
			this.addChild(_list);
			
//			_list = ObjectPool.getObject(GCatogeryList);
		}
		
		public function initHeads(datas:Array):void
		{
			_list.createHeads(CatogeryListHead, datas, 178, 23);
			_list.setCellRender(0, TaskItemCellrender, true);
			_list.setCellHeight(0, 21, true);
		}
		
		public function setDataProvider(index:int, data:DataProvider):void
		{
			_list.setDataProvider(index, data);
		}
		
		public function updateDesc(info:TaskInfo):void
		{
			if(info == null)
			{
				DisplayUtil.removeMe(_desc);
			}
			else
			{
				_desc.taskInfo = info;
				if(_desc.parent == null)
				{
					this.addChild(_desc);
				}
			}
		}
		
		public function getCurDescInfo():TaskInfo
		{
			if(_desc == null)
			{
				return null;
			}
			return _desc.taskInfo;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_tab = UIFactory.gTabBar(11, 33, TaskTrackModule.taskTabData, 85, 25, this, tabbBarChangeHandler);
			
			_bg = UIFactory.gBitmap("", 12, 65, this);
			LoaderHelp.setBitmapdata(ImagesConst.TaskPanelBg + ".swf", _bg);
			
			_list = new GCatogeryList(190, 375);
			_list.x = 13;
			_list.y = 66;
			
			_list.tileList.direction = GBoxDirection.VERTICAL;
			_list.tileList.columnWidth = 180;
			_list.tileList.columnCount = 1;
			_list.headGap = -1;
			this.addChild(_list);
			
			_desc = new TaskItemDesc();
			_desc.x = 225;
			_desc.y = 104;
			this.addChild(_desc);
			
		}
		
		public override function show(x:int=0, y:int=0):void
		{
			super.show(x, y);
//			CallLater.addCallBack(nextFrameWhenShowed);
			setTimeout(nextFrameWhenShowed, 100);
		}
		
		private function nextFrameWhenShowed():void
		{
			tabbBarChangeHandler(null);
		}
		
		public function get selectedIndex():int
		{
			return _tab.selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_tab.selectedIndex = value;
			tabbBarChangeHandler(null);
		}
		
		private function tabbBarChangeHandler(evt:Event):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.TaskModuleTabChange));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bg.dispose(isReuse);
			_bg = null;
			
			_list.dispose(false);
			_list = null;
			
			_desc.dispose(false);
			_desc = null;
		}
		
	}
}