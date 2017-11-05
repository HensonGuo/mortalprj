package mortal.game.view.miniGame.fishing
{
	import com.gengine.core.IDispose;
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mortal.common.pools.BitmapDataPool;
	import mortal.game.events.DataEvent;
	import mortal.game.view.miniGame.fishing.Obj.Fish;
	import mortal.game.view.miniGame.fishing.Obj.FishActionObject;
	import mortal.game.view.miniGame.fishing.Obj.Hook;
	import mortal.game.view.miniGame.fishing.ObjController.HookAutoSwingController;
	import mortal.game.view.miniGame.fishing.ObjController.HookController;
	import mortal.game.view.miniGame.fishing.defin.FishDirection;

	public class FishingGame extends Sprite implements IDispose
	{
		private var _fishScene:FishingScene;
		private var _timer:SecTimer;
		
		public function FishingGame(iWidth:Number,iHeight:Number)
		{
			super();
			FishingScene.AREAWIDTH = iWidth;
			FishingScene.AREAHEIGHT = iHeight;
			init();
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		private function init():void
		{
			//初始化场景
			_fishScene = new FishingScene();
			this.addChild(_fishScene);

			FishingGlobal.scene = _fishScene;

			//添加蒙版
			var mask:Bitmap = new Bitmap( BitmapDataPool.getMaskBitmapData(FishingScene.AREAWIDTH ,FishingScene.AREAHEIGHT) );
//			mask.graphics.beginFill(0xdddddd);
//			mask.graphics.drawRect(0,0,FishingScene.AREAWIDTH,FishingScene.AREAHEIGHT);
//			mask.graphics.endFill();
			this.addChild(mask);
			_fishScene.mask = mask;
			
			//添加鱼钩
			var hookController:HookAutoSwingController = new HookAutoSwingController();
			var hook:Hook = new Hook(hookController);
			hook.x = FishingScene.AREAWIDTH/2;
			hook.y = 0;
			_fishScene.addObject(hook);
			
			//定时添加对象
			_timer = new SecTimer(1);
			_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			
			FishDispatcher.addEventListener( FishingEventName.FishSquib,onFishSquib);
		}

		/**
		 * 爆炸特效 
		 * @param e
		 * 
		 */		
		private function onFishSquib(e:DataEvent):void
		{
			var point:Point = e.data as Point;
			_fishScene.addEffect(FishFactory.getSquibPlayer(),point.x,point.y);
		}
		
		/**
		 * 定时添加鱼，障碍物等各类对象 
		 * @param timer
		 * 
		 */		
		private function onEnterFrame(timer:SecTimer):void
		{
			var obj:FishActionObject = FishFactory.randomObj();
//			var fish:Fish = FishFactory.randomFish();
//			var scale:Number = Math.random();
//			scale = scale < 0.5?0.5:scale;
//			fish.scaleX = scale;
//			fish.scaleY = scale;
			if(obj.horizontalDirection == FishDirection.LEFT)
			{
//				if(obj.swfPlayer.scaleX == -1)
//				{
//					trace(obj.swfPlayer.url);	
//				}
				obj.x = FishingScene.AREAWIDTH;
			}
			else
			{
				obj.x = -1 * obj.width;
			}
			obj.y = obj.minDepth + Math.random() * (obj.maxDepth - obj.minDepth);
			_fishScene.addObject(obj);
		}
		
		/**
		 * 开始游戏 
		 * 
		 */		
		public function start():void
		{
			_timer.start();
			_fishScene.start();
		}
		
		/**
		 * 暂停或者停止游戏 
		 * 
		 */		
		public function stop():void
		{
			_timer.stop();
			_fishScene.stop();
		}
		
		/**
		 * 销毁游戏 
		 * 
		 */		
		public function dispose(isReuse:Boolean=true):void
		{
			_timer.stop();
			_fishScene.dispose();
			this.removeChild(_fishScene);
			_fishScene = null;
			_timer = null;
		}
	}
}