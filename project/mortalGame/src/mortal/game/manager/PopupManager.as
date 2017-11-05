package mortal.game.manager
{
	import com.gengine.global.Global;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mortal.component.window.Window;
	import mortal.mvc.interfaces.IView;

	public class PopupManager
	{
		public function PopupManager()
		{
			
		}
		
		public static function addPopUp( displayObject:DisplayObject , position:String = "window",modal:Boolean = false ):void
		{
			if( displayObject&& LayerManager.windowLayer.contains(displayObject) == false )
			{
				displayObject.x = (Global.stage.stageWidth - displayObject.width)/2;
				displayObject.y = (Global.stage.stageHeight - displayObject.height)/2;
				
				if(position == "window")
				{
					LayerManager.windowLayer.addChild(displayObject);
				}
				else if(displayObject is IView)
				{
					(displayObject as IView).show();
				}
				_topDisplayObject = displayObject;
				
				if(modal)
				{
					createTempCover(displayObject,0,0,true);
				}
			}
		}
		
		public static function centerPopup( displayObject:DisplayObject ):void
		{
			if( displayObject )
			{
				displayObject.x = (Global.stage.stageWidth - displayObject.width)/2;
				displayObject.y = (Global.stage.stageHeight - displayObject.height)/2;
			}
		}
		
		public static function isTop( displayObject:DisplayObject ):Boolean
		{
			return LayerManager.windowLayer.isTop(displayObject);
		}
		
		public static function removePopup( displayObject:DisplayObject):void
		{
			if( LayerManager.windowLayer.contains(displayObject) )
			{
				LayerManager.windowLayer.removeChild(displayObject);
				if( _topDisplayObject == displayObject ) _topDisplayObject = null;
			}
		}
		
		public static function isPopup( displayObject:DisplayObject  ):Boolean
		{
			return LayerManager.windowLayer.contains(displayObject);
		}
		
		private static var _topDisplayObject:DisplayObject;
		
		public static function setTop( window:Window ):void
		{
			if( _topDisplayObject == window ) return;
			_topDisplayObject = window;
			window.layer.setTop(window);
		}
		
		/**
		 * 显示一个临时的背景遮罩在对象后面作为遮挡，并会和对象一起被删除
		 * 
		 * @param v - 目标
		 * @param color	- 颜色
		 * @param alpha	- 透明度
		 * @param mouseEnabled	- 是否遮挡下面的鼠标事件
		 * 
		 */
		private static function createTempCover(v:DisplayObject,color:uint = 0x0,alpha:Number = 0.5,mouseEnabled:Boolean = false):void
		{
			var parent:DisplayObjectContainer = v.parent;
			//背景遮罩
			var back:Sprite = new Sprite();
			var rect:Rectangle = localRectToContent(new Rectangle(0,0,parent.stage.stageWidth,parent.stage.stageHeight),parent.stage,parent);
			back.graphics.beginFill(color,alpha);
			back.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
			back.graphics.endFill();
			back.mouseEnabled = mouseEnabled;
			back.cacheAsBitmap = true;
			parent.addChildAt(back,parent.getChildIndex(v));
			
			v.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
			function removeHandler(event:Event):void
			{
				parent.removeEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
				if(parent.contains(back))
				{
					parent.removeChild(back);
				}
			}
		}
		
		/**
		 * 转换矩形坐标到某个显示对象
		 * 
		 * @param rect	矩形
		 * @param source	源
		 * @param target	目标
		 * @return 
		 * 
		 */		
		private static function localRectToContent(rect:Rectangle,source:DisplayObject,target:DisplayObject):Rectangle
		{
			if (source == target)
				return rect;
			
			var topLeft:Point = localToContent(rect.topLeft,source,target);
			var bottomRight:Point = localToContent(rect.bottomRight,source,target);
			return new Rectangle(topLeft.x,topLeft.y,bottomRight.x - topLeft.x,bottomRight.y - topLeft.y);
		}
		
		/**
		 * 转换坐标到某个显示对象
		 * 
		 * @param pos	坐标
		 * @param source	源
		 * @param target	目标
		 * @return 
		 * 
		 */		
		public static function localToContent(pos:Point,source:DisplayObject,target:DisplayObject):Point
		{
			if (target && source)
				return target.globalToLocal(source.localToGlobal(pos));
			else if (source)
				return source.localToGlobal(pos);
			else if (target)
				return target.globalToLocal(pos);
			return null;
		}
		
		public static function closeTopWindow():void
		{
			var layer:UILayer = LayerManager.windowLayer;
			var childNum:int = layer.numChildren;
			if( childNum == 0 ) 
			{
				return;
			}
			for(var i:int = childNum - 1;i >= 0;i--)
			{
				var view:IView = layer.getChildAt(i) as IView;
				if(view)
				{
					view.hide();
					break;
				}
			}
		}
	}
}