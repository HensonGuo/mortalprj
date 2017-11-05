/**
 * 2013-12-17
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.ai.data.AIData;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.IGame2D;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 移动到目标点
	 * @author chenriji
	 */
	public class MoveAI extends AICommand
	{
		/**
		 * 场景
		 */
		protected var _scene:GameScene3D;
		/**
		 *  目标
		 */
		protected var _target:Object;
		
		/**
		 * 目标像素坐标 
		 */
		protected var _targetPixPoint:Point;
		
		/**
		 *  自己
		 */
		protected var _meRole:RolePlayer;
		
		/**
		 * 像素范围
		 */		
		protected var _range:int = 400;

		/**
		 * 路径引导 
		 */
		protected var _isShowGuidePath:Boolean;
		
		protected var _nextMoveTime:Number = 0;
		protected var _moveSplitTime:int = 400;
		
		protected var _isStoped:Boolean = true;
		
		public function MoveAI()
		{
		}
		
		public override function start(onEnd:Function=null):void
		{
			_scene = _data.scene;
			_meRole = _data.meRole;
			_target = _data.target;
			_callback = onEnd;
			_isStoped = false;
			updateTilePoint();
			
			if(isInRange())
			{
				stop();
//				endAI();
				return;
			}
			
			_meRole.addEventListener(PlayerEvent.ENTITY_DEAD, onEntityDead, false, 0, true);
			_meRole.addEventListener(PlayerEvent.GIRD_WALK_END, onGirdWalkEnd, false, 0, true);
			_meRole.addEventListener(PlayerEvent.WALK_END, onWalkEnd, false, 0, true);
			
			sceneMove(_targetPixPoint);
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.AI_MoveStart, _meRole.pathArray));
		}
		
		public override function set data($data:AIData):void
		{
			super.data = $data;
			if($data.range > 0)
			{
				_range = $data.range;
			}
		}
		
		public override function stop():void
		{
			if(_meRole)
			{
				_meRole.removeEventListener(PlayerEvent.ENTITY_DEAD, onEntityDead);
				_meRole.removeEventListener(PlayerEvent.GIRD_WALK_END, onGirdWalkEnd);
				_meRole.removeEventListener(PlayerEvent.WALK_END, onWalkEnd);
				
				if(_meRole.isMove)
				{
					_meRole.stopWalking();
				}
			}
			_isStoped = true;
			_target = null;
			_isShowGuidePath = false;
			_range = 140;
			super.endAI();
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.AI_MoveEnd));
		}

		public function get target():Object
		{
			return _target;
		}
		
		protected function sceneMove(targetPoint:Point):void
		{
			var path:Array = data.params as Array;
			if(path != null && path.length > 0) // 预先有路径了， 直接走路径
			{
				_scene.moveRoleByPath(path);
				return;
			}
			
			// 通过target点来寻路
//			var targetTilePoint:Point = GameMapUtil.getTilePoint(targetPoint.x,targetPoint.y);
			var curTime:int = getTimer();
			if(curTime >= _nextMoveTime)
			{
				_scene.moveRole(targetPoint);
				_nextMoveTime = curTime + _moveSplitTime;
			}
		}
		
		/**
		 * 角色死亡
		 * @param event
		 *
		 */
		protected function onEntityDead(event:PlayerEvent):void
		{
			stop();
		}

		/**
		 * 移动完成
		 * @param evt
		 */
		protected function onWalkEnd(evt:PlayerEvent):void
		{
			if(isInRange())
			{
				stop();
			}
			else
			{
//				sceneMove(_targetPixPoint);
			}
		}
		
		/**
		 * 格子移动完成
		 * @param evt
		 */
		protected function onGirdWalkEnd(evt:PlayerEvent):void
		{
			if(isInRange())
			{
				stop();
			}
		}
		
		/**
		 * 是否在有效距离内 
		 * @return 
		 * 
		 */
		protected function isInRange():Boolean
		{
			if(_target == null)
			{
				return true;
			}
			try
			{
				var dis:Number = GameMapUtil.getDistance(_meRole.x2d, _meRole.y2d, _targetPixPoint.x, _targetPixPoint.y);
			}
			catch(e:*)
			{
				trace("...");
			}
			var res:Boolean= (dis <= range);
			if(res == true)
			{
				trace("....");
			}
			return res;
		}
		
		public function get range():Number
		{
			if(_range >= 0)
			{
				return _range;
			}
			return _meRole.speed.speed;
		}
		
		public function set range(value:Number):void
		{
//			_range = 400;
			_range = value;
		}
		
		protected function updateTilePoint():void
		{
			//目标为点
			if(_target is Point)
			{
				_targetPixPoint = Point(_target);
				RolePlayer.instance.currentFollowTarget = null;
			}
			//目标为实体
			else
			{
				if(!_targetPixPoint)
				{
					_targetPixPoint = new Point();
				}
				
				if(_target != null)
				{
					_targetPixPoint.x = (_target as IGame2D).x2d;
					_targetPixPoint.y = (_target as IGame2D).y2d;
				}
				else // 无目标， 就是对自己， 或者无目标释放， 不用走动
				{
					_targetPixPoint.x = RolePlayer.instance.x2d;
					_targetPixPoint.y = RolePlayer.instance.y2d;
				}
			}
		}
	}
}