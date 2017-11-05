package mortal.game.view.mail.view
{
	import Message.Game.EFriendFlag;
	import Message.Game.SFriendRecord;
	
	import com.gengine.utils.StringHelper;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.tlf_internal;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	import mx.utils.StringUtil;
	
	/**
	 * 写邮件面板
	 * @author lizhaoning
	 */
	public class MailWritePanel extends GSprite
	{
		/** 背景 */
		private var _bg:ScaleBitmap;
		
		/** 收件人发件人 */
		private var _txtName1:GTextFiled;
		private var _txtName2:GTextInput;
		
		/** 标题 */
		private var _txtTitle1:GTextFiled;
		private var _txtTitle2:GTextInput;
		
		/** 好友列表 */
		private var _friendCombox:GComboBox;
		
		/** 内容 */
		private var _txtContent:MTextAreaBox;
		
		//本次邮资
		private var _txtStaticCost:GTextFiled;
		private var _txtCoin:GTextFiled;
		private var _bmpTongqian:GBitmap;
		
		
		/** 发送邮件 */
		private var _btnSend:GButton;
		
		public function MailWritePanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			//背景
			_bg = UIFactory.bg(0,0,311,290,this);
			//文本框
			_txtName1 = UIFactory.textField("收件人：",6,5,54,20,this,null,false,false);
			_txtName1.textColor = 0xFFFFFF;
			_txtTitle1 = UIFactory.textField("标   题：",6,28,54,20,this,null,false,false);
			_txtTitle1.textColor = 0xFFFFFF;
			
			_friendCombox = UIFactory.gComboBox(213,_txtName1.y-1,90,22,null,this);
			initFriendComBox();
			
			_txtName2 = UIFactory.gTextInput(_txtName1.x + _txtName1.width,_txtName1.y-1,152,22,this);
			_txtName2.maxChars = 10;
			
			_txtTitle2 = UIFactory.gTextInput(_txtTitle1.x + _txtTitle1.width,_txtName2.y+24-1,242,22,this);
			_txtTitle2.maxChars = 10;
			
			//正文部分
			_txtContent = createTextAreaBox(_txtName1.x+3,56,293,200);
			_txtContent.ta.text  = "";
			_txtContent.ta.maxChars = 100;
			
			//邮资
			_txtStaticCost = UIFactory.textField("本次邮资：",10,262,60,20,this);
			_txtCoin = UIFactory.textField("100",70,262,40,20,this);
			_txtCoin.textColor = GlobalStyle.yellowUint;
			_bmpTongqian = UIFactory.bitmap(ImagesConst.Jinbi,100,_txtCoin.y+5,this);
			
			//发送
			_btnSend = UIFactory.gButton("发送邮件",230,263,70,22,this);
			
			//事件监听
			_btnSend.configEventListener(MouseEvent.CLICK,btnSendClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_bg.dispose(isReuse);
			_txtName1.dispose(isReuse);
			_txtTitle1.dispose(isReuse);
			_friendCombox.dispose(isReuse);
			_txtName2.dispose(isReuse);
			_txtTitle2.dispose(isReuse);
			_txtContent.dispose(isReuse);
			_txtCoin.dispose(isReuse);
			_txtStaticCost.dispose(isReuse);
			_bmpTongqian.dispose(isReuse);
			_btnSend.dispose(isReuse);
			
			
			_bg = null;
			_txtName1 = null;
			_txtTitle1 = null;
			_friendCombox = null;
			_txtName2 = null;
			_txtTitle2 = null;
			_txtContent = null;
			_txtCoin = null;
			_txtStaticCost = null;
			_bmpTongqian = null;
			_btnSend = null;
		}
		
		private function initFriendComBox():void
		{
			_friendCombox.addItem({label:"选择好友",type:0});
			var friendArr:Array = Cache.instance.friend.getCacheDataByType(EFriendFlag._EFriendFlagFriend);
			for (var i:int = 0; i < friendArr.length; i++) 
			{
				var friend:SFriendRecord = friendArr[i];
				_friendCombox.addItem({label:friend.friendPlayer.name,type:1});
			}
			_friendCombox.configEventListener(Event.CHANGE,onFriendComboboxChange);
		}
		
		private function onFriendComboboxChange(e:Event):void
		{
			var obj:Object = _friendCombox.selectedItem;
			if(obj.type == 1)
			{
				this._txtName2.text = obj.label;
			}
		}
		
		
		private function createTextAreaBox(x:int,y:int,width:int = 117,height:int = 23):MTextAreaBox
		{
			var textbox:MTextAreaBox = UICompomentPool.getUICompoment(MTextAreaBox);
			textbox.createDisposedChildren();
			
			
			textbox.bg.width = width;
			textbox.ta.width = width;
			textbox.bg.height = height;
			textbox.ta.height = height;
			
			textbox.ta.editable = true;
			

			textbox.x = x;
			textbox.y = y;
			this.addChild(textbox);
			return textbox;
		}
		
		public function setToPlyerName(name:String):void
		{
			if(name)
			{
				this._txtName2.text = name;
			}
		}
		
		private function btnSendClickHandler(e:MouseEvent):void  //发送邮件
		{
			// TODO Auto Generated method stub
			if(Cache.instance.role.roleInfo.level<30)
			{
				MsgManager.showRollTipsMsg("必须30级才能发送邮件");
				return;
			}
			if(StringHelper.isWhitespace(this._txtName2.text))
			{
				MsgManager.showRollTipsMsg("请输入收件人");
				return;
			}
			if(this._txtName2.text == Cache.instance.role.playerInfo.name)
			{
				MsgManager.showRollTipsMsg("不能给自己发邮件");
				return;
			}
			if(Cache.instance.friend.isBlackListByName(_txtName2.text))
			{
				MsgManager.showRollTipsMsg("不能给黑名单玩家发邮件");
				return;
			}
			if(StringHelper.isWhitespace(this._txtTitle2.text))
			{
				MsgManager.showRollTipsMsg("请输入主题");
				return;
			}
			if(StringHelper.isWhitespace(this._txtContent.ta.text))
			{
				MsgManager.showRollTipsMsg("请输入信件内容");
				return;
			}
			if(Cache.instance.role.money.coinBind <100 && Cache.instance.role.money.coin <100)
			{
				MsgManager.showRollTipsMsg("发送失败，铜币不足");
				return;
			}
			
			var obj:Object = {};
			obj.toPlayerName = this._txtName2.text;
			obj.title = this._txtTitle2.text;
			obj.content = this._txtContent.ta.text;
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.MailSend,obj));
		}
		
		/**
		 * 清除文字 发送邮件成功后调用 
		 */
		public function clearWord():void
		{
			this._txtName2.text = "";
			this._txtTitle2.text = "";
			this._txtContent.ta.text = "";
		}
		
		
	}
}