/**
 * @date 2012-11-28 上午11:40:56
 * @author chenriji
 *
 */
package mortal.game.view.common.renderers
{
	import Message.Public.SPlayerItem;
	
	import com.mui.controls.GCellRenderer;
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	
	import mortal.common.DisplayUtil;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.item.BaseItem;
	
	public class PageItemRenderer extends GCellRenderer
	{
		/**
		 * 显示背景框，但是不显示图标
		 */
		public static const NullItem:int = -1;
		
		
		protected var _item:BaseItem;
		
		public function PageItemRenderer()
		{
			super();
			setSize(36, 36);
//			initStyles();
			initItem();
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		
		public override function set data(arg0:Object):void
		{
			super.data = arg0;
			if(arg0 == NullItem)
			{
				DisplayUtil.removeMe(_item);
				return;
			}
			
			this.addChild(_item);
			if( arg0 is SPlayerItem )
			{
				_item.itemData = new ItemData( arg0 );
				this.mouseChildren = true;
			}
			else if(arg0 is int) 
			{
				_item.itemData = new ItemData(int(arg0));
			}
			else 
			{
				_item.itemData = arg0 as ItemData;
			}
		}
		
		public function get item():BaseItem
		{
			return _item;
		}
		
		protected function initItem():void
		{
			var bitmap:Bitmap = GlobalClass.getBitmap(ImagesConst.PackItemBg);
			addChildAt(bitmap,0);
			
			_item = new BaseItem();
			_item.width = 32;
			_item.height = 32;
			_item.isDragAble = false;
			_item.isDropAble = false;
			_item.x = 3;
			_item.y = 3;
			_item.isShowLock = true;
			this.addChild(_item);
		}
		
//		protected function initStyles():void
//		{
//			this.setStyle("downSkin", new Bitmap());
//			this.setStyle("overSkin", new Bitmap());
//			this.setStyle("upSkin",new Bitmap());
//			this.setStyle("selectedDownSkin", new Bitmap());
//			this.setStyle("selectedOverSkin", new Bitmap());
//			this.setStyle("selectedUpSkin", new Bitmap());
//		}
	}
}