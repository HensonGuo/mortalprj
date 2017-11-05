/**
 * @date 2013-2-5 下午02:51:09
 * @author chenriji
 */
package mortal.game.view.common.guide
{
	import extend.language.Language;
	
	import flash.events.Event;
	
	import mortal.common.DisplayUtil;
	import mortal.component.window.BaseWindow;
	import mortal.game.scene.modle.SWFPlayer;
	import mortal.game.scene.modle.data.ModelType;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuidePageWindow extends BaseWindow
	{
		protected var _player:SWFPlayer;
		protected var _page:PageSelecter;
		protected var _lastPage:int;
		protected var _urls:Array;
		
		protected var _pageWidth:int = 632;
		protected var _pageHeight:int = 365;
		protected var _titleName:String = Language.getString(80324);
		
		/**
		 *  
		 * @param pageWidth 页面的宽度
		 * @param pageHeight 页面的高度
		 * @param titleName 窗口标题
		 * @param $layer 显示的层次
		 * 
		 */		
		public function GuidePageWindow(pageWidth:int = 632, pageHeight:int = 365, titleName:String = "", $layer:ILayer=null)
		{
			_pageWidth = pageWidth;
			_pageHeight = pageHeight;
			if(titleName != "")
			{
				_titleName = titleName;
			}
			
			super($layer);
			setSize(_pageWidth + 40, _pageHeight + 80);
			_lastPage = -1;
			this.title = _titleName;
			this.titleHeight = 28;
			
			_page.addEventListener(Event.CHANGE, onPageChangeHandler);
		}
		
		public function set data(arr:Array):void
		{
			_urls = arr;
			if(_urls == null || _urls.length == 0)
			{
				_page.currentPage = 1;
				_page.maxPage = 1;
				return;
			}
			_page.currentPage = 1;
			_page.maxPage = _urls.length;
			updatePage();
		}
		
		public override function show(x:int=0, y:int=0):void
		{
			super.show(x, y);
			this._lastPage = -1;
			this.updatePage();
		}
		
		protected function updatePage():void
		{
			if(_urls == null || _urls.length == 0 ||_lastPage == _page.currentPage) // 同一页
			{
				return;
			}
			_lastPage = _page.currentPage;
			if(_player == null)
			{
				_player = new SWFPlayer();
				_player.sceneX = 222;
				_player.sceneY = 244;
				this.addChild(_player);
			}
			//			_player.dispose();
			var url:String = _urls[_page.currentPage - 1];
			_player.loadComplete = loadCompleted;
			_player.load(url, ModelType.NormalSwf, null);
		}
		
		protected function loadCompleted(info:*):void
		{
			
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			if(_player != null)
			{
				_player.dispose(true);
				DisplayUtil.removeMe(_player);
				_player = null;
			}
			super.dispose();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			UIFactory.bg(20, 43, _pageWidth, _pageHeight, this);
			
			_page = UIFactory.pageSelecter((_pageWidth + 40 - 80)/2, _pageHeight + 43 + 6, this, PageSelecter.SingleMode);
			
			_player = new SWFPlayer();
			_player.sceneX = 222;
			_player.sceneY = 244;
			this.addChild(_player);
		}
		
		protected function onPageChangeHandler(evt:Event):void
		{
			updatePage();
		}
	}
}