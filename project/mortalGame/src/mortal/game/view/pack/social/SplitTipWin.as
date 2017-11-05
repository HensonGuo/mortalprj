package mortal.game.view.pack.social
{
	import com.gengine.global.Global;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.component.window.SmallWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class SplitTipWin extends SmallWindow
	{
		private var _textField:GTextFiled;
		
		private var _textInput:GTextInput;
		
		private var _btnOK:GButton;
		
		private var _btnCancel:GButton;
		
		private var _itemData:ItemData;
		
		private static var _instance:SplitTipWin;
		
		public function SplitTipWin()
		{	
			this.setSize(280,210);
			if( _instance != null )
			{
				throw new Error(" SplitTipWin 单例 ");
			}
		}
		
		public static function get instance():SplitTipWin
		{
			if(_instance == null)
			{
				_instance = new SplitTipWin();
			}
			
			return _instance;
		}
		
		public function showWin(itemData:ItemData):void
		{
			this._itemData = itemData;
		
			_instance.show();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_textField = UIFactory.gTextField("",75,67,150,20,this,null,true);
			_textField.htmlText = "<font color='#ffffff' size='13'>" + Language.getString(30025) + "</font>";
			
			_textInput = UIFactory.gTextInput(80,93,133,24,this);
			_textInput.restrict="0-9";
			_textInput.text="1";
			
			_btnOK = UIFactory.gButton(Language.getString(30026),75,180,47,22,this);
			_btnOK.configEventListener(MouseEvent.CLICK, SplitHandler);
			
			_btnCancel = UIFactory.gButton(Language.getString(30027),175,180,47,22,this);
			_btnCancel.configEventListener(MouseEvent.CLICK, CloseHandler);
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
		
		private function SplitHandler(e:MouseEvent):void
		{
			var num:int=int(_textInput.text);
			if (num > 0 && num < _itemData.serverData.itemAmount)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Split, {uid:_itemData.serverData.uid, amount: num}));
				this.hide();
			}
		}
		
		private function CloseHandler(e:MouseEvent):void
		{
			this.hide();
		}
	}
}