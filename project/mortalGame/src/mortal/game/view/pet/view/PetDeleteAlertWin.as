/**
 * @heartspeak
 * 2014-3-17 
 */   	

package mortal.game.view.pet.view
{
	import Message.Game.SPet;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	
	import flash.events.MouseEvent;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.SmallWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.utils.PetUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class PetDeleteAlertWin extends SmallWindow
	{
		protected var _petMsgTitleText:GTextFiled;
		protected var _petMsgText:GTextFiled;
		
		protected var _input:GTextInput;
		
		protected var _btnOK:GButton;
		
		protected var _btnCancel:GButton;
		
		protected var _pet:SPet;
		
		public function PetDeleteAlertWin($layer:ILayer=null)
		{
			super($layer);
			title = "提示";
			setSize(283,273);
		}
		
		private static var _instance:PetDeleteAlertWin;
		
		public static function get instance():PetDeleteAlertWin
		{
			if(!_instance)
			{
				_instance = new PetDeleteAlertWin();
			}
			return _instance;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_petMsgTitleText = UIFactory.gTextField("",17,42,250,82,this,GlobalStyle.textFormatBai.center().setLeading(3));
			_petMsgText = UIFactory.gTextField("",105,42,250,82,this,GlobalStyle.textFormatBai.left().setLeading(3));
			_petMsgText.wordWrap = true;
			_petMsgText.multiline = true;
			pushUIToDisposeVec(UIFactory.bg(55,128,180,22,this,"TextBg"));
			pushUIToDisposeVec(UIFactory.gTextField("提示：本宠物较为珍贵",79,128,130,20,this,GlobalStyle.textFormatLv));
			pushUIToDisposeVec(UIFactory.gTextField("如确定删除，请在输入框内输入\"delete\"",17,154,250,20,this,GlobalStyle.textFormatPutong.center()));
			pushUIToDisposeVec(UIFactory.gTextField("(放生后，宠物将不可召回，永久消失)",17,172,250,20,this,GlobalStyle.textFormatLv.center()));
			_input = UIFactory.gTextInput(82,194,110,24,this);
			_btnOK = UIFactory.gButton("确认删除",72,243,64,22,this);
			_btnCancel = UIFactory.gButton("取  消",153,243,64,22,this);
			_btnOK.configEventListener(MouseEvent.CLICK,onClickBtn);
			_btnCancel.configEventListener(MouseEvent.CLICK,onClickBtn);
		}
		
		protected function onClickBtn(e:MouseEvent):void
		{
			if(e.currentTarget == _btnOK)
			{
				if(_input.text.toLocaleLowerCase() == "delete")
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.PetDeletePet,_pet.publicPet.uid));
				}
				else
				{
					MsgManager.showRollTipsMsg("输入错误");
					return;
				}
			}
			this.hide();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_petMsgText.dispose(isReuse);
			_petMsgText = null;
			_petMsgTitleText.dispose(isReuse);
			_petMsgTitleText = null;
			_input.dispose(isReuse);
			_input = null;
			_btnOK.dispose(isReuse);
			_btnOK = null;
			_btnCancel.dispose(isReuse);
			_btnCancel = null;
			_pet = null;
		}
		
		/**
		 * 显示删除宠物提示 
		 * @param spet
		 * 
		 */		
		public function showPet(spet:SPet):void
		{
			if(spet)
			{
				this.show();
				_pet = spet;
				var strTips:String = "";
				var strTipsTitle:String = "您确定要放生[" + PetUtil.getNameHtmlText(spet) + "]吗？";
				strTips += "<br><font color='#ffc293'>资质：</font>" + HTMLUtil.addColor(spet.publicPet.talent.toString(),PetUtil.getTalentColor(spet.publicPet.talent).color);
				strTips += "<br><font color='#ffc293'>等级：</font>" + spet.publicPet.level;
				strTips += "<br><font color='#ffc293'>技能：</font>" + "无";
				_petMsgText.htmlText = strTips;
				_petMsgTitleText.htmlText = strTipsTitle;
			}
		}
	}
}