package mortal.game.view.miniGame.fishing.Obj
{
	import mortal.game.scene.modle.SWFPlayer;
	import mortal.game.view.miniGame.MiniGameActionObject;
	import mortal.game.view.miniGame.MiniGameBaseController;
	import mortal.game.view.miniGame.fishing.ObjController.FishBaseController;
	import mortal.game.view.miniGame.fishing.defin.FishDirection;
	
	public class FishActionObject extends MiniGameActionObject
	{
		//鱼的活动范围 最小深度和最大深度
		protected var _minDepth:Number = 0;
		protected var _maxDepth:Number = 400;
		
		protected var _xSpeed:Number = 0;
		protected var _swfPlayer:SWFPlayer;
		protected var _horizontalDirection:int = FishDirection.RIGHT;//横向方向
		
		public function FishActionObject(ctrl:FishBaseController,swfPlayer:SWFPlayer = null)
		{
			super(ctrl);
			_swfPlayer = swfPlayer;
			if(_swfPlayer)
			{
				this.addChild(swfPlayer);
			}
			else
			{
				//测试阶段，画一个玩意作为一个对象 坑爹啊！！！
				graphics.beginFill(0xff00ff);
				graphics.drawRect(0,0,50,30);
				graphics.endFill();
			}
		}
		
		/**
		 * 设置x速度  一般只能交由自身控制器修改。
		 * @param value
		 * 
		 */
		public function set xSpeed(value:Number):void
		{
			_xSpeed = value;
		}
		
		/**
		 * 设置游向 
		 * @return 
		 * 
		 */	
		public function set horizontalDirection(value:int):void
		{
			_horizontalDirection = value;
		}
		
		/**
		 * 获得游向 
		 * @return 
		 * 
		 */
		public function get horizontalDirection():int
		{
			return _horizontalDirection;
		}
		
		/**
		 * 运行 
		 * 
		 */
		override public function Do():void
		{
			(controller as FishBaseController).autoRun();
			if(_horizontalDirection == FishDirection.RIGHT)
			{
				this.x += _xSpeed;
			}
			else
			{
				this.x -= _xSpeed;
			}
		}
		
		/**
		 * 销毁
		 * 
		 */		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose();
			_xSpeed = 0;
			if(_swfPlayer)
			{
				_swfPlayer.dispose();
				_swfPlayer = null;
			}
		}

		public function get minDepth():Number
		{
			return _minDepth;
		}

		public function set minDepth(value:Number):void
		{
			_minDepth = value;
		}

		public function get maxDepth():Number
		{
			return _maxDepth;
		}

		public function set maxDepth(value:Number):void
		{
			_maxDepth = value;
		}

		public function get swfPlayer():SWFPlayer
		{
			return _swfPlayer;
		}

		public function set swfPlayer(value:SWFPlayer):void
		{
			_swfPlayer = value;
		}


	}
}