/**
 * 2014-2-21
 * @author chenriji
 **/
package mortal.game.view.task.view.track
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GLoadedButton;
	import com.mui.core.GlobalClass;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class BtnShowTaskTrack extends Sprite implements IToolTipItem
	{
		private var _hideBtn:GLoadedButton;
		private var _bg:Bitmap;
		
		public function BtnShowTaskTrack()
		{
			super();
//			mouseChildren = false;
//			mouseEnabled = true;
			buttonMode = true;
			initUI();
		}
		
		protected function initUI():void
		{
			_hideBtn = UIFactory.gLoadedButton(ImagesConst.LastPageBtn_upSkin, 0, 0, 21, 20, this);//GlobalClass.getInstance("NextPageBtn_overSkin");
			_hideBtn.label = "";
//			_hideBtn.width = 24; LastPageBtn_upSkin
//			_hideBtn.height = 22;
//			addChild(_hideBtn);
			
			_bg = GlobalClass.getBitmap(ImagesConst.trackbg);
			_bg.x = -1;
			_bg.y = -1;//-_hideBtn.height/2;
			addChild(_bg);
			
			show = true;
		}
		
		public function set show(value:Boolean):void
		{
			if(value)
			{
				toolTipData = HTMLUtil.addColor(Language.getString(20136),"#ffffff");//隐藏任务追踪
//				_hideBtn.setSize(21, 20);
				_hideBtn.scaleX = 1;
				if(contains(_bg))
				{
					removeChild(_bg);
				}
			}
			else
			{
				toolTipData = HTMLUtil.addColor(Language.getString(20137),"#ffffff");//显示任务追踪
//				_hideBtn.setSize(-21, 20);
				_hideBtn.scaleX = -1;
				if(!contains(_bg))
				{
					addChildAt(_bg,0);
				}
			}
		}
		
		public function get toolTipData():*
		{
			return _tooltipData;
		}
		
		private var _tooltipData:*;
		
		public function set toolTipData(value:*):void
		{
			if(value == null || value==""){
				ToolTipsManager.unregister(this);
			}else{
				ToolTipsManager.register(this);
			}
			_tooltipData = value;
		}
	}
}