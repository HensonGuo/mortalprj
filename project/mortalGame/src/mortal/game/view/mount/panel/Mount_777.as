package mortal.game.view.mount.panel
{
	import com.gengine.core.frame.FrameTimer;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mortal.common.pools.BitmapDataPool;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class Mount_777 extends GSprite
	{
		public static const Str:String = "Str";   //文本
        public static const BitMap:String = "BitMap";  //图片
		
		//==========================
		
		//数据
        private var _boxVec:Vector.<Box_777>;  //放置竖条
		
		private var _maskBitmap:GBitmap;
		
		/**有几列停止了 */	
		private var _endNum:int;
		
		//属性
		/**横间隔 */	
		public var horizontalGap:Number = 0;  //横宽
		
		/**竖间隔*/		
		public var verticalGap:Number = 0;  //竖宽
		
		/**显示宽度 */		
		public var showWide:Number = 0;  
		
		/**显示高度 */	
		public var showHight:Number = 0;
		
		/**列数 */	
		public var horNum:int = 3;
		
		public var isRuning:Boolean;
		
		
		public function Mount_777()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_boxVec = new Vector.<Box_777>;
			
			_maskBitmap = UIFactory.gBitmap("",0,3,this);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			this.mask = null;
			_maskBitmap.dispose(isReuse);
			_maskBitmap = null;
			
			horizontalGap = 0;
			verticalGap = 0;
			showWide = 0;
			showHight = 0;
			
			resetData();
			isRuning = false;
		}
		
		private function resetData():void
		{
			for each(var i:Box_777 in _boxVec)
			{
				i.dispose(true);
			}
			_boxVec.length = 0;
		}
		
		/**
		 *  
		 * @param type  类型
		 * @param horNum  列数
		 * @param arr 标签数据
		 * 
		 */
		public function setData( arr:Array, horNum:int = 3 , type:String = "BitMap" ):void
		{
			resetData();
			isRuning = false;
			this.horNum = horNum;
			var box:Box_777;
			_maskBitmap.bitmapData = BitmapDataPool.getMaskBitmapData(showWide,showHight);
			this.mask = _maskBitmap;
			
			for(var n:int ; n < horNum ; n++)
			{
				box = UICompomentPool.getUICompoment(Box_777);
				box.verticalGap = verticalGap;
				box.x = n*(horizontalGap);
				this.addChild(box);
//				this.pushUIToDisposeVec(box);
				
				box.setData(arr,type);
				box.configEventListener("Mount_777Event",runEnd);
				_boxVec.push(box);
			}
		}
		
		private function runEnd(e:Event):void
		{
			_endNum ++;
			if(_endNum == horNum)
			{
				dispatchEvent(new Event("Mount777End"));
				isRuning = false;
			}
		}
		
		public function startRuning(arr:Array):void
		{
			_endNum = 0;
			for(var i:String in arr)
			{
				var type:String = int(i)%2 == 0? "Up":"Down";
				_boxVec[i].starRuning(arr[i],type);
			}
			isRuning = true;
		}
		
	}
}