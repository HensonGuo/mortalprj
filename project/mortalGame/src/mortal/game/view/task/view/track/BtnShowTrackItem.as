package mortal.game.view.task.view.track
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	
	import extend.language.Language;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class BtnShowTrackItem extends GSprite
	{
		private var _openBtn:GLoadedButton;
		private var _closeBtn:GLoadedButton;
		private var _status:int;//当前状态 1=关闭 -1=开启
		
		public function BtnShowTrackItem()
		{
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			buttonMode = true;
			
			_openBtn = UIFactory.gLoadedButton(ImagesConst.SubBtn2_upSkin, 0, 0, 13, 13, this);//new GButton();
			_openBtn.toolTipData = HTMLUtil.addColor(Language.getString(20702),"#ffffff");//"隐藏任务详情"
			
			_closeBtn = UIFactory.gLoadedButton(ImagesConst.SupBtn2_upSkin, 0, 0, 13, 13, this);//new GButton();
			_closeBtn.toolTipData = HTMLUtil.addColor(Language.getString(20703),"#ffffff");//"显示任务详情"
			open();
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_openBtn.dispose(isReuse);
			_openBtn = null;
			_closeBtn.dispose(isReuse);
			_closeBtn = null;
		}
		
		/**
		 * 开启 
		 * 
		 */
		public function open(isDipatchEvent:Boolean=false):void
		{
			if(_closeBtn.parent)
			{
				removeChild(_closeBtn);
			}
			if(!_openBtn.parent)
			{
				addChild(_openBtn);
			}
			_status = -1;
			
			if(isDipatchEvent)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.TaskTraceItemExpand, "open"));
			}
		}
		
		/**
		 * 关闭 
		 * 
		 */
		public function close(isDipatchEvent:Boolean=false):void
		{
			if(_openBtn.parent)
			{
				removeChild(_openBtn);
			}
			if(!_closeBtn.parent)
			{
				addChild(_closeBtn);
			}
			_status = 1;
			
			if(isDipatchEvent)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.TaskTraceItemExpand, "close"));
			}
		}
		
		public function get isClose():Boolean
		{
			return _status == 1;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_closeBtn.width = value;
			_openBtn.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			_closeBtn.height = value;
			_openBtn.height = value;
		}
	}
}