/**
 * 2013-12-17
 * @author chenriji
 **/
package mortal.game.scene3D.ai.data
{
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.player.entity.RolePlayer;

	public class AIData
	{
		public function AIData()
		{
		}
		
		public var scene:GameScene3D;
		public var target:Object;
		public var meRole:RolePlayer;
		public var params:Object;
		public var range:int;
		public var times:int;
	}
}