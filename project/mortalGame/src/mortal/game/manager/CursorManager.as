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
	import com.gengine.ui.timer.CountDownTimer;
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import mortal.game.resource.ImagesConst;

	public class CursorManager
	{
		public static const FIX:String=ImagesConst.Fix;
		public static const BUY:String=ImagesConst.Buy;
		public static const SELL:String=ImagesConst.Sell;
		public static const BATCH:String="batch";
		public static const Skill:String="Skill";
		public static const AddFriend:String = "buy";
		public static const Attack:String = "Attack";
		public static const Talk:String = "Talk";
		public static const Hand:String = "Hand";
		public static const Zoom:String = "Zoom";
		public static const Soul:String = "Soul";
		public static const UnSoul:String = "UnSoul";
		public static const PointMask:String = "PointMask";
		public static const PetMingEat:String = "PetMingEat";
		public static const PetMingLock:String = "PetMingLock";
		public static const PetMingUnLock:String = "PetMingUnLock";
		public static const Palm:String = "Palm";//手掌
		public static const Fist:String = "Fist";//拳头
		public static const NO_CURSOR:String = "NO_CURSOR";
		
		private  static var _currentCurSorType:String = NO_CURSOR;
		
		private static var _cursor:CursorManagerImpl = CursorManagerImpl.instance;
		
		public function CursorManager()
		{
			
		}
		
		public static function init( stage:Stage ):void
		{
			if( _cursor.parent is Stage ) return;
			
			stage.addChild(_cursor);
		}
		
		/**
		 *显示鼠标 
		 * @param cursorStyle:String 鼠标样式名称，从swf文件中加载
		 * 
		 */		
		public static function showCursor(cursorStyle:String=""):void
		{
			if( cursorStyle == CursorManagerImpl.cursorStyle)
			{
				hideCursor();
				return;
			}
			else
			{
				if(cursorStyle != Skill && cursorStyle != PointMask && isSkill())
				{
					return;	
				}
				CursorManagerImpl.cursorStyle = cursorStyle;
			}
			trace(cursorStyle,"manager");
		}
		
		public static function isSkill():Boolean
		{
			return (isCursorStyle(Skill) || isCursorStyle(PointMask));
		}
		
		/**
		 *隐藏鼠标 
		 * 
		 */		
		public static function hideCursor():void
		{
			CursorManagerImpl.cursorStyle = "NO_CURSOR";
		}

		public static function get cursor():CursorManagerImpl
		{
			return _cursor;
		}
		
		/**
		 * 返回当前的样式 
		 * @param cursorStyle
		 * @return 
		 * 
		 */
		public static function isCursorStyle(cursorStyle:String):Boolean
		{
			return cursorStyle == CursorManagerImpl.cursorStyle;
		}
		
		/**
		 * 设置滤镜 
		 * @param filters
		 * 
		 */
		public static function addFilters(filters:Array):void
		{
			cursor.addFilters(filters);
		}
		
		/**
		 * 擦出滤镜 
		 * 
		 */
		public static function clearFilters():void
		{
			cursor.clearFilters();
		}
		
		public static function get currentCurSorType():String
		{
			return _currentCurSorType;
		}
		
		public static function set currentCurSorType(type:String):void
		{
			if(_currentCurSorType == type)
			{
				_currentCurSorType = NO_CURSOR
				return;
			}
			_currentCurSorType = type;
		}
	}
}