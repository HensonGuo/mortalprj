package mortal.game.view.pet.view
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.ITabBar2Cell;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.shopMall.data.ShopItemData;
	import mortal.mvc.core.Dispatcher;
	
	public class PetSkillBookCellRenderer extends GSprite implements ITabBar2Cell
	{
		private var _bg:ScaleBitmap;
		private var _btnFresh:GLoadedButton;
		private var _labelFresh:GBitmap;
		private var _txtBookName:GTextFiled;
		private var _txtDesc:GTextFiled;
		private var _bastItem:BaseItem;
		private var _bmpGold:GBitmap;
		
		private var _type:String = "";
		private var _data:ItemData;
		
		public function PetSkillBookCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			_bg = UIFactory.bg(0, 0, 165, 74, this, ImagesConst.ChatMenuBg);
			_btnFresh = UIFactory.gLoadedButton(ImagesConst.brownBtn_upSkin, 65, 47, 49, 24, this);
			_btnFresh.configEventListener(MouseEvent.CLICK, onMouseClick);
			_labelFresh = UIFactory.gBitmap(ImagesConst.petSkillFresh, 76, 51, this);
			var txtFmt:GTextFormat = GlobalStyle.textFormatPutong;
			txtFmt.color = GlobalStyle.blueUint;
			_txtBookName = UIFactory.gTextField("宠物宝典", 65, 5, 100, 20, this, txtFmt);
			_txtDesc = UIFactory.gTextField("已刷新：265次", 65, 25, 100, 20, this, GlobalStyle.textFormatItemGreen);
			_bmpGold = UIFactory.gBitmap(ImagesConst.Yuanbao, 92, 31, this);
			_bastItem = UIFactory.getUICompoment(BaseItem,13,16,this);
			_bastItem.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,2,3);
		}
			
		
		public function set selected(value:Boolean):void
		{
		}
		
		public function set data(value:Object):void
		{
			_type = value.type;
			_data = value.data;
			var itemData:ItemData = value.data as ItemData;
			switch(value.type)
			{
				case "fresh":
					_txtBookName.text = itemData.name;
					var freshCount:int = itemData.extInfo == null ? 0 : itemData.extInfo.petSkillRandTime;
					_txtDesc.text = "已刷新：" + freshCount + "次";
					_bastItem.itemData = itemData;
					_labelFresh = UIFactory.gBitmap(ImagesConst.petSkillFresh, 76, 51, this);
					_bmpGold.visible = false;
					break;
				case "buy":
					_txtBookName.text = itemData.name;
					_txtDesc.text = itemData.itemInfo.sellPrice.toString();
					_labelFresh = UIFactory.gBitmap(ImagesConst.petSkillBuy, 76, 51, this);
					_bastItem.itemData = itemData;
					_bmpGold.visible = true;
					break;
			}
		}
		
		public function over():void
		{
		}
		
		public function out():void
		{
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			if (_type == "buy")
			{
				var item:ShopItemData = new ShopItemData(_data.itemCode);
				item.num = 1;
				Dispatcher.dispatchEvent(new DataEvent(EventName.BuyItem , item));
			}
			else
			{
				PetFreshSkillBookPanel.instance.setData(_data);
				PetFreshSkillBookPanel.instance.show();
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_bg.dispose(isReuse);
			_bg = null;
			_btnFresh.dispose(isReuse);
			_btnFresh = null;
			_txtBookName.dispose(isReuse);
			_txtBookName = null;
			_txtDesc.dispose(isReuse);
			_txtDesc = null;
			_bastItem.dispose(isReuse);
			_bastItem = null;
			_bmpGold.dispose(isReuse);
			_bmpGold = null;
		}
	}
}