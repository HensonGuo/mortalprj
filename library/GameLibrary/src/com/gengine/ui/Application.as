package com.gengine.ui
{
	import com.gengine.global.Global;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class Application extends Sprite
	{
		public function Application()
		{
			if( stage )
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		private function init(event:Event = null):void
		{
			Global.instance.initStage(this.stage);
			Global.application = this;
			initApp();
		}
		
		protected function initApp():void
		{
			
		}
	}
}