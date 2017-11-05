/**
 * @heartspeak
 * 2014-4-15 
 */   	

package mortal.game.manager
{
	import com.gengine.global.Global;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.mvc.core.Dispatcher;

	public class StageMouseManager
	{
		
		public function StageMouseManager()
		{
		}
		
		private static var _instance:StageMouseManager;
		
		public static function get instance():StageMouseManager
		{
			if(!_instance)
			{
				_instance = new StageMouseManager();
			}
			return _instance;
		}
		
		public function start():void
		{
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			Global.stage.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		public function stop():void
		{
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			Global.stage.removeEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onMouseMove(e:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.StageMouseMove,e));
			//处理矩形区域事件
			var length:int = recObjList.length;
			for(var i:int = length - 1;i >= 0;i--)
			{
				var isContain:Boolean = recObjList[i].rec.contains(e.stageX,e.stageY);
				if(isContain && !recObjList[i].isIn)
				{
					if(recObjList[i].overCallBack != null)
					{
						recObjList[i].overCallBack.call(null);
					}
					recObjList[i].isIn = true;
				}
				else if(!isContain && recObjList[i].isIn)
				{
					if(recObjList[i].outCallBack != null)
					{
						recObjList[i].outCallBack.call(null);
					}
					recObjList[i].isIn = false;
				}
			}
		}
		
		protected function onMouseClick(e:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.StageMouseClick,e));
		}
		
		protected var recObjList:Vector.<RecObj> = new Vector.<RecObj>();
		
		/**
		 * 注册矩形区域移入移出事件 
		 * @param rec
		 * @param overCallBack
		 * @param outCallBack
		 * 
		 */		
		public function addRecEvent(rec:Rectangle,overCallBack:Function,outCallBack:Function):void
		{
			var recObj:RecObj = new RecObj(rec,overCallBack,outCallBack);
			recObjList.push(recObj);
		}
		
		/**
		 * 取消注册矩形区域移入移出事件 
		 * @param rec
		 * @param overCallBack
		 * @param outCallBack
		 * 
		 */
		public function removeRecEvent(rec:Rectangle):void
		{
			var length:int = recObjList.length;
			for(var i:int = length - 1;i >= 0;i--)
			{
				if(recObjList[i].rec == rec)
				{
					recObjList.splice(i,1);
				}
			}
		}
	}
}

import flash.geom.Rectangle;

class RecObj
{
	public var rec:Rectangle;
	public var overCallBack:Function;
	public var outCallBack:Function;
	public var isIn:Boolean = false;
	public function RecObj(rec:Rectangle,overCallBack:Function,outCallBack:Function)
	{
		this.rec = rec;
		this.overCallBack = overCallBack;
		this.outCallBack = outCallBack;
	}
}