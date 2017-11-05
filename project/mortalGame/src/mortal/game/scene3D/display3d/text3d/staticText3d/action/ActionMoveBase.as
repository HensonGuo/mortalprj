package mortal.game.scene3D.display3d.text3d.staticText3d.action
{
	import flash.geom.Vector3D;

	public class ActionMoveBase
	{
		private  var _vo:ActionVo;
		public function ActionMoveBase()
		{
		}
		
		public function set vo(value:ActionVo):void
		{
			_vo=value;
		}
		
		public function get vo():ActionVo
		{
			return _vo;
		}
		public function update(frame:int,$result:Vector3D):Boolean
		{
			return false;
		}
	}
}