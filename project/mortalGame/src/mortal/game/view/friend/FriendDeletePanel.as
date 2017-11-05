package mortal.game.view.friend
{
	import Message.Game.SFriendRecord;
	
	import com.mui.controls.Alert;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.net.CallLater;
	import mortal.component.window.SmallWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	/**
	 * 好友删除面板
	 * @date   2014-2-25 下午7:20:01
	 * @author dengwj
	 */	 
	public class FriendDeletePanel extends SmallWindow
	{
		private var _centerBg:ScaleBitmap;
		private var _leftBg:ScaleBitmap;
		private var _rightBg:ScaleBitmap;
		private var _leftBar:ScaleBitmap;
		private var _rightBar:ScaleBitmap;
		
		private var _selectedDelete:GTextFiled;
		private var _selectNum:GTextFiled;
		private var _closeVlue:GTextFiled;
		private var _confirmDelete:GTextFiled;
		private var _deleteNum:GTextFiled;
		
		private var _selectedList:GTileList;
		private var _deleteList:GTileList;
		
		private var _confirmBtn:GButton;
		private var _cancelBtn:GButton;
		
		/** 当前好友数 */
		private var _currFriendNum:int;
		/** 当前在线好友数 */
		private var _currOnlineNum:int;
		/** 选中的好友数 */
		private var _selectedNum:int;
		
		public function FriendDeletePanel()
		{
			super();
			init();
			this.layer = LayerManager.windowLayer;
		}
		
		private function init():void
		{
			setSize(521,367);
			title = "批量删除";
			this.isHideDispose = false;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_leftBg = UIFactory.bg(13,30+7,330,312-25,this);
			_rightBg = UIFactory.bg(345,30+7,172,312-25,this);
			_leftBar = UIFactory.bg(15,32+7,325,28,this,"RegionTitleBg");
			_rightBar = UIFactory.bg(347,32+7,168,28,this,"RegionTitleBg");
			
			_selectedDelete = UIFactory.gTextField("选择删除的好友",47,38+7,92,20,this);
			_selectedDelete.textColor = 0xf2de47;
			_selectNum = UIFactory.gTextField("[99/100]",140,38+7,60,20,this);
			_selectNum.textColor = 0xf2de47;
			_closeVlue = UIFactory.gTextField("战斗力",260,38+7,48,20,this);
			_closeVlue.textColor = 0xf2de47;
			_confirmDelete = UIFactory.gTextField("确认删除",398,38+7,57,20,this);
			_confirmDelete.textColor = 0xf2de47;
			_deleteNum = UIFactory.gTextField("[0]",450,38+7,35,20,this);
			_deleteNum.textColor = 0xf2de47;
			updateRoleNum();
			
			_selectedList = UIFactory.tileList(10,60+7,331,280-25,this);
			_selectedList.columnWidth = 331;
			_selectedList.rowHeight = 25;
			_selectedList.horizontalGap = 0;
			_selectedList.verticalGap = 0;
			_selectedList.setStyle("skin", new Bitmap());
			_selectedList.setStyle("cellRenderer", SelectedCellRenderer);
			this.addChild(_selectedList);
			
			_deleteList = UIFactory.tileList(342,60+7,171,280-25,this);
			_deleteList.columnWidth = 168;
			_deleteList.rowHeight = 25;
			_deleteList.horizontalGap = 0;
			_deleteList.verticalGap = 0;
			_deleteList.setStyle("skin", new Bitmap());
			_deleteList.setStyle("cellRenderer", DeleteCellRenderer);
			this.addChild(_deleteList);
			
			_confirmBtn = UIFactory.gButton("全部确定",167,346-11,77,23,this);
			_cancelBtn = UIFactory.gButton("全部取消",278,346-11,77,23,this);
			_confirmBtn.configEventListener(MouseEvent.CLICK, onClickHandler);
			_cancelBtn.configEventListener(MouseEvent.CLICK, onClickHandler);
			
			_selectedList.configEventListener(MouseEvent.CLICK, onListClickHandler);
		}
		
		override protected function setWindowCenter():void
		{
			
		}
		
		override protected function configParams():void
		{
			super.configParams();
		}
		
		/**
		 * 点击按钮处理 
		 * @param e
		 */
		private function onClickHandler(e:MouseEvent):void
		{
			var len:uint = this._deleteList.dataProvider.length;
			if(e.target == _confirmBtn)
			{
				var ids:Array = [];
				if(0 < len)
				{
					for(var i:uint = 0; i < len; i++)
					{
						var friendInfo:SelectedCellRenderer = this._deleteList.dataProvider.getItemAt(i).data as SelectedCellRenderer;
						ids.push(friendInfo.recordId);
//						friendInfo.isSelected = false;
					}
					var data:Object = {};
					data["ids"] = ids;
					data["type"] = 1;// 批量删除
					Alert.show("确认删除？", null, Alert.OK | Alert.CANCEL, null, onClickHandler);
					function onClickHandler(index:int):void
					{
						if(index == Alert.OK)
						{
							for(i = 0; i < len; i++)
							{
								friendInfo = _deleteList.dataProvider.getItemAt(i).data as SelectedCellRenderer;
								friendInfo.isSelected = false;
							}
							Dispatcher.dispatchEvent(new DataEvent(EventName.FriendDelete,data));
						}
						else
						{
							return;
						}
					}
				}
			}
			else
			{
				if(0 < len)
				{
					for(i = 0; i < len; i++)
					{
						friendInfo = this._deleteList.dataProvider.getItemAt(i).data as SelectedCellRenderer;
						friendInfo.isSelected = false;
					}
					this._deleteList.dataProvider = new DataProvider();
					_selectedNum = 0;
					_deleteNum.text = "[" + _selectedNum + "]";
				}
			}
		}
		
		/**
		 * 更新显示列表 
		 * @param data
		 */
		public function updateList(data:Object):void
		{
			if(data is Array)// 更新左侧好友列表
			{
				var dataProvider:DataProvider = new DataProvider();
				var friendList:Array = data as Array;
				for each(var friend:SFriendRecord in friendList)
				{
					var obj:Object = {};
					obj.data = friend;
					dataProvider.addItem(obj);
				}
				_selectedList.dataProvider = dataProvider;
				_selectedList.drawNow();
			}
			if(data is SelectedCellRenderer)// 更新右侧删除列表
			{
				var item:SelectedCellRenderer = data as SelectedCellRenderer;
				var deleteObj:Object = {};
				deleteObj.data = item;
				this._deleteList.dataProvider.addItem(deleteObj);
				_deleteList.drawNow();
			}
			this.updateRoleNum();
		}
		
		/**
		 * 点击列表处理
		 * @param e
		 */		
		private function onListClickHandler(e:MouseEvent):void
		{
			CallLater.addCallBack(nextFramWhenClickDeleteList);
		}
		
		private function nextFramWhenClickDeleteList():void
		{
			var friend:SelectedCellRenderer = _selectedList.itemToCellRenderer(_selectedList.selectedItem) as SelectedCellRenderer;
			if(friend && !friend.isSelected)
			{
				friend.isSelected = true;
				Dispatcher.dispatchEvent(new DataEvent(EventName.FriendAddToDelete, friend));
				this._selectedNum++;
				_deleteNum.text = "[" + _selectedNum + "]";
			}
		}
		
		/**
		 * 取消删除好友 
		 */		
		public function cancelDelete(obj:Object):void
		{
			if(obj != null)
			{
				this._deleteList.dataProvider.removeItem(obj);
				(obj.data as SelectedCellRenderer).isSelected = false;
				this._selectedNum--;
				_deleteNum.text = "[" + _selectedNum + "]";
			}
		}
		
		/**
		 * 删除好友后清空列表 
		 */
		public function clear():void
		{
			this._deleteList.dataProvider = new DataProvider();
			var len:uint = this._selectedList.dataProvider.length;
			var friend:SelectedCellRenderer;
			for(var i:int = 0; i < len; i++)
			{
				friend = this._selectedList.itemToCellRenderer(this._selectedList.getItemAt(i)) as SelectedCellRenderer;
				if(friend && friend.isSelected){
					friend.isSelected = false;
				}
			}
			this._selectedNum = 0;
			_deleteNum.text = "[" + _selectedNum + "]";
		}
		
		/**
		 * 设置表头上的数量显示 
		 */		
		public function updateRoleNum():void
		{
			_currFriendNum = Cache.instance.friend.friendList.length;
			_currOnlineNum = Cache.instance.friend.getCurrOnlineNum(0);
			_selectNum.text = "[" + _currOnlineNum + "/" + _currFriendNum + "]";
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_leftBg.dispose(isReuse);
			_rightBg.dispose(isReuse);
			_leftBar.dispose(isReuse);
			_rightBar.dispose(isReuse);
			_selectedDelete.dispose(isReuse);
			_selectNum.dispose(isReuse);
			_closeVlue.dispose(isReuse);
			_confirmDelete.dispose(isReuse);
			_deleteNum.dispose(isReuse);
			_selectedList.dispose(isReuse);
			_deleteList.dispose(isReuse);
			_confirmBtn.dispose(isReuse);
			_cancelBtn.dispose(isReuse);
			
			_leftBg = null;
			_rightBg = null;
			_leftBar = null;
			_rightBar = null;
			_selectedDelete = null;
			_selectNum = null;
			_closeVlue = null;
			_confirmDelete = null;
			_deleteNum = null;
			_selectedList = null;
			_deleteList = null;
			_confirmBtn = null;
			_cancelBtn = null;
		}
		
	}
}