/**
 * 鱼钩类 
 */
package mortal.game.view.miniGame.fishing.Obj
{
	import com.greensock.TweenLite;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.miniGame.MiniGameActionObject;
	import mortal.game.view.miniGame.MiniGameObject;
	import mortal.game.view.miniGame.fishing.FishDispatcher;
	import mortal.game.view.miniGame.fishing.FishingEventName;
	import mortal.game.view.miniGame.fishing.FishingGlobal;
	import mortal.game.view.miniGame.fishing.FishingScene;
	import mortal.game.view.miniGame.fishing.ObjController.HookController;
	import mortal.game.view.miniGame.fishing.defin.HookState;
	import mortal.mvc.core.Dispatcher;

	public class Hook extends MiniGameActionObject
	{
		private const BaseLength:Number = 20;
		
		protected var _rope:ScaleBitmap;//绳子
		protected var _hook:Bitmap;//钩子
		
		protected var _hookState:String = HookState.swing;//钩子当前状态  值为HookState枚举常量
		protected var _angle:Number = 0;//钩子的角度
		protected var _speed:Number = 0;//鱼钩速度
		protected var _length:Number = 0;//绳子额外伸长长度
		
		protected var _isHitFish:Boolean = false;//时候掉到鱼
		protected var _hookFish:Fish;//掉到的鱼儿
		
		protected var _aryBaseImpactPoints:Array;//碰撞检测的点
		
		public function Hook(ctrl:HookController)
		{
			super(ctrl);
			draw();
		}
		
		private function draw():void
		{
			_rope = new ScaleBitmap();
			_rope = GlobalClass.getScaleBitmap("FishingLine",new Rectangle(0,0,3,143));
			
			_rope.height = BaseLength;
			this.addChild(_rope);
			
			_hook = GlobalClass.getBitmap("Hook");
			_hook.x = -14;
			_hook.y = BaseLength;
			this.addChild(_hook);
			
			_aryBaseImpactPoints = [new Point(0,15),new Point(17,20),new Point(32,15)];
		}
		
		override public function Do():void
		{
			//与鱼儿们判断碰撞
			(controller as HookController).autoRun();
			var isHit:Boolean = false;
			var point:Point;
			//鱼钩不在摇摆阶段。
			if(_hookState != HookState.swing)
			{
				_length += _speed;
				if(_length <= 0)
				{
					_length = 0;
				}
				//在向下移动的时候支持碰撞杀鱼
				if(_hookState == HookState.down)
				{
					outerLoop:for each(var obj:MiniGameObject in FishingGlobal.scene.allObject)
					{
						var aryCurrentPoint:Array = new Array();
						var hookM:Matrix = getHookMatrix();
						for each(point in _aryBaseImpactPoints)
						{
							var currentPoint:Point = new Point();
							currentPoint.x = point.x * hookM.a + point.y * hookM.c + hookM.tx;
							currentPoint.y = point.x * hookM.b + point.y * hookM.d + hookM.ty;
							currentPoint = this.localToGlobal(currentPoint);
							aryCurrentPoint.push(currentPoint);
						}
						if(obj is Fish)
						{
							for each(point in aryCurrentPoint)
							{
								if(obj.hitTestPoint(point.x,point.y))
								{
									//钓到鱼。。。
									isHit = true;
									_isHitFish = true;
									hookFish(obj as Fish);
									break outerLoop;//一次只能钓一条鱼
								}
							}
//							if(_hook.hitTestObject(obj))
//							{
//								//钓到鱼。。。
//								isHit = true;
//								_isHitFish = true;
//								hookFish(obj as Fish);
//								break;//一次只能钓一条鱼
//							}
						}
						if(obj is Obstacle)
						{
//							if(_hook.hitTestObject(obj))
//							{
//								//碰到障碍物
//								isHit = true;
//								break;
//							}
							for each(point in aryCurrentPoint)
							{
								if(obj.hitTestPoint(point.x,point.y))
								{
									//碰到障碍物
									isHit = true;
									//添加爆炸效果
//									FishDispatcher.dispatchEvent( new DataEvent(FishingEventName.FishSquib,new Point(obj.x,obj.y)));
									//抖动
									(obj as Obstacle).shake(0.2);
									break outerLoop;
								}
							}
						}
					}
				}
				if(_hookState == HookState.up)
				{
					if(_length == 0)
					{
						//钓鱼一次结束
						_hookState = HookState.swing;
						if(_hookFish)
						{
//							FishingGlobal.scene.delObject(_hookFish);
							tweenFish(_hookFish);
						}
						_hookFish = null;
						Dispatcher.dispatchEvent( new DataEvent(EventName.FishMiniGameFishOne,_isHitFish));
						_isHitFish = false;
					}
				}
				
				//对掉到的鱼进行操作
				if(_hookFish)
				{
					var m:Matrix = getHookMatrix();
					_hookFish.x = this.x + 15 + m.tx;
					_hookFish.y = m.ty + _hookFish.height/2;
				}
			}
			
			//设置绳子和鱼钩位置
//			_rope.height = _length + BaseLength;
//			_rope.rotation = angle;
			
//			_hook.y = _length + BaseLength;
//			_hook.rotation = angle;
			_rope.transform.matrix = getLineMatrix();
			_hook.transform.matrix = getHookMatrix();
			_hook.smoothing = true;
			_rope.smoothing = true;
			
			//钓到鱼或者超过绳子的长度，则收回绳子；
			if(_length > FishingScene.AREAHEIGHT || isHit)
			{
				_hookState = HookState.up;
			}
		}
		
		private function tweenFish(fish:Fish):void
		{
			TweenLite.to(fish,0.5,{x:100,y:30,onComplete:function():void
			{
				FishingGlobal.scene.delObject(fish);
			}});
		}
		
		private function getHookMatrix():Matrix
		{
			var m:Matrix = new Matrix();
			m.tx -= 16;
			m.ty += _length + BaseLength;
			if (angle % 360 != 0) {
				m.rotate(angle * Math.PI / 180);
			}
			m.tx += 2;
			return m;
		}
		
		private function getLineMatrix():Matrix
		{
			var m:Matrix = new Matrix();
			m.tx -= 1.5;
			m.scale(1,(_length + BaseLength)/BaseLength);
			if (angle % 360 != 0) {
				m.rotate(angle * Math.PI / 180);
			}
			m.tx += 1.5;
			return m;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose();
		}
		
		/**
		 * 掉到鱼 
		 * @param fish
		 * 
		 */		
		public function hookFish(fish:Fish):void
		{
			fish.dead();
			_hookFish = fish;
		}

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
		}

		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
		public function get hookState():String
		{
			return _hookState;
		}

		public function set hookState(value:String):void
		{
			_hookState = value;
		}

		public function get length():Number
		{
			return _length;
		}
	}
}