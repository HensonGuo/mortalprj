package mortal.game.view.friend
{
	import Message.Game.EFriendReplyResult;
	import Message.Public.SMiniPlayer;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GTileList;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import mortal.component.window.SmallWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	/**
	 * 好友申请面板
	 * @date   2014-3-13 下午3:36:57
	 * @author dengwj
	 */	 
	public class FriendApplyPanel extends SmallWindow
	{
		/** 申请者列表 */
		private var _applyerList:GTileList;
		/** 全部拒绝按钮 */
		private var _refuseAllBtn:GButton;
		/** 全部接受按钮 */
		private var _recieveAllBtn:GButton;
		
		public function FriendApplyPanel($layer:ILayer=null)
		{
			super($layer);
			init();
			this.layer = LayerManager.windowLayer;
		}
		
		private function init():void
		{
			setSize(320,230);
			title = "好友申请";
			this.isHideDispose = false;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_applyerList = UIFactory.tileList(8,35,312,64*5,this);
			_applyerList.columnWidth = 292;
			_applyerList.rowHeight = 63;
			_applyerList.setStyle("skin", new Bitmap());
			_applyerList.setStyle("cellRenderer", FriendApplyCellRenderer);
			this.addChild(_applyerList);
			
			_refuseAllBtn = UIFactory.gButton("全部拒绝",78,194,79,23,this);
			_recieveAllBtn = UIFactory.gButton("全部接受",176,194,79,23,this);
			_refuseAllBtn.configEventListener(MouseEvent.CLICK,onClickHandler);
			_recieveAllBtn.configEventListener(MouseEvent.CLICK,onClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_applyerList.dispose(isReuse);
			_refuseAllBtn.dispose(isReuse);
			_recieveAllBtn.dispose(isReuse);
			
			_applyerList = null;
			_refuseAllBtn = null;
			_recieveAllBtn = null;
		}
		
		override protected function configParams():void
		{
			super.configParams();
			
			paddingBottom = 48;
		}
		
		override protected function setWindowCenter():void
		{
			
		}
		
		override public function show(x:int=0, y:int=0):void
		{
			super.show();
			
			updateList();
			updateWinSize();
		}
		
		/**
		 * 根据申请量更新窗口大小 
		 * 
		 */		
		public function updateWinSize():void
		{
			var rowHeight:int = this._applyerList.rowHeight;
			var length:int = this._applyerList.length;
			if(length >= 2 && length <= 5)
			{
				var result:int = length * rowHeight;
				this.height = 96 + result;
				this.width = 320;
				paddingBottom = 48;
				this._recieveAllBtn.y = this.height - 40;
				this._refuseAllBtn.y = this.height - 40;
			}
		}
		
		/**
		 * 更新显示列表 
		 */		
		public function updateList():void
		{
			
		}
		
		/**
		 * 添加一个申请者到列表 
		 * @param applyer
		 */		
		public function addApplyer(applyer:SMiniPlayer):void
		{
			this._applyerList.addItem(applyer);
			this._applyerList.drawNow();
		}
		
		/**
		 * 从列表移除一个申请者 
		 * @param applyer
		 */		
		public function removeApplyer(applyer:SMiniPlayer):void
		{
			this._applyerList.removeItem(applyer);
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			var result:int;
			var data:Object = {};
			var ids:Array = [];
			if(e.target == this._recieveAllBtn)// 全部接受
			{
				result = EFriendReplyResult._EFriendReplyResultAccept;
				this.hide();
			}
			else// 全部拒绝
			{
				result = EFriendReplyResult._EFriendReplyResultReject;			
			}
			for each(var player:SMiniPlayer in FriendIcon.instance.applyerList)
			{
				ids.push(player.entityId.id);
			}
			data["result"] = result;
			data["playerId"] = ids;
			Dispatcher.dispatchEvent(new DataEvent(EventName.FriendReply, data));
			
		}
	}
}