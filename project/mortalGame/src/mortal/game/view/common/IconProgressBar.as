/**
 * @heartspeak
 * 2014-4-29 
 */   	

package mortal.game.view.common
{
	import com.gengine.global.Global;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.events.DragEvent;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.game.view.common.drag.DragItem;
	import mortal.game.view.common.drag.DragItemEvent;

	public class IconProgressBar extends BaseProgressBar
	{
		protected var _iconBtn:GLoadedButton;
		protected var _isCanDrag:Boolean = false;
		protected var _baseX:Number = 0;
		protected var _baseY:Number = 0;
		protected var _baseHeight:Number = 0;
		
		public function IconProgressBar()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_iconBtn = UIFactory.gLoadedButton("",0,0,-1,-1,this);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			removeDrag();
			_iconBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_iconBtn.dispose(isReuse);
			
			_iconBtn = null;
			super.disposeImpl(isReuse);
		}
		
		/**
		 * 设置icon bitmapData 
		 * @param value
		 * 
		 */
		public function setIconBtnStyle(value:String,width:Number,height:Number):void
		{
			_iconBtn.styleName = value;
			_iconBtn.width = width;
			_iconBtn.height = height;
		}
		
		/**
		 * 是否可以拖动 
		 * @param value
		 * 
		 */
		public function set isCanDrag(value:Boolean):void
		{
			_isCanDrag = value;
			if(_isCanDrag && _iconBtn)
			{
				addDragEvent();
			}
			else
			{
				removeDrag();
			}
		}
		
		/**
		 * 添加drag事件 
		 * 
		 */		
		protected function addDragEvent():void
		{
			_iconBtn.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		private var _mouseStartX:Number;
		private var _iconBaseX:Number;
		
		/**
		 * 开始拖动 
		 * @param e
		 * 
		 */		
		protected function onMouseDown(e:MouseEvent):void
		{
			_mouseStartX = e.stageX;
			_iconBaseX = _iconBtn.x;
			
			Global.stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMove);
		}
		
		/**
		 * 拖动 
		 * @param e
		 * 
		 */		
		protected function onMouseMove(e:MouseEvent):void
		{
			var stageX:Number = e.stageX;
			var currentX:Number = (stageX - _mouseStartX) + _iconBaseX;
			
			var per:Number = _value/_totalValue;
			var maxX:Number = _baseX + _progressWidth;
			currentX = currentX < _baseX?_baseX:currentX;
			currentX = currentX > maxX?maxX:currentX;
			var value:Number = (currentX - _baseX)/(maxX - _baseX) * _totalValue;
			setValue(value,_totalValue);
		}
		
		/**
		 * 停止拖动 
		 * @param e
		 * 
		 */		
		protected function onMouseUp(e:Event):void
		{
			removeDrag();
		}
		
		private function removeDrag():void
		{
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMouseMove);
		}
		
		override public function setProgress(barName:String, isScale:Boolean=true, x:Number=0, y:Number=0, width:int=0, height:int=0):void
		{
			super.setProgress(barName,isScale,x,y,width,height);
			_baseX = x;
			_baseY = y;
			_baseHeight = height;
		}
		
		override protected function drawBar():void
		{
			super.drawBar();
			var per:Number = _value/_totalValue;
			var width:Number = per * _progressWidth;
			var iconX:Number = _baseX + width - _iconBtn.width/2;
			var iconY:Number = _baseY - _iconBtn.height/2 + _baseHeight/2;
			_iconBtn.x = iconX;
			_iconBtn.y = iconY;
		}
	}
}