package mortal.component.ui
{
	import com.gengine.core.IDispose;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.DisplayObject;
	
	import mortal.common.net.CallLater;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.CDItem;
	import mortal.game.view.common.item.ItemStyleConst;
	
	public class GConsumeBox extends GSprite
	{
		private var _label:GTextFiled;
		
		private var _consumeItems:Vector.<IDispose>;
		
		private var _consumeInfo:Vector.<ConsumeData>;
		
		private var _gapWide:int = 60;
		
		public function GConsumeBox()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_label = UIFactory.gTextField("",0,2,80,20,this);
			
			_consumeItems = new Vector.<IDispose>();
			_consumeInfo = new Vector.<ConsumeData>();
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_label.dispose(isReuse);
			_label = null;
			
			clearBox();
			
			_consumeItems = null;
			_consumeInfo = null;
		}
		
		public function set label(str:String):void
		{
			_label.text = str;
			_label.width = _label.textWidth + 5;
			CallLater.addCallBack(updateView);
		}
		
		/**
		 * 增加一个消耗品 
		 * @param itemCode
		 * @param num
		 * 
		 */		
		public function addItem(itemCode:int,num:int):void
		{
			var consumeData:ConsumeData = new ConsumeData(itemCode,num);
			consumeData.type = ConsumeData.ItemType;
			_consumeInfo.push(consumeData);
			CallLater.addCallBack(updateView);
//			updateView();
		}
		
		/**
		 * 增加一个消耗货币 
		 * @param moneyType  货币类型
		 * @param num
		 * 
		 */		
		public function addMoney(moneyType:int,num:int):void
		{
			var consumeData:ConsumeData = new ConsumeData(moneyType,num);
			consumeData.type = ConsumeData.MoneyType;
			_consumeInfo.push(consumeData);
			CallLater.addCallBack(updateView);
//			updateView();
		}
		
		public function set gapWide(value:int):void
		{
			_gapWide = value;
			CallLater.addCallBack(updateView);
		}
		
		public function get gapWide():int
		{
			return _gapWide;
		}
		
		override protected function updateView():void
		{
			_consumeInfo.sort(sortVec);
			
			clearBox();
			
			var item:BaseItem;
			var num:GTextFiled;
			for (var i:int; i < _consumeInfo.length;i++)
			{
				if(_consumeInfo[i].type == ConsumeData.ItemType)
				{
					item = UICompomentPool.getUICompoment(BaseItem);
					item.setItemStyle(18,ImagesConst.LevelBg,3,5);
					item.itemData = new ItemData(_consumeInfo[i].code);
					item.isDragAble = item.isDropAble = false;
					item.x = i*_gapWide + _label.width + 10;
					this.addChild(item);
					
					num = UIFactory.gTextField("× " + _consumeInfo[i].num,item.x + item.width,2,50,20,this);
				}
				else if(_consumeInfo[i].type == ConsumeData.MoneyType)
				{
					item = UICompomentPool.getUICompoment(BaseItem);
//					item.source = GlobalClass.getBitmap(GameDefConfig.instance.getEPrictUnitImg(_consumeInfo[i].code));
					item.setItemStyle(18,ImagesConst.LevelBg,3,5);
					item.source = GlobalClass.getBitmapData(ImagesConst.JinbiBig);
					item.x = i*_gapWide + _label.width + 10;
					item.toolTipData = GameDefConfig.instance.getEPrictUnitName(_consumeInfo[i].code);
					this.addChild(item);
					
					num = UIFactory.gTextField("× " + _consumeInfo[i].num,item.x + item.width,2,50,20,this);
				}
			    
				_consumeItems.push(num);
				_consumeItems.push(item);
			}
			
		}
		
		protected function clearBox():void
		{
			for each(var i:IDispose in _consumeItems)
			{
				i.dispose(true);
			}
			_consumeItems = new Vector.<IDispose>();
		}
		
		protected function sortVec(a1:ConsumeData,a2:ConsumeData):int
		{
			if(a1.type == ConsumeData.MoneyType)
			{
				return 1;
			}
			else if(a2.type == ConsumeData.ItemType)
			{
			    return -1;	
			}
			
			return 0;
		}
	}
}