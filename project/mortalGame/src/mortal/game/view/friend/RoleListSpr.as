package mortal.game.view.friend
{
	import Message.Game.SFriendRecord;
	
	import com.mui.controls.GSprite;
	import com.mui.controls.GTileList;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 角色列表部分
	 * @date   2014-2-21 上午11:56:19
	 * @author dengwj
	 */	 
	public class RoleListSpr extends GSprite
	{
		/** 角色列表 */
		private var _roleList:GTileList;
		/** 密友列表 */
		private var _closeFriendList:GTileList;
		/** 当前选中角色 */
		private var _currentRole:FriendCellRenderer;
		
		public function RoleListSpr()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_roleList = UIFactory.tileList(7, 25 + 21, 293, 315 - 31, this);
			_roleList.columnWidth = 291;
			_roleList.rowHeight = 45;
			_roleList.horizontalGap = 0;
			_roleList.verticalGap = 0;
			_roleList.setStyle("skin", new Bitmap());
			_roleList.setStyle("cellRenderer", FriendCellRenderer);
			this.addChild(_roleList);
			
			_closeFriendList = UIFactory.tileList(7, 25, 293, 315-31, this);
			
			_closeFriendList.columnWidth = 291;
			_closeFriendList.rowHeight = 53;
			_closeFriendList.horizontalGap = 0;
			_closeFriendList.verticalGap = 0;
			_closeFriendList.setStyle("skin", new Bitmap());
			_closeFriendList.setStyle("cellRenderer", FriendCellRenderer);
			this.addChild(_closeFriendList);
			
//			this.configEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_roleList.dispose(isReuse);
			_closeFriendList.dispose(isReuse);
			
			_roleList = null;
			_closeFriendList = null;
		}
		
		/**
		 * 更新不同分组下的角色数据
		 */
		public function updateListRoles(data:Array):void
		{
			var dataProvider:DataProvider = new DataProvider();
			for each(var item:* in data)
			{
				var obj:Object = new Object();
				obj.data  = item;
				dataProvider.addItem(obj);
			}
			_roleList.dataProvider = dataProvider;
			_roleList.drawNow();
		}
		
		/**
		 * 更新密友列表
		 * @param e
		 */		
		public function updateCloseFriendList(data:Array):void
		{
			var dataProvider:DataProvider = new DataProvider();
			for each(var item:SFriendRecord in data)
			{
				var obj:Object = new Object();
				obj.data  = item;
				dataProvider.addItem(obj);
			}
			_closeFriendList.dataProvider = dataProvider;
			_closeFriendList.drawNow();
		}
		
		public function get currentRole():FriendCellRenderer
		{
			return this._currentRole;
		}
		
		public function set currentRole(role:FriendCellRenderer):void
		{
			this._currentRole = role;
		}
		
		public function get roleList():GTileList
		{
			return this._roleList;
		}
		
		public function get closeFriendList():GTileList
		{
			return this._closeFriendList;
		}
	}
}