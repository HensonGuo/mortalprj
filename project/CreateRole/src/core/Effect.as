package core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.GlowFilter;

	public class Effect
	{
		public static const overFilter:GlowFilter = new GlowFilter(0xffff00,1,15);
		public static const downFilter:GlowFilter = new GlowFilter(0xffff00,1,10);
		public static const btnFilter:GlowFilter = new GlowFilter(0xffff00,1,6,6);
		public static const glowFilter:GlowFilter = new GlowFilter(0x000000,1,2,2,10);
		
		private var _target:DisplayObject;
		private var _effectStep:int;
		
		public function Effect()
		{
		}
		
		public function filterEffect(target:DisplayObject,step:int):void
		{
			_target = target
			_effectStep = step;
			_target.addEventListener(Event.ENTER_FRAME,onFilterEffectEnterFrame);
		}
		
		public function effectDispose():void
		{
			_target.removeEventListener(Event.ENTER_FRAME,onFilterEffectEnterFrame);
		}
		
		private function onFilterEffectEnterFrame(event:Event):void
		{
			if(Effect.btnFilter.blurX > 40 || Effect.btnFilter.blurX < 3)
			{
				_effectStep *= -1;
			}
			Effect.btnFilter.blurX += _effectStep;
			Effect.btnFilter.blurY += _effectStep;
			_target.filters = [Effect.btnFilter];
		}
	}
}