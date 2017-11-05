package mortal.game.view.business
{
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.component.window.SmallWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	/**
	 * 选择数量弹窗
	 * @author lizhaoning
	 */
	public class TradeSelectNumWin extends SmallWindow
	{
		private static var _instance:TradeSelectNumWin;
		
		private var _textField:GTextFiled;
		private var _textInput:GTextInput;
		private var _btnOK:GButton;
		private var _btnCancel:GButton;
		
		public function TradeSelectNumWin($layer:ILayer=null)
		{
			super($layer);
			this.setSize(280,210);
			if( _instance != null )
			{
				throw new Error(" TradeSelectNumWin 单例 ");
			}
		}
		
		public static function get instance():TradeSelectNumWin
		{
			if(_instance == null)
			{
				_instance = new TradeSelectNumWin();
			}
			return _instance;
		}
		
		
//		override protected function configParams():void
//		{
//			paddingBottom = 55;
//			paddingLeft = 7;
//			blurTop = 4;
//			blurBottom = 4;
//			blurLeft = 6;
//			blurRight = 5;
//			_contentX = blurLeft;
//			_contentY = blurTop;
//		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_textField = UIFactory.gTextField("",75,67,150,20,this,null,true);
			//_textField.htmlText = "<font color='#ffffff' size='13'>" + Language.getString(30025) + "</font>";
			_textField.text = "请输入交易数量："
			
			_textInput = UIFactory.gTextInput(80,93,133,24,this);
			_textInput.restrict="0-9";
			_textInput.text="1";
			_textInput.configEventListener(Event.CHANGE,onInputChange);
			
			_btnOK = UIFactory.gButton("确定",75,180,47,22,this);
			_btnOK.configEventListener(MouseEvent.CLICK, SplitHandler);
			
			_btnCancel = UIFactory.gButton("取消",175,180,47,22,this);
			_btnCancel.configEventListener(MouseEvent.CLICK, CloseHandler);
			
			updateViewByData();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
				
			_textField.dispose(isReuse);
			_textInput.dispose(isReuse);
			_btnOK.dispose(isReuse);
			_btnCancel.dispose(isReuse);
			
			_textField = null;
			_textInput = null;
			_btnOK = null;
			_btnCancel = null;
		}
		
		public function updateViewByData():void
		{
			_textInput.text = TradeModule._selectingNumItem.itemAmount.toString();
		}
		
		private function onInputChange(e:Event):void
		{
			// TODO Auto Generated method stub
			if(TradeModule._selectingNumItem == null)
			{
				return;
			}
			
			if(int(_textInput.text) > TradeModule._selectingNumItem.itemAmount)
			{
				_textInput.text = TradeModule._selectingNumItem.itemAmount.toString();
			}
			
			if(int(_textInput.text) < 1)
			{
				_textInput.text = "1";
			}
		}
		
		private function SplitHandler(e:MouseEvent):void
		{
			var num:int=int(_textInput.text);
			
			if(TradeModule._selectingNumItem == null)
			{
				this.hide();
				return;
			}
			
			if (num > 0 && num <= TradeModule._selectingNumItem.serverData.itemAmount)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.TradeSelectNumOver,num));
				this.hide();
			}
			else
			{
				MsgManager.showRollTipsMsg("请输入正确的数量");
			}
		}
		
		private function CloseHandler(e:MouseEvent):void
		{
			this.hide();
		}
	}
}