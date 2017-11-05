/**
 * 2014-2-25
 * @author chenriji
 **/
package mortal.game.view.task.view.track
{
	import com.gengine.game.core.GameSprite;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GSprite;
	
	import mortal.common.DisplayUtil;
	import mortal.common.net.CallLater;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.data.TaskRule;
	import mortal.game.view.task.view.render.TaskTrackBase;
	import mortal.mvc.core.Dispatcher;
	
	public class TaskTrackContainer extends GSprite
	{
		private var _items:Array = [];
		private var _render:Class = TaskTrackBase;
		private var _sortRule:Array;
		
		private var _contentContainer:GSprite;
		private var _pane:GScrollPane;
		private var _canShowHide:Boolean=false;
		private var _isShow:Boolean=true;
		
		public function TaskTrackContainer()
		{
			super();
			_sortRule = TaskRule.getTaskGroupSortNormalRule();
			
			Dispatcher.addEventListener(EventName.TaskTraceItemExpand, itemExpandHandler);
		}
		
		private function itemExpandHandler(evt:DataEvent):void
		{
			CallLater.addCallBack(updateLayout);
		}
		
		public function get canShowHide():Boolean
		{
			return _canShowHide;
		}

		public function set canShowHide(value:Boolean):void
		{
			_canShowHide = value;
		}

		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_contentContainer = new GSprite();
			_pane = UIFactory.gScrollPanel(0, 0, 210, 140, this);
			_pane.source = _contentContainer;
		}
		
		public function showHide():void
		{
			if(!_canShowHide)
			{
				return;
			}
			for(var i:int = 0; i < _items.length; i++)
			{
				var item:TaskTrackBase = _items[i] as TaskTrackBase;
				if(_isShow)
				{
					item.closeInfo();
				}
				else
				{
					item.openInfo();
				}
			}
			
			_isShow = !_isShow;
			updateLayout();
		}
		
		public function get bodyHeight():int
		{
			return _contentContainer.height;
		}
		
		public function setScrollPaneHight(value:int=140):void
		{
			_pane.setSize(210, value);
			_pane.drawNow();
		}
		
		public function set render(value:Class):void
		{
			_render = value;
		}
		
		public function initList(arr:Array):void
		{
			if(_items.length > 0)
			{
				for each(var item:TaskTrackBase in _items)
				{
					DisplayUtil.removeMe(item);
				}
				_items = [];
			}
			if(arr == null || arr.length == 0)
			{
				return;
			}
			for(var i:int = 0; i < arr.length; i++)
			{
				var info:TaskInfo = arr[i];
				item = new _render();
				item.taskInfo = info;
				_contentContainer.addChild(item);
				_items.push(item);
			}
			updateLayout();
		}
		
		public function removeItem(code:int, isUpdate:Boolean=true):void
		{
			var item:TaskTrackBase = getItem(code);
			if(item == null)
			{
				return;
			}
			DisplayUtil.removeMe(item);
			var index:int = _items.indexOf(item);
			_items.splice(index, 1);
			
			if(isUpdate)
			{
				updateLayout();
			}
		}
		
		public function updateItem(info:TaskInfo, isUpdate:Boolean=true):void
		{
			addItem(info, isUpdate);
		}
		
		public function addItem(info:TaskInfo, isUpdate:Boolean=true):void
		{
			var item:TaskTrackBase = getItem(info.stask.code);
			if(item == null) // 没有则新建一个
			{
				item = new _render();
				_contentContainer.addChild(item);
				_items.push(item);
			}
			item.taskInfo = info;
			if(isUpdate)
			{
				updateLayout();
			}
		}
		
		private function getItem(code:int):TaskTrackBase
		{
			for each(var item:TaskTrackBase in _items)
			{
				if(item.taskInfo.stask.code == code)
				{
					return item;
				}
			}
			return null;
		}
		
		public function updateLayout():void
		{
			var lastY:int = 0;
			_items.sort(sort);
			for(var i:int = 0; i < _items.length; i++)
			{
				var item:TaskTrackBase = _items[i];
				item.y = lastY;
				lastY += item.height + 2;
			}
			
			_pane.source = _contentContainer;
			_pane.drawNow();
		}
		
		private function sort(a:TaskTrackBase, b:TaskTrackBase):int
		{
			var index1:int = _sortRule.indexOf(a.taskInfo.stask.group);
			var index2:int = _sortRule.indexOf(b.taskInfo.stask.group);
			if(a.taskInfo.isComplete() && b.taskInfo.isComplete())
			{
				if(index1 > index2)
				{
					return 1;
				}
				return -1;
			}
			else if(a.taskInfo.isComplete())
			{
				return -1;
			}
			else if(b.taskInfo.isComplete())
			{
				return 1;
			}
			if(index1 > index2)
			{
				return 1;
			}
			else if(index1 < index2)
			{
				return -1;
			}
			if(a.taskInfo.stask.code < b.taskInfo.stask.code)
			{
				return -1;
			}
			return 1;
		}
	}
}