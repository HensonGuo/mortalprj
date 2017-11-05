package mortal.game.view.forging.view
{
	import com.mui.controls.GBitmap;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mortal.common.DisplayUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.TimeEvent;
	import mortal.game.manager.EffectManager;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	
	/**
	 * 宝石基类
	 * @date   2014-3-28 上午11:40:19
	 * @author dengwj
	 */	 
	public class GemItem extends BaseItem
	{
		private var _disabledBg:ScaleBitmap;
		
		private var _lightBg:ScaleBitmap;
		
		private var _isUseable:Boolean;
		
		public function GemItem()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.source = GlobalClass.getBitmap(ImagesConst.GemStrengthen);
			this._disabledBg = UIFactory.bg(0,0,width,height,this,ImagesConst.PackDisable);
			this._disabledBg.visible = false;
			
		}
		
		public function set isOpened(value:Boolean):void
		{
			if(value)
			{
				this.source = GlobalClass.getBitmap(ImagesConst.GemStrengthen);
			}
			else
			{
				this.source = GlobalClass.getBitmap(ImagesConst.StrengOpenIcon);
			}
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(value)
			{
				this._bitmap.filters = [FilterConst.colorGlowFilter(0xffff00)];
			}
			else
			{
				this._bitmap.filters = [];
			}
		}
		
		/**
		 * 设置宝石是否可镶嵌 
		 * @param value
		 */		
		public function set isUseable(value:Boolean):void
		{
			if(value)
			{
				_disabledBg.visible = false;
				_isUseable          = true;
				this.mouseEnabled   = true;
			}
			else
			{
				_disabledBg.visible     = true;
				_isUseable              = false;
//				this.mouseEnabled       = false;
				this._disabledBg.width  = _width - _paddingLeft * 2;
				this._disabledBg.height = _height - _paddingTop * 2;
				this._disabledBg.x      = _paddingLeft;
				this._disabledBg.y      = _paddingTop;
			}
		}	
		
		public function get isUseable():Boolean
		{
			return this._isUseable;
		}
		
		/**
		 * 设置是否高亮显示 
		 */		
		public function set isLight(value:Boolean):void
		{
			if(value)
			{
				if(!_lightBg)
				{
					_lightBg = UIFactory.bg(-1,-1,44,44,this,ImagesConst.selectedBg);
				}
			}
			else
			{
				DisplayUtil.removeMe(_lightBg);
				_lightBg = null;
			}
		}
		
		/**
		 * 添加闪动滤镜
		 */		
		public function addShakeLight():void
		{
			EffectManager.glowFilterUnReg(this);
			EffectManager.glowFilterReg(this,null,1,10,0,4);
		}
		
		public function clear():void
		{
			this.source = GlobalClass.getBitmap(ImagesConst.GemStrengthen);
			_itemData = null;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_disabledBg.dispose(isReuse);
			if(_lightBg)
			{
				_lightBg.dispose(isReuse);
			}
			
			_disabledBg = null;
			_lightBg    = null;
		}
	}
}