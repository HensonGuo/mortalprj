package mortal.game.view.market.buyAndQiugou
{
	import com.gengine.debug.Log;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import fl.data.DataProvider;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 市场购买list
	 * @author lizhaoning
	 */
	public class MktBuyList extends GSprite
	{
		private var _titleRightBg:ScaleBitmap;
		private var _txtItemName:GTextFiled;
		private var _txtLevel:GTextFiled;
		private var _txtunitPrice:GTextFiled;
		private var _txtTotalPrice:GTextFiled;
		private var _txtAction:GTextFiled;
		private var _itemList:GTileList;
		private var _btnSortUp:GLoadedButton;
		private var _btnSortDown:GLoadedButton;
		
		public function MktBuyList()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			var _tfAnjin:GTextFormat = GlobalStyle.textFormatAnjin;
			_titleRightBg = UIFactory.bg(1,1,470,25,this,"RegionTitleBg");
			_txtItemName = UIFactory.textField("物品名称",61,3,60,20,this,_tfAnjin);
			_txtLevel = UIFactory.textField("等级",169,3,30,20,this,_tfAnjin);
			_txtunitPrice = UIFactory.textField("单价",231,3,30,20,this,_tfAnjin);
			_txtTotalPrice = UIFactory.textField("总价",331,3,30,20,this,_tfAnjin);
			_txtAction = UIFactory.textField("操作",421,3,30,20,this,_tfAnjin);
			
			_btnSortUp = UIFactory.gLoadedButton(ImagesConst.ascendingSortBtn_upSkin,265,8,11,14,this);
			_btnSortDown = UIFactory.gLoadedButton(ImagesConst.descendingSortBtn_upSkin,278,8,11,14,this);
			
			_itemList = UIFactory.tileList(1,25,474,354,this);
			_itemList.rowHeight = 50;
			_itemList.columnWidth = 460;
			_itemList.rowCount  = 7;
			_itemList.horizontalGap = 0;
			_itemList.verticalGap = 0;
			_itemList.setStyle("cellRenderer", MktBuyListItem);
			
			_btnSortUp.configEventListener(MouseEvent.CLICK, onMouseClick);
			_btnSortDown.configEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(e.currentTarget == _btnSortUp)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MarketClickSortUp));
			}
			if(e.currentTarget == _btnSortDown)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MarketClickSortDown));
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_titleRightBg.dispose(isReuse);
			_txtItemName.dispose(isReuse);
			_txtLevel.dispose(isReuse);
			_txtTotalPrice.dispose(isReuse);
			_txtAction.dispose(isReuse);
			_itemList.dispose(isReuse);
			
			
			_titleRightBg = null;
			_txtItemName = null;
			_txtLevel = null;
			_txtTotalPrice = null;
			_txtAction = null;
			_itemList = null;
		}
		
		public function update():void
		{
			var arr:Array = Cache.instance.market.marketItemObj.marketItems;
			this._itemList.dataProvider = new DataProvider(arr);
			this._itemList.drawNow();
		}
	}
}