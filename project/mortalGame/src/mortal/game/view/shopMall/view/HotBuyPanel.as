package mortal.game.view.shopMall.view
{
	import Message.DB.Tables.TShop;
	import Message.DB.Tables.TShopSell;
	import Message.Game.SPanicBuyItemMsg;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.text.TextFieldAutoSize;
	
	import mortal.common.global.GlobalStyle;
	import mortal.common.net.CallLater;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ConfigCenter;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.configBase.ConfigConst;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.view.common.SecTimerCountView;
	import mortal.game.view.common.SecTimerView;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	
	public class HotBuyPanel extends ShopCommonPanel
	{
		private var _PanicBuyList:GTileList;  //团购列表
		
		private var _advBox:AddvertismentPanel;    //广告位置
		
		private var _testBm:GBitmap;
		
		private var _leftTime:SecTimerView; //倒计时
		
		public function HotBuyPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.AdvPic,0,0,this));
			this.pushUIToDisposeVec(UIFactory.bg(438,-5,247,435,this,ImagesConst.LimitBuyBg));
			this.pushUIToDisposeVec(UIFactory.bg(454,40,215,33,this,ImagesConst.SelectBg));
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.LimitBuy,448,4,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30071),480,45,80,20,this,GlobalStyle.textFormatHuang));
			
			
			_goodsList.x = 1;
			_goodsList.y = 214;
			_goodsList.setSize(450, 220);
			_goodsList.columnWidth = 220;
			_goodsList.rowHeight = 105;
			_goodsList.horizontalGap = 1;
			_goodsList.verticalGap = 2;
			_goodsList.setStyle("cellRenderer", GoodsCellRenderer);
			addChild(_goodsList);
			_goodsList.isCanSelect = false;
			
			_PanicBuyList = UIFactory.tileList(453,79,220,390,this);
			_PanicBuyList.columnWidth = 220;
			_PanicBuyList.rowHeight = 105;
			_PanicBuyList.horizontalGap = 1;
			_PanicBuyList.verticalGap = 8;
			_PanicBuyList.setStyle("cellRenderer", PanicItemCellRenderer);
			_PanicBuyList.isCanSelect = false;
			
			_leftTime = UIFactory.secTimeView(Language.getString(30055),555,45,0,0,this,GlobalStyle.textFormatHuang);
			_leftTime.autoSize = TextFieldAutoSize.LEFT;
			_leftTime.mouseEnabled = false;
			_leftTime.configEventListener(EventName.SecViewTimeChange,onSecViewTimeChangeHandler);
			updateLeftTime();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_leftTime.stop();
			
			_PanicBuyList.dispose(isReuse);
			_leftTime.dispose(isReuse);
//			_goodsList.dispose(isReuse);   //这个在父类里面已经有了
			
			_PanicBuyList = null;
			_leftTime = null;
//			_goodsList = null;
			
			super.disposeImpl(isReuse);
		}
		
		/**
		 *剩余时间改变 
		 * @param e
		 * 
		 */		
		private function onSecViewTimeChangeHandler(e:DataEvent):void
		{
			var leftTime:int = e.data as int;
			if(leftTime == 0)
			{
				if(this.contains(_leftTime))
				{
					this.removeChild(_leftTime);
				}
			}
		}
		
		
		
		private function getPanicBuyDataProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var items:Array = Cache.instance.shop.panicList;
			
			for(var i:int ; i < items.length ; i ++)
			{
				var obj:Object = {"data":items[i]};
				dataProvider.addItem(obj);
			}
			return dataProvider;
		}
		
		/**
		 * 获取抢购商品 
		 * 
		 */		
		public function getPanicItems():void
		{
			_PanicBuyList.dataProvider = getPanicBuyDataProvider();
		}
		
		/**
		 * 更新时间 
		 * 
		 */		
		public function updateLeftTime():void
		{
			var cdData:CDData = Cache.instance.cd.getCDData("PanicCd",CDDataType.backPackLock) as CDData;;
			var leftSeconds:int;
			if(cdData)
			{
				leftSeconds = cdData.leftTime/1000;
				if(leftSeconds > 3600)
				{
					_leftTime.setParse(Language.getString(30055));//hh时mm分ss秒50068
				}
				else if(leftSeconds < 3600)
				{
					_leftTime.setParse(Language.getString(30056));//mm分ss秒
				}
				_leftTime.setLeftTime(leftSeconds);
			}
			else
			{
				return;
			}
		}
		
	}
}