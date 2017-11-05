/**
 * @date 2011-3-4 下午02:59:20
 * @author  wangyang
 * 物品冻结效果
 */  
package mortal.game.view.common.cd.effect
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import mortal.common.pools.BitmapDataPool;
	import mortal.game.view.common.cd.ICDData;

	public class CDFreezingEffect extends ItemCD implements ICDEffect
	{
		private var _maskBitmap:Bitmap;
		private var _registed:Boolean = false;
		
		public function CDFreezingEffect()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function set registed(value:Boolean):void
		{
			_registed = value;
		}
		
		public function get registed():Boolean
		{
			return _registed;
		}
		
		public function setMaskSize(w:Number,h:Number):void
		{
			if( _maskBitmap == null )
			{
				_maskBitmap = new Bitmap();
			}
			
			if( _maskBitmap.width != w || _maskBitmap.height !=h )
			{
				_maskBitmap.bitmapData = BitmapDataPool.getMaskBitmapData(w,h)
			}
			_maskBitmap.x = -w/2;
			_maskBitmap.y = -h/2;
			this.addChild(_maskBitmap);
			this.mask = _maskBitmap;
		}

		public function onTimer(frame:int):void
		{
			this.gotoAndStop(frame);
			if(frame > 100)
			{
				reset();
				this.dispatchEvent( new Event(Event.COMPLETE));
			}
		}
		
		public function get cdEffectTimerType():String
		{
			return CDEffectTimerType.Percentage;
		}
		
		public function reset():void
		{
			this.gotoAndStop(1);
		}
	}
}