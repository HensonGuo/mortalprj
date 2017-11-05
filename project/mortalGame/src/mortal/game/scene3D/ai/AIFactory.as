/**
 * 2013-12-16
 * @author chenriji
 **/
package mortal.game.scene3D.ai
{
	import baseEngine.system.Device3D;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.ai.base.IAICommand;
	import mortal.game.scene3D.ai.data.AIData;
	import mortal.game.scene3D.ai.data.FollowFightAIData;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.common.item.BaseItem;
	
	public class AIFactory
	{
		private static var _instance:AIFactory;
		private var _aiDataPool:Array = [];
		private var _aiPool:Array = [];
		
		private var _followFightAIDataPool:Array = [];
		
		public function AIFactory()
		{
		}
		
	
		public static function get instance():AIFactory
		{
			if(_instance == null)
			{
				_instance = new AIFactory();
			}
			return _instance;
		}
//		
//		public function outAI():IAICommand
//		{
//			
//		}
		
		public function inAI(ai:IAICommand):void
		{
			
		}
		
		public function outAIData():AIData
		{
			if(_aiDataPool.length == 0)
			{
				var res:AIData = new AIData();
				res.scene = Device3D.scene as GameScene3D;
				res.meRole = RolePlayer.instance;
				res.times = 0;
				res.range = 0;
				return res;
			}
			var tres:AIData = _aiDataPool.shift();
			tres.times = 0;
			tres.range = 0;
//			tres.params = null;
			return tres;
		}
		
		public function inAIData(data:AIData):void
		{
//			data.params = null;
			if(data is FollowFightAIData)
			{
				_followFightAIDataPool.push(data);
			}
			else
			{
				_aiDataPool.push(data);
			}
		}
		
		public function outFollowFightAIData():FollowFightAIData
		{
			var res:FollowFightAIData;
			if(_followFightAIDataPool.length == 0)
			{
				res = new FollowFightAIData();
				res.scene = Device3D.scene as GameScene3D;
				res.meRole = RolePlayer.instance;
			}
			else
			{
				res = _followFightAIDataPool.shift();
			}
			res.times = 0;
			res.range = 0;
			res.skillInfo = null;
			res.point = null;
			res.entitys = null;
			res.target = null;
			return res;
		}
		
		public function inFollowFightAIData(data:FollowFightAIData):void
		{
			_followFightAIDataPool.push(data);
		}
	}
}