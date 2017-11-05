package mortal.game.view.friend
{
	import Message.Game.EFriendReplyResult;
	import Message.Public.SMiniPlayer;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * @date   2014-3-13 下午7:18:24
	 * @author dengwj
	 */	 
	public class FriendApplyCellRenderer extends GCellRenderer
	{
		private var _roleCamp:GTextFiled;
		private var _roleName:GTextFiled;
		private var _roleLevel:GTextFiled;
		private var _applyMsg:GTextFiled;
		private var _okBtn:GButton;
		private var _cancelBtn:GButton;
		private var _spliteLine:ScaleBitmap;
		
		private var _player:SMiniPlayer;
		
		public function FriendApplyCellRenderer()
		{
			super();
			this.setSize(153, 25);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this._roleCamp = UIFactory.gTextField("",22,11,40,23,this);
			this._roleName = UIFactory.gTextField("",57,11,51,23,this);
			this._roleLevel = UIFactory.gTextField("",113,11,66,23,this);
			this._roleLevel.textColor = GlobalStyle.dYellowUint;
			this._applyMsg = UIFactory.gTextField("申请加你为好友，是否同意？",22,42,215,23,this);
			this._applyMsg.textColor = GlobalStyle.colorBaiUint;
			this._okBtn = UIFactory.gButton("是",245,12,51,23,this);
			this._cancelBtn = UIFactory.gButton("否",245,39,51,23,this);	
			this._spliteLine = UIFactory.bg(22,70,246,1,this,ImagesConst.SplitLine);
			
			this._okBtn.configEventListener(MouseEvent.CLICK, onClickHandler);
			this._cancelBtn.configEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			this._roleCamp.dispose(isReuse);
			this._roleName.dispose(isReuse);
			this._roleLevel.dispose(isReuse);
			this._applyMsg.dispose(isReuse);
			this._okBtn.dispose(isReuse);
			this._cancelBtn.dispose(isReuse);
			this._spliteLine.dispose(isReuse);
			
			this._roleCamp = null;
			this._roleName = null;
			this._roleLevel = null;
			this._applyMsg = null;
			this._okBtn = null;
			this._cancelBtn = null;
			this._spliteLine = null;
		}
		
		override public function set data(arg0:Object):void
		{
			if(arg0 != null)
			{
				var player:SMiniPlayer = arg0 as SMiniPlayer;
				this._player = player;
				this._roleCamp.htmlText = GameDefConfig.instance.getCampHtml(player.camp);
				_roleName.htmlText = "<u><a href='event:0'><font color='#ffffff'>" + player.name + "</font></a></u>";
				this._roleLevel.text = "(" + player.level + "级)";
			}
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			var result:int  = 0;
			var data:Object = new Object();
			var ids:Array   = new Array();
			
			if(e.target == this._okBtn)
			{
				result = EFriendReplyResult._EFriendReplyResultAccept;
			}
			else if(e.target == this._cancelBtn)
			{
				result = EFriendReplyResult._EFriendReplyResultReject;
			}
			ids.push(this._player.entityId.id);
			data["result"]   = result;
			data["playerId"] = ids;
			Dispatcher.dispatchEvent(new DataEvent(EventName.FriendReply, data));
		}
		
		private function onTextClickHandler(e:TextEvent):void
		{
			//TODO=================== 弹出下拉菜单
		}
	}
}