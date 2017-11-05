package mortal.game.control
{
	import mortal.game.view.mainUI.rightTopBar.RightTopBar;
	import mortal.mvc.core.Controller;
	import mortal.mvc.interfaces.IView;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class RightTopController extends Controller
	{
		private var _rightTopModule:RightTopBar;
		
		public function RightTopController()
		{
			super();
		}
		
		override protected function initView():IView
		{
			if(!_rightTopModule)
			{
				_rightTopModule = new RightTopBar();
			}
			return _rightTopModule;
		}
	}
}