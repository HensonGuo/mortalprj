/**
 * author hexiaoming 
 */
package mortal.game.view.common.drag
{
	import com.gengine.global.Global;
	import com.mui.controls.GBitmap;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mortal.common.display.BitmapDataConst;
	import mortal.game.manager.CursorManager;
	import mortal.game.view.common.UIFactory;

	public class DragItem extends Sprite
	{
		private var __width:Number;
		private var __height:Number;
		
		private var _bmp:ScaleBitmap;
		
		public function DragItem(width:Number = 250,height:Number = 5)
		{
			__width = width;
			__height = height;
			_bmp = UIFactory.bg(0,0,__width,__height,this,BitmapDataConst.AlphaBMD);
			addListeners();
		}
		
		/**
		 * 设置宽高 
		 * @param width
		 * @param height
		 * 
		 */		
		public function setSize(width:Number,height:Number):void
		{
			__width = width;
			__height = height;
			_bmp.setSize(__width,__height);
			
		}
		
		//鼠标是否在这个对象上按下
		private var _isDown:Boolean;
		//鼠标时候悬乎在这个对象上
		private var _isOver:Boolean;
		//状态是否改变
		private var _isChange:Boolean;
		//开始拖动坐标
		private var _lastDragX:Number;
		private var _lastDragY:Number;
		
		private function addListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseHandler);
			
			this.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
		}
		
		private function onMouseHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					_isOver = true;
					_isChange = true;
					break;
				case MouseEvent.MOUSE_DOWN:
					_isDown = true;
					_isChange = true;
					_lastDragX = Global.stage.mouseX;
					_lastDragY = Global.stage.mouseY;
					this.dispatchEvent(new DragItemEvent(DragItemEvent.StartDrag));
					Global.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseHandler);
					break;
				case MouseEvent.MOUSE_OUT:
					_isOver = false;
					_isChange = true;
					break;
				case MouseEvent.MOUSE_UP:
					_isDown = false;
					_isChange = true;
					Global.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseHandler);
					break;
			}
		}
		
		private function onEnterFrameHandler(e:Event):void
		{
//			if(_isChange)
//			{
//				//鼠标样式
//				if(_isOver || _isDown)
//				{
//					CursorManager.showCursor(CursorManager.Zoom);
//				}
//				else if(!CursorManager.isSkill())
//				{
//					CursorManager.hideCursor();
//				}
//				_isChange = false;
//			}
			
			//设置拖动效果
			if(_isDown)
			{
				var changeX:Number = Global.stage.mouseX - _lastDragX;
				var changeY:Number = Global.stage.mouseY - _lastDragY;
				this.dispatchEvent(new DragItemEvent(DragItemEvent.DragPositionChange,changeX,changeY));
			}
		}
	}
}