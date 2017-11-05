package mortal.game.view.pack.social
{
	import com.gengine.global.Global;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.component.window.SmallWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.NumInput;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.mvc.core.Dispatcher;
	
	public class BulkUseWin extends SmallWindow
	{
		private var _propItem:BaseItem;
		
		private var _textField:GTextFiled;
		
		private var _numInput:NumInput;
		
		private var _btnOK:GButton;
		
		private var _btnCancel:GButton;
		
		private var _callback:Function;
		
		private static var _itemData:ItemData;
		
		private static var _instance:BulkUseWin;
		
		public function BulkUseWin()
		{
			this.setSize(240,145);
			_instance.title = Language.getString(30030);
			if( _instance != null )
 			{
				throw new Error(" BulkUseWin 单例 ");
			}
		}
		
		public static function get instance():BulkUseWin
		{
			if(_instance == null)
			{
				_instance = new BulkUseWin();
			}
			
			return _instance;
		}
		
		public function showWin(itemData:ItemData, callback:Function):void
		{
			_itemData = itemData;
			
			_instance._callback = callback;
			_instance.show();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_propItem = UICompomentPool.getUICompoment(BaseItem);
			_propItem.createDisposedChildren();
			_propItem.setSize(36,36);
			_propItem.move(25,46);
			_propItem.amount = 1;
			this.addChild(_propItem);
			
			_textField = UIFactory.gTextField("",73,42,150,20,this,null,true);
			_textField.htmlText = "<font color='#ffffff' size='13'>" + Language.getString(30031) + "</font>";

			_numInput = UIFactory.numInput(80,68,this,1,_itemData.serverData.itemAmount);
			_numInput.maxNum = _itemData.serverData.itemAmount;
			_numInput.height = 20;
			
			_btnOK = UIFactory.gButton(Language.getString(30026),45,95,49,28,this);
			_btnOK.configEventListener(MouseEvent.CLICK, bulkHandler);
			
			_btnCancel = UIFactory.gButton(Language.getString(30027),145,95,49,28,this);
			_btnCancel.configEventListener(MouseEvent.CLICK, CloseHandler);
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_propItem.dispose(isReuse);
			_textField.dispose(isReuse);
			_btnOK.dispose(isReuse);
			_btnCancel.dispose(isReuse);
			
			_propItem = null;
			_textField = null;
			_btnOK = null;
			_btnCancel = null;
			
			
		}
		
		private function bulkHandler(e:MouseEvent):void
		{
			var num:int = _numInput.currentNum;
			if (num > 0 && num <= _itemData.serverData.itemAmount)
			{
				if(_callback != null)
				{
					_callback(_itemData,num);
				}
				else
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_BulkUse, {itemData:_itemData, amount:num}));
				}
				this.hide();
			}
		}
		
		private function CloseHandler(e:MouseEvent):void
		{
			this.hide();
		}
	}
}