package mortal.game.control
{
	import modules.TeamAvaterModule;
	
	import mortal.mvc.core.Controller;
	import mortal.mvc.interfaces.IView;
	
	public class TeamAvaterController extends Controller
	{
		private var _temaModule:TeamAvaterModule;
		
		public function TeamAvaterController()
		{
			super();
		}
		
		override protected function initView():IView
		{
			if(!_temaModule)
			{
				_temaModule = new TeamAvaterModule();
			}
			return _temaModule;
		}
	}
}