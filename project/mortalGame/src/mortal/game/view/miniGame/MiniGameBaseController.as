package mortal.game.view.miniGame
{
	import com.gengine.core.IDispose;

	public class MiniGameBaseController implements IDispose
	{
		protected var _target:MiniGameObject;
		
		public function MiniGameBaseController()
		{
		}
		
		public function set target(obj:MiniGameObject):void
		{
			_target = obj;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			_target = null;
		}
	}
}