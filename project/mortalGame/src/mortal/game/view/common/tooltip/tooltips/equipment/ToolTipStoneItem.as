/**
 * 2014-3-28
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips.equipment
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.resource.info.ImageInfo;
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import extend.language.Language;
	
	import flash.display.BitmapData;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.display.BitmapDataConst;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.manager.EffectManager;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	
	public class ToolTipStoneItem extends GSprite
	{
		private var _bg:GBitmap;
		private var _icon:GBitmap; // 28 * 28
		private var _txtName:GTextFiled;

		private var _txtStatus:GTextFiled;
		
		public function ToolTipStoneItem()
		{
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.gBitmap(ImagesConst.StoneBg, 0, 0, this);
			_icon = UIFactory.gBitmap(null, 2, 2, this);
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.leading = 2;
			_txtName = UIFactory.gTextField("", 32, -2, 95, 40, this, GlobalStyle.textFormatPutong.setLeading(-3));
			_txtName.multiline = true;
			_txtName.wordWrap = true;
			
			_txtStatus = UIFactory.gTextField("", 33, 4, 130, 20, this);
			_txtStatus.filters = [FilterConst.colorFilter];
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bg.dispose(isReuse);
			_icon.dispose(isReuse);
			_txtName.dispose(isReuse);
			_txtStatus.dispose(isReuse);
			
			_bg = null;
			_icon = null;
			_txtName = null;
			_txtStatus = null;
		}
		
		public function set stoneData(data:ToolTipStoneData):void
		{
			if(data.isLocked)
			{
				DisplayUtil.removeMe(_txtName);
				this.addChild(_txtStatus);
				_txtStatus.text = data.openTips;
				_icon.bitmapData = GlobalClass.getBitmapData(ImagesConst.Locked);
				_icon.width = 25;
				_icon.height = 25;
			}
			else if(data.itemData == null)
			{
				DisplayUtil.removeMe(_txtName);
				this.addChild(_txtStatus);
				_txtStatus.text = Language.getString(20203);
				_icon.bitmapData = GlobalClass.getBitmapData(BitmapDataConst.AlphaBMD);//new BitmapData(1,1);
//				_icon.width = 25;
//				_icon.height = 25;
			}
			else if(data.itemData != null)
			{
				this.addChild(_txtName);
				DisplayUtil.removeMe(_txtStatus);
				var str:String = data.itemData.itemInfo.descStr;
				str = str.replace("{name}。", data.itemData.itemInfo.name);
				str = str.replace("{effect}。", data.itemData.itemInfo.effect);
				var color:String = ColorConfig.instance.getItemColorString(data.itemData.itemInfo.color);
				_txtName.htmlText = HTMLUtil.addColor(str, color);
				LoaderManager.instance.load(data.itemData.itemInfo.icon + ".jpg",onLoadCompleteHandler, LoaderPriority.LevelB);
			}
		}
		
		private function onLoadCompleteHandler(info:ImageInfo):void
		{
			if(_icon == null || this.parent == null)
			{
				return;
			}
			_icon.bitmapData = info.bitmapData;
			_icon.width = 24;
			_icon.height = 24;
		}
	}
}