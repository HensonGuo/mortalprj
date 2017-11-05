package mortal.game.view.effect
{
	import com.gengine.global.Global;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.game.manager.LayerManager;
	
	public class UIMaskEffect extends Sprite
	{
		/**
		 * 当前遮罩 
		 */
		private var _masks:Array;
		private var _layer:DisplayObjectContainer;
		private var _timeKey:uint;
		private var _maskAlpha:Number = 0.3;
		private var _clickBack:Function;
		
		public function UIMaskEffect()
		{
			super();
			_layer = LayerManager.guideLayer;
			this.addEventListener(MouseEvent.CLICK,onMouseClickHandler);
		}
		
		/**
		 * 鼠标点击事件 
		 * @param event
		 * 
		 */
		private function onMouseClickHandler(event:MouseEvent):void
		{
			if(_clickBack != null)
			{
				_clickBack();
			}
		}
		
		/**
		 * 绘制遮罩 
		 * 
		 */
		private function drawMask():void
		{
			graphics.clear();
			graphics.lineStyle(0,0,0);
			graphics.beginFill(0x000000,_maskAlpha);
			graphics.drawRect(0,0,Global.stage.stageWidth,Global.stage.stageHeight);
		
			if(_masks)
			{
				var mask:MaskInfo;
				for each(mask in _masks)
				{
					switch(mask.shape)
					{
						case MaskInfo.Shape_Cycle:
							graphics.drawCircle(mask.x,mask.y,mask.width);
							break;
						case MaskInfo.Shape_Rect:
							graphics.drawRect(mask.x,mask.y,mask.width,mask.height);
							break;
					}
				}
			}
			
			graphics.endFill();
		}
		
		/**
		 * 蒙版时间到 
		 * 
		 */
		private function onTimeOutHandler():void
		{
			hideMask();
		}
		
		/**
		 * 绘制遮罩 
		 * @param masks
		 * @param daily
		 * @param alpha
		 * @param clickBack 点击的回调函数
		 * 
		 */
		public function showMask(masks:Array,daily:int=10000,alpah:Number = 0.3,clickBack:Function=null):void
		{
			hideMask();
			
			_clickBack = clickBack;
			_masks = masks;
			_maskAlpha = alpah;
			
			drawMask();
		
			_layer.addChild(this);
			
			if(daily > 0)
			{
				_timeKey = setTimeout(onTimeOutHandler,daily);
			}
		}
		
		/**
		 * 隐藏遮罩 
		 * 
		 */
		public function hideMask():void
		{
			_clickBack = null;
			clearTimeout(_timeKey);
			graphics.clear();
			if(_masks)
			{
				_masks.length = 0;
			}
			
			if(_layer.contains(this))
			{
				_layer.removeChild(this);
			}
		}
		
		public function get isHide():Boolean
		{
			return this.parent == null;
		}
		
		/**
		 * 舞台大小改变 
		 * 
		 */
		public function stageResize():void
		{
			if(this.parent)
			{
				drawMask();
			}
		}
	}
}