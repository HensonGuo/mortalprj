package mortal.game.view.group.groupAvatar
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class BtnShowTeamAvatar extends GSprite implements IToolTipItem
	{
		private var _hideBtn:GLoadedButton;
		private var _bg:ScaleBitmap;
		private var _title:GTextFiled;
		
		public function BtnShowTeamAvatar()
		{
			super();
			buttonMode = true;
		}
		
		override protected function configUI():void
		{
			_hideBtn = UIFactory.gLoadedButton(ImagesConst.PrevPageBtn_upSkin, 1, 1, 17, 18, this);//GlobalClass.getInstance("NextPageBtn_overSkin");
			_hideBtn.label = "";
			
			_bg = UIFactory.bg(0,0,20,100,this,ImagesConst.ComboBox);
			
			_title = UIFactory.gTextField(Language.getString(30255),2,20,20,80,this);
			_title.wordWrap = true;
			_title.multiline = true;
			
			show = true;
		}
		
		public function set show(value:Boolean):void
		{
			if(value)
			{
				toolTipData = HTMLUtil.addColor(Language.getString(30254),"#ffffff");//隐藏任务追踪
				_hideBtn.styleName = ImagesConst.PrevPageBtn_upSkin;	
//				_hideBtn.scaleX = 1;
				if(contains(_bg))
				{
					removeChild(_bg);
				}
				
				if(contains(_title))
				{
					removeChild(_title);
				}
					
				
			}
			else
			{
				toolTipData = HTMLUtil.addColor(Language.getString(30255),"#ffffff");//显示任务追踪
//				_hideBtn.scaleX = -1;
				_hideBtn.styleName = ImagesConst.NextPageBtn_upSkin;	
				if(!contains(_bg))
				{
					addChildAt(_bg,0);
				}
				
				if(!contains(_title))
				{
					addChild(_title);
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