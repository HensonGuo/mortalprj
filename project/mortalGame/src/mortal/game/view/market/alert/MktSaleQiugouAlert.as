package mortal.game.view.market.alert
{
	import Message.Game.SMarketItem;
	import Message.Game.SMoney;
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GNumericStepper;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.alertwins.CustomAlertWin;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.market.MktModConfig;
	
	/**
	 * 市场，出售求购 弹框
	 * @author lizhaoning
	 */
	public class MktSaleQiugouAlert extends CustomAlertWin
	{
		private var _item:BaseItem;
		private var _numStepper:GNumericStepper;
		private var _txt1:GTextFiled;
		private var _line:ScaleBitmap;
		private var _txt2:GTextFiled;
		
		private var _data:SMarketItem;
		
		public function MktSaleQiugouAlert(stageWidth:Number, stageHeight:Number)
		{
			super(stageWidth, stageHeight);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.dispose();
		}
		
		private function dispose():void
		{
			// TODO Auto Generated method stub
			_data = null;
			
			_item.dispose(true);
			_numStepper.dispose(true);
			_txt1.dispose(true);
			_line.dispose(true);
			_txt2.dispose(true);
			
			_item = null;
			_numStepper = null;
			_numStepper = null;
			_line = null;
			_txt2 = null;
		}
		
		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			
			var _tfBai:GTextFormat = GlobalStyle.textFormatBai;
			_tfBai.align = TextFormatAlign.RIGHT;
			
			_item = UIFactory.getUICompoment(BaseItem,0,0,null);
			_item.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,3,3);
			_txt1 = UIFactory.gTextField("选择出售数量",0,0,100,20,null);
			_numStepper = UIFactory.gNumericStepper(0,0,49,20,null,999,1,"NumericStepper");
			_numStepper.value = 1;
			_numStepper.textField.setStyle("textFormat", _tfBai);
			_numStepper.configEventListener(Event.CHANGE,numSteperChange);
			_line = UIFactory.bg(0,0,270,1,null,ImagesConst.SplitLine);
			_txt2 = UIFactory.gTextField("",0,0,300,20,null);
		//	_txt2.autoSize = TextFieldAutoSize.CENTER;
			
			
			_data = this.extendObj.marketItem as SMarketItem;
			if(_data == null)
			{
				return;
			}
			
			if(_data.code == EPrictUnit._EPriceUnitCoin || _data.code == EPrictUnit._EPriceUnitGold)
			{
				_item.source = GlobalClass.getBitmapData( GameDefConfig.instance.getMoneyBigIcon(_data.code));
				var moneys:SMoney = Cache.instance.role.money;
				if(_data.code == EPrictUnit._EPriceUnitCoin)
				{
					_numStepper.maximum = int(Math.min(_data.amount,moneys.coin)/10000);
				}
				else if(_data.code == EPrictUnit._EPriceUnitGold)
				{
					_numStepper.maximum = Math.min(_data.amount,moneys.gold);
				}
			}
			else
			{
				_item.itemData = getItemData(_data.code);
				var max:int = Math.min(_item.itemData.itemAmount,_data.amount);
				_numStepper.maximum = max;
			}
			
			numSteperChange(null);
		}
		
		private function getItemData(code:int):ItemData
		{
			var items:Array = Cache.instance.pack.backPackCache.getItemsCanSaleByCode(code);
			var max:int = 0;
			var maxIndex:int;
			var itemData:ItemData;
			
			for (var i:int = 0; i < items.length; i++) //取得最大的一组
			{
				itemData = items[i];
				if(itemData.itemAmount > max)
				{
					max = itemData.itemAmount;
					maxIndex =  i;
				}
			}
			return items[maxIndex] as ItemData;
		}
		
		override protected function childrenCreated():void
		{
			// TODO Auto Generated method stub
			super.childrenCreated();
			
			_item.x = 140;
			_item.y = 50;
			prompt.addChild(_item);
			_txt1.x = 80;
			_txt1.y = 105;
			prompt.addChild(_txt1);
			_numStepper.x = 160;
			_numStepper.y = 105;
			prompt.addChild(_numStepper);
			_line.x = 25;
			_line.y = 130;
			prompt.addChild(_line);
			_txt2.x = 0;
			_txt2.y = 132;
			prompt.addChild(_txt2);
			
			if(_data.code == EPrictUnit._EPriceUnitCoin)  //铜币加上万字
			{
				UIFactory.textField("万",212,110,20,20,prompt);
			}
		}
		
		
		private function numSteperChange(e:Event):void
		{
			// TODO Auto Generated method stub
			updateTxt2();
			updateExtendObj();
		}
		
		private function updateTxt2():void
		{
			var str:String  = "出售" + HTMLUtil.addColor(_numStepper.value.toString(),GlobalStyle.yellow);
			if(_data.code == EPrictUnit._EPriceUnitCoin ||
				_data.code == EPrictUnit._EPriceUnitGold)
			{
				if(_data.code == EPrictUnit._EPriceUnitCoin)
				{
					str += "万";
				}
				str += GameDefConfig.instance.getEPrictUnitName(_data.code);
			}
			else
			{
				str += "个"+ItemsUtil.getItemName(new ItemData(_data.code));
			}
			
			str = str + "可获得"+
				HTMLUtil.addColor(String(_data.sellPrice*_numStepper.value),GlobalStyle.yellow)+
				GameDefConfig.instance.getEPrictUnitName(_data.sellUnit);
			
			//"<u><a href='event:1'>查看我的寄售物品</a></u>"
			//"<p align='right' class='title'>align right</p><p align='left' class='body'>align 　　　left</p>"
			str = "<p align='center'>"+ str +"</p>";
			
			_txt2.htmlText = str;
		}
		
		private function updateExtendObj():void
		{
			if(_data.code == EPrictUnit._EPriceUnitCoin)  //铜钱  * 10000
			{
				this.extendObj.amount = this._numStepper.value * 10000;
			}
			else
			{
				this.extendObj.amount = this._numStepper.value;
			}
				
			if(_data.code == EPrictUnit._EPriceUnitCoin || _data.code == EPrictUnit._EPriceUnitGold)
			{
				this.extendObj.uid = "";
			}
			else
			{
				this.extendObj.uid = this._item.itemData.uid;
			}
		}
	}
}