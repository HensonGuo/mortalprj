package mortal.game.view.friend
{
	import Message.Public.SMiniPlayer;
	
	import com.mui.controls.Alert;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;

	/**
	 * 好友飘字图标
	 * @date   2014-3-1 下午1:07:24
	 * @author dengwj
	 */	 
	public class FriendIcon extends View
	{
		private static var _tabIndex:int;
		/** 显示图标 */
		private var _icon:GBitmap;
		/** 申请人数文本 */
		private var _applyNumLabel:GTextFiled;
		
		public static var applyer:SMiniPlayer;
		/** 申请人集合 */
		private var _applyerList:Vector.<SMiniPlayer> = new Vector.<SMiniPlayer>();
		/** 申请面板 */
		private var _applyPanel:FriendApplyPanel;
		
		public function FriendIcon()
		{
			super();
			
			this.layer = LayerManager.smallIconLayer;
			this.mouseChildren = false;
			this.buttonMode = true;
			this.mouseEnabled = true;
			this._applyPanel = new FriendApplyPanel();
		}
		
		private static var _instance:FriendIcon;
		
		
		public static function get instance():FriendIcon
		{
			if(!_instance)
			{
				_instance = new FriendIcon();
			}
			return _instance;
		}
		
		public static function set tabIndex(value:int):void
		{
			_tabIndex = value;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_icon = UIFactory.gBitmap("",0,0,this);
			
			setIcon(_tabIndex);
			var tfm:TextFormat = new TextFormat(FontUtil.defaultName, 9, 0xffffff);
			_applyNumLabel = UIFactory.gTextField("",14,11,20,20,this,tfm);
			this.configEventListener(MouseEvent.CLICK,openGroupWin);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_icon.dispose(isReuse);
			_applyNumLabel.dispose(isReuse);
			
			_icon = null;
			_applyNumLabel = null;
		}
		
		private function setIcon(value:int):void
		{
			var url:String;
			switch(value)
			{
				case 3:
					url = ImagesConst.FriendHintIcon;
					break;
				case 4:
					url = ImagesConst.GroupHintIcon;
					break;
			}
			_icon.bitmapData = GlobalClass.getBitmapData(url);
		}
		
		private function openGroupWin(e:MouseEvent):void
		{
			this._applyPanel.show();
		}
		
		/**
		 * 添加一个申请者 
		 */		
		public function addApplyer(applyer:SMiniPlayer):void
		{
			for each(var role:SMiniPlayer in this._applyerList)
			{
				if(role.entityId.id == applyer.entityId.id)
				{
					return;
				}
			}
			this._applyerList.push(applyer);
			updateApplyNum();
			this._applyPanel.addApplyer(applyer);
			this._applyPanel.updateWinSize();
		}
		
		/**
		 * 移除一个申请者 
		 */		
		public function removeApplyer(playerId:int):void
		{
			for(var i:int = 0; i < this._applyerList.length; i++)
			{
				if(playerId == this._applyerList[i].entityId.id)
				{
					this._applyPanel.removeApplyer(this._applyerList[i]);
					this._applyerList.splice(i,1);
					updateApplyNum();
					this._applyPanel.updateWinSize();
					break;
				}
			}
			if(this._applyerList.length == 0)
			{
				this.hide();
				this._applyPanel.hide();
			}
		}
		
		/**
		 * 更新申请数量显示 
		 */		
		public function updateApplyNum():void
		{
			this._applyNumLabel.text = "" + this._applyerList.length;
		}
		
		public function get applyerList():Vector.<SMiniPlayer>
		{
			return this._applyerList;
		}
	}
}