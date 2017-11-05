package mortal.game.view.mainUI.roleAvatar
{
	import com.gengine.core.IClean;
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.resource.info.ImageInfo;
	import com.mui.core.GlobalClass;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.model.ToolTipInfo;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.tooltip.TooltipType;
	import mortal.mvc.core.Dispatcher;
	
	public class BuffItem extends BaseItem
	{
		private var _buffInfo:BuffData;
		
		public function BuffItem()
		{
			super();
			this.setSize(17,17);
		}
		
		override public function get toolTipData():*
		{
			if(_buffInfo && _buffInfo.tbuff)
			{
				return new ToolTipInfo(TooltipType.Buff,_buffInfo);
			}
			return null;
		}
		
		/**
		 *Buff详细信息 
		 */
		public function get buffInfo():BuffData
		{
			return _buffInfo;
		}

		/**
		 * 设置显示的Buff信息
		 * @private
		 */
		public function set buffInfo(value:BuffData):void
		{
			_buffInfo = value;
			if(value)
			{
				this.source = value.getIconPath();
			}
			else
			{
				this._bitmap.bitmapData = null;
			}
		}
		
	}
}