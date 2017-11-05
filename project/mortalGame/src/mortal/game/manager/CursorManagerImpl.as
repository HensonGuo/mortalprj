/**
 * 鼠标管理
 * @date	2011-3-11 下午05:20:29
 * @author shiyong
 * 
 */

package mortal.game.manager
{
	import Framework.Util.Exception;
	
	import com.gengine.global.Global;
	import com.mui.controls.GBitmap;
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	import mortal.game.Game;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;

	public class CursorManagerImpl extends Sprite
	{
		
		private static var _cursorStyle:String;
		
		private static var _currentContainer:GBitmap;
		
		private static var _instance:CursorManagerImpl;
		
		public function CursorManagerImpl()
		{
			if( _instance != null )
			{
				throw new Error(" CursorManagerImpl 单例 ");
			}
		
		}
		
		public static function get instance():CursorManagerImpl
		{
			if(_instance == null)
			{
				_instance = new CursorManagerImpl();
				_instance.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			}
			
			return _instance;
		}
		
		private static function addedToStageHandler(event:Event):void
		{
			_instance.mouseChildren=false;
			_instance.mouseEnabled=false;
			cursorStyle = CursorManager.NO_CURSOR;
			trace("aa");
		}
		
		private static function onMouseMoveHandler(event:Event):void
		{
			if(_currentContainer && _instance.contains(_currentContainer))
			{
				var ponit:Point = _instance.localToGlobal(new Point(0,0));
				_currentContainer.x = ponit.x + _instance.mouseX;//event.stageX;
				_currentContainer.y = ponit.y + _instance.mouseY;
			}
		}
		
		public function dispose():void
		{
			
		}
		
		
		public static function get cursorStyle():String
		{
			return _cursorStyle;
		}
		
		public  static function set cursorStyle(value:String):void
		{
			_cursorStyle = value;
			if( _cursorStyle == CursorManager.NO_CURSOR )
			{
				if(_currentContainer && _instance.contains(_currentContainer))
				{
					_currentContainer.dispose(true);
					_currentContainer = null;
				}
				_instance.clearFilters();
				Mouse.show();//显示鼠标
				Global.stage.removeEventListener(Event.ENTER_FRAME, onMouseMoveHandler);
			}
			else
			{
				if( _cursorStyle == CursorManager.PointMask)
				{
//					_currentMC = Game.scene.pointMask;
//					_currentMC.gotoAndStop(0);
				}
				else
				{
					_currentContainer = GlobalClass.getBitmap(value);
				}
				
				if( _instance.contains(_currentContainer) == false )
				{
					_instance.addChild(_currentContainer);
				}
				Mouse.hide();//隐藏鼠标。显示加载进来的图标
				_currentContainer.x = _instance.mouseX;
				_currentContainer.y = _instance.mouseY;
				Global.stage.addEventListener(Event.ENTER_FRAME, onMouseMoveHandler);
			}
		}
		
		public function addFilters(filters:Array):void
		{
			if( _cursorStyle != CursorManager.NO_CURSOR )
			{
				if(_currentContainer)
				{
					_currentContainer.filters = filters;
				}
			}
		}
		
		public function clearFilters():void
		{
			if(_currentContainer)
			{
				_currentContainer.filters = null;
			}
		}
	}
}