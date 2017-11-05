/**
 * @date	2011-3-4 下午03:47:56
 * @author  jianglang
 * 
 */	

package mortal.mvc.core
{
	import mortal.game.cache.Cache;
	import mortal.mvc.interfaces.IController;
	import mortal.mvc.interfaces.IView;
	
	public class Controller implements IController
	{
		protected var cache:Cache = Cache.instance;
		protected var _view:IView; //界面
		
		public function Controller()
		{
			initServer();
		}
		
		public function get view():IView
		{
			if( _view == null )
			{
				_view = initView();
			}
				
			return _view;
		}

		public function set view(value:IView):void
		{
			_view = value;
		}

		protected function initServer():void
		{
			
		}
		
		protected function initView():IView
		{
			return _view;
		}
		
		public function get isViewShow():Boolean
		{
			return _view && !_view.isHide;
		}
		
		/**
		 * 弹出界面 
		 * 
		 */		
		public function popup():void
		{
			
		}
	}
}
