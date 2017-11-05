package com.mui.manager
{
	import com.gengine.global.Global;
	import com.mui.controls.GSprite;
	
	import flash.events.Event;

	/**
	 * 实现tooltip容器 
	 * @author jianglang
	 * 
	 */	
	public class ToolTipSprite extends GSprite implements IToolTipItem
	{
		public function ToolTipSprite()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}
		
		protected function judgeToolTip(e:Event = null):void
		{
			if(e && e.type == Event.ADDED_TO_STAGE && toolTipData 
				|| !e && toolTipData && Global.stage.contains(this))
			{
				ToolTipsManager.register(this);
			}
			else
			{
				ToolTipsManager.unregister(this);
			}
		}
		
		protected var _toolTipData:*;
		
		/**
		 * 
		 * @return 
		 */
		public function get toolTipData():*
		{
			return _toolTipData;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set toolTipData(value:*):void
		{
			_toolTipData = value;
			judgeToolTip();
		}
	}
}