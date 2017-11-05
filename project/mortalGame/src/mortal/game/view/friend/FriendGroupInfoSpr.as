package mortal.game.view.friend
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import mortal.game.cache.Cache;
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 好友分组栏信息提示部分
	 * @author dengwj
	 */
	public class FriendGroupInfoSpr extends GSprite
	{
		/** 背景底子 */
		private var _bg:ScaleBitmap;
		private var _addSpr:Sprite;
		/** 打开图标 */
		private var _addImg:GBitmap;
		/** 关闭图标 */
		private var _plusSpr:Sprite;
		private var _plusImg:GBitmap;
		/** 列表类型 */
		private var _listTypeLabel:GTextFiled;
		/** 列表人数 */
		private var _listRoleNum:GTextFiled;
//		/** vip提示文本 */
//		private var _vipLabel:GTextFiled; //暂时取消
		/** 亲密度 */
		private var _intimacyLabel:GTextFiled;
		/** 战斗力 */
		private var _fightLabel:GTextFiled;
		/** 当前在线好友数 */
		private var _currOnlineNum:int;
		/** 总共好友数 */
		private var _totalFriendsNum:int;
		/** 当前在线密友数 */
		private var _currOnlineCloseNum:int;
		/** 总共密友数 */
		private var _totalCloseNum:int;
		/** 好友密友类型标识  0--密友  1--好友*/
		private var _flag:int;
		
		public function FriendGroupInfoSpr()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_addSpr = UIFactory.sprite(4,7,this);
			_addImg = UIFactory.gBitmap("Add",0,0,_addSpr);
			_plusSpr = UIFactory.sprite(4,7,this);
			_plusImg = UIFactory.gBitmap("Plus",0,4,_plusSpr);
			_plusSpr.visible = false;
			_listTypeLabel = UIFactory.gTextField("",18,3,90,20,this);
			_listTypeLabel.textColor = 0xffffff;
			_listRoleNum = UIFactory.gTextField("[0/0]",71,3,60,20,this);
			_listRoleNum.textColor = 0xffffff;
//			_vipLabel = UIFactory.gTextField("vip200",102,3,48,20,this);
//			_vipLabel.textColor = 0x00ff00;
//			_vipLabel.visible = false;
			_intimacyLabel = UIFactory.gTextField("亲密度",212,3,50,20,this);
			_intimacyLabel.textColor = 0xffffff;
			_fightLabel = UIFactory.gTextField("战斗力",212,3,50,20,this);
			_fightLabel.textColor = 0xffffff;
			_fightLabel.visible = false;
			
			updateListType(0);
			_addSpr.buttonMode = true;
			_addSpr.mouseChildren = false;
			_addSpr.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			_addSpr.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			
			_plusSpr.buttonMode = true;
			_plusSpr.mouseChildren = false;
			_plusSpr.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			_plusSpr.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_addImg.dispose(isReuse);
			_plusImg.dispose(isReuse);
			_listTypeLabel.dispose(isReuse);
			_listRoleNum.dispose(isReuse);
//			_vipLabel.dispose(isReuse);
			_intimacyLabel.dispose(isReuse);
			_fightLabel.dispose(isReuse);
			
			_addImg = null;
			_plusImg = null;
			_listTypeLabel = null;
			_listRoleNum = null;
//			_vipLabel = null;
			_intimacyLabel = null;
			_fightLabel = null;
			
			_addSpr.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			_addSpr.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			_plusSpr.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			_plusSpr.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
		}
		
		/**
		 * 更新列表类型
		 */		
		public function updateListType(index:int):void
		{
			switch(index)
			{
				case 0:
					if(flag == 0)
					{
						_listTypeLabel.text = "密友列表";
					}
					else
					{
						_listTypeLabel.text = "好友列表";
//						_vipLabel.visible = true;
					}
					_intimacyLabel.visible = true;
					_listRoleNum.visible = true;
					_fightLabel.visible = false;
					break;
				case 1:
					_listTypeLabel.text = "仇人列表";
					_intimacyLabel.visible = false;
					_listRoleNum.visible = false;
					_fightLabel.visible = true;
					break;
				case 2:
					_listTypeLabel.text = "黑名单列表";
					_intimacyLabel.visible = false;
					_listRoleNum.visible = false;
					_fightLabel.visible = false;
					break;
				case 3:
					_listTypeLabel.text = "最近联系人列表";
					_intimacyLabel.visible = false;
					_listRoleNum.visible = false;
					_fightLabel.visible = false;
					break;
			}	
		}
		
		/**
		 * 更新好友/密友列表显示人数
		 */		
		public function updateRoleNum():void
		{
			if(flag == 0)
			{
				_currOnlineCloseNum = Cache.instance.friend.getCurrOnlineNum(1);
				_totalCloseNum = Cache.instance.friend.closeFriendList.length;
				_listRoleNum.text = "[" + _currOnlineCloseNum + "/" + _totalCloseNum + "]";
			}
			else
			{
				_currOnlineNum = Cache.instance.friend.getCurrOnlineNum(0);
				_totalFriendsNum = Cache.instance.friend.friendList.length;
				_listRoleNum.text = "[" + _currOnlineNum + "/" + _totalFriendsNum + "]";
			}			
		}
		
		public function set flag(type:int):void
		{
			this._flag = type;
		}
		
		public function get flag():int
		{
			return this._flag;
		}
		
		/**
		 * 切换按钮状态 true--打开 false--关闭 
		 */		
		public function switchBtnState(value:Boolean):void
		{
			if(value)
			{
				this._addSpr.visible = false;
				this._plusSpr.visible = true;
			}
			else
			{
				this._addSpr.visible = true;
				this._plusSpr.visible = false;
			}
		}
		
		private function onMouseOverHandler(e:MouseEvent):void
		{
			Mouse.cursor = "button";
		}
		
		private function onMouseOutHandler(e:MouseEvent):void
		{
			Mouse.cursor = "auto";
		}
		
		public function get addSpr():Sprite
		{
			return this._addSpr;
		}
		
		public function get plusSpr():Sprite
		{
			return this._plusSpr;
		}
	}
}