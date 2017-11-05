package mortal.game.view.miniGame.fishing
{
	import com.gengine.core.IDispose;
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	import mortal.game.events.TimeEvent;
	import mortal.game.scene.modle.SWFPlayer;
	import mortal.game.scene.modle.data.ModelType;
	import mortal.game.view.miniGame.MiniGameActionObject;
	import mortal.game.view.miniGame.MiniGameObject;
	import mortal.game.view.miniGame.fishing.Obj.Fish;
	
	public class FishingScene extends Sprite implements IDispose
	{
		protected var objList:Vector.<MiniGameObject>;
		protected var timer:FrameTimer;
		
		//游戏区域
		public static var AREAWIDTH:Number = 600;
		public static var AREAHEIGHT:Number = 400;
		
		public function FishingScene()
		{
			super();
			init();
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		private function init():void
		{
			graphics.beginFill(0x00ffffff,0.01);
			graphics.drawRect(0,0,FishingScene.AREAWIDTH,FishingScene.AREAHEIGHT);
			graphics.endFill();
				
			addSWFPlayer("bubble.swf",80,215);
			addSWFPlayer("bubble.swf",200,200);
//			setTimeout(function a():void{addSWFPlayer("bubble.swf",200,200);},1500);
			addSWFPlayer("bubble.swf",360,200);
//			setTimeout(function a():void{addSWFPlayer("bubble.swf",660,200);},1500);
			addSWFPlayer("bubble.swf",660,200);
			addSWFPlayer("bgFish1.swf",340,150);
			addSWFPlayer("bgFish2.swf",165,170);
			addSWFPlayer("bgFish1.swf",360,160);
			addSWFPlayer("bgFish2.swf",185,170);
			addSWFPlayer("bgFish2.swf",270,160);
			addSWFPlayer("grass1.swf",630,190);
			addSWFPlayer("grass2.swf",488,180);
			addSWFPlayer("grass3.swf",200,185);
			
			objList = new Vector.<MiniGameObject>();
			
			timer = new FrameTimer();
			timer.addListener(TimerType.ENTERFRAME,render);
		}
		
		/**
		 * 添加一个静态显示SWF 
		 * @param url
		 * @param x
		 * @param y
		 * 
		 */		
		private function addSWFPlayer(url:String,x:Number,y:Number):void
		{
			var sp:Sprite = new Sprite();
			sp.mouseChildren = false;
			sp.mouseEnabled = false;
			var swfPlayer:SWFPlayer = new SWFPlayer();
			swfPlayer.load(url,ModelType.Skill,null);
			sp.addChild(swfPlayer);
			sp.x = x;
			sp.y = y;
			this.addChild(sp);
		}
		
		/**
		 * 渲染 
		 * @param timer
		 * 
		 */		
		private function render(timer:FrameTimer):void
		{
			for each(var obj:MiniGameObject in objList)
			{
				obj.Do();
				if(obj is Fish)
				{
					if(obj.x < -1 * obj.width || obj.x > AREAWIDTH || obj.y < -1 *　obj.height || obj.y > AREAHEIGHT)
					{
						delObject(obj);
					}
				}
			}
		}
		
		/**
		 * 添加游戏对象 
		 * @param gameObject
		 * 
		 */		
		public function addObject(gameObject:MiniGameObject):void
		{
			if(objList.indexOf(gameObject) >= 0)
			{
				return;
			}
			objList.push(gameObject);
			addChild(gameObject);
		}
		
		/**
		 * 删除游戏对象 
		 * @param gameObject
		 * 
		 */
		public function delObject(gameObject:MiniGameObject):void
		{
			var index:int = objList.indexOf(gameObject);
			if(index >= 0)
			{
				objList.splice(index,1);
			}
			if(gameObject.parent && gameObject.parent == this)
			{
				removeChild(gameObject);
			}
			gameObject.dispose();
		}
		
		/**
		 * 添加一个特效 
		 * @param swfPlayer
		 * 
		 */		
		public function addEffect(swfPlayer:SWFPlayer,x:Number = 0,y:Number = 0):void
		{
			swfPlayer.move(x,y);
			this.addChild(swfPlayer);
		}
		
		/**
		 * 释放一个特效 
		 * @param swfPlayer
		 * 
		 */		
		public function disposeEffect(swfPlayer:SWFPlayer):void
		{
			swfPlayer.dispose();
		}
		
		/**
		 * 开始
		 * 
		 */		
		public function start():void
		{
			timer.start();
		}
		
		/**
		 * 停止 
		 * 
		 */		
		public function stop():void
		{
			timer.stop();
		}
		
		/**
		 * 拿到场景里面所有对象 
		 * @return 
		 * 
		 */		
		public function get allObject():Vector.<MiniGameObject>
		{
			return objList;
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function dispose(isReuse:Boolean=true):void
		{
			for each(var obj:MiniGameObject in objList)
			{
				delObject(obj);
			}
			timer.stop();
			timer = null;
		}
	}
}