package mortal.game.view.forging.renderer
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mortal.common.display.BitmapDataConst;
	import mortal.game.mvc.GameController;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.EquipJewelMatchConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.forging.ForgingModule;
	import mortal.game.view.forging.view.GemItem;
	
	/**
	 * @date   2014-3-29 下午5:33:44
	 * @author dengwj
	 */	 
	public class GemEmbedCellRenderer extends GCellRenderer
	{
		/** 物品数据 */
		private var _itemData:ItemData;
		
		/** 宝石物品 */
		private var _gemItem:GemItem;
		/** 三角图标 */
		private var _qualIcon:GBitmap;
		/** 宝石等级 */
		private var _gemLevel:GTextFiled;
		
		private var _disabledBg:GBitmap;
		
		public function GemEmbedCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this._gemItem = UICompomentPool.getUICompoment(GemItem);
			this._gemItem.createDisposedChildren();
			this.addChild(_gemItem);
			this._qualIcon = UIFactory.gBitmap("",0,0,this);
			this._gemLevel = UIFactory.gTextField("",2,-4,20,20,this);
		}
		
		override public function set data(arg0:Object):void
		{
			var gemData:ItemData;
			_gemItem.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,3,3);
			if(arg0.hasOwnProperty("gemData"))
			{
				gemData = arg0.gemData as ItemData;				
				this._qualIcon.bitmapData = GlobalClass.getBitmapData(ImagesConst.LevelMark);
				this._gemLevel.text       = gemData.itemInfo.itemLevel + "";
				this._gemItem.itemData    = gemData;
				if(arg0.gemType != 0)
				{
					if(arg0.gemType != gemData.itemInfo.type)
					{
						this._gemItem.isUseable = false;
						this._gemItem.isLight   = false;
					}
					else
					{
						this._gemItem.isUseable = true;
						this._gemItem.isLight   = true;
					}
				}
				else
				{
					this._gemItem.isUseable = true;
					this._gemItem.isLight   = true;
				}
			}
			else
			{
				this._gemItem.itemData    = null;
				this._qualIcon.bitmapData = GlobalClass.getBitmapData(BitmapDataConst.AlphaBMD);
				this._gemLevel.text       = "";
				this._gemItem.isUseable   = true;
				this._gemItem.isLight     = false;
			}
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_gemItem.dispose(isReuse);
			_qualIcon.dispose(isReuse);
			_gemLevel.dispose(isReuse);
			
			_gemItem = null;
			_qualIcon = null;
			_gemLevel = null;
		}
	}
}