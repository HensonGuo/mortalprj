/**
 * 2014-3-28
 * @author chenriji
 **/
package mortal.game.view.skill.panel
{
	import Message.DB.Tables.TRune;
	
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.resource.info.ImageInfo;
	import com.mui.controls.BaseToolTip;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.ToolTipSprite;
	import com.mui.manager.ToolTipsManager;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.EffectManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.skill.panel.data.RuneItemData;
	import mortal.mvc.core.Dispatcher;
	
	public class RuneItem extends ToolTipSprite
	{
		private var _txtName:GTextFiled;
		private var _bg:GBitmap;
		private var _icon:GBitmap;
		private var _lastImageUrl:String;
		private var _btnLevelUp:GLoadedButton;
		private var _myData:RuneItemData;
		private var _isFlowMovieFiltering:Boolean=false;
		private var _txtLevel:GTextFiled;
		
		private var _registed:Boolean = false;
		
		public function RuneItem()
		{
			super();
		}
		
		public function set runeData(data:RuneItemData):void
		{
			
			if(data == null)
			{
				_toolTipData = null;
				if(_registed)
				{
					ToolTipsManager.register(this);
					_registed = false;
				}
				this.mouseChildren = false;
				this.mouseEnabled = false;
				setLocked();
				return;
			}
			_toolTipData = data.info;
			if(!_registed)
			{
				_registed = true;
				ToolTipsManager.register(this);
			}
		
			_myData = data;
			this.mouseChildren = true;
			this.mouseEnabled = true;
			
			_txtName.filters = [];
			_txtName.text = data.info.name;
			
			
			//移除之前加载的
			if(_lastImageUrl)
			{
				LoaderManager.instance.removeResourceEvent(_lastImageUrl, onLoadCompleteHandler);
				_lastImageUrl = null;
			}
			_lastImageUrl = data.info.icon + ".jpg";
			LoaderManager.instance.load(_lastImageUrl,onLoadCompleteHandler, LoaderPriority.LevelB);
			
			if(data.actived)
			{
				_icon.filters = [];
				if(_txtLevel.parent == null)
				{
					this.addChild(_txtLevel);
				}
				_txtLevel.text = data.info.level.toString();
			}
			else
			{
				_icon.filters = [FilterConst.colorFilter];
				DisplayUtil.removeMe(_txtLevel);
			}
			
			if(data.canUpgrade)
			{
				if(!_isFlowMovieFiltering)
				{
					EffectManager.glowFilterReg(_icon);
					_isFlowMovieFiltering = true;
				}
				if(_btnLevelUp.parent == null)
				{
					this.addChild(_btnLevelUp);
				}
			}
			else
			{
				if(_isFlowMovieFiltering)
				{
					EffectManager.glowFilterUnReg(_icon);
					_isFlowMovieFiltering = false;
					if(!data.actived)
					{
						_icon.filters = [FilterConst.colorFilter];
					}
				}
				DisplayUtil.removeMe(_btnLevelUp);
			}
		}
		
		protected function onLoadCompleteHandler( info:ImageInfo ):void
		{
			_lastImageUrl = null;
			_icon.bitmapData = info.bitmapData;
//			_icon.width = _width;
//			_icon.height = _height;
			setSize(_width, _height);
		}
		
		public override function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			if(_bg != null && _bg.parent != null)
			{
//				_bg.setSize(_width + 2, _height + 2);
				_icon.width = _width;
				_icon.height = _height;
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_width = 36;
			_height = 36;
			_txtName = UIFactory.gTextField("", -14, -22, 76, 20, this, GlobalStyle.textFormatPutong.center());
			_txtName.textColor = GlobalStyle.colorLvUint;
			_txtName.mouseEnabled = false;
			_bg = UIFactory.gBitmap(ImagesConst.SkillRuneBg, 0, 0, this);
			_icon = UIFactory.bitmap(null, 7, 7, this);
			// 升级 + 号
			_btnLevelUp = UIFactory.gLoadedButton("Add", 55, -22, 18, 18, this);
			_btnLevelUp.configEventListener(MouseEvent.CLICK, levelUpHandler);
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.color = 0xffff00;
			tf.align = TextFormatAlign.RIGHT;
			tf.size = 11;
			_txtLevel = UIFactory.gTextField("", 0, 28, 44, 20, this, tf);
		}
		
		private var _lastClickTime:int;
		protected function levelUpHandler(evt:MouseEvent):void
		{
			var now:int = getTimer();
			if(now - _lastClickTime < 1500)
			{
				return;
			}
			_lastClickTime = now;
			Dispatcher.dispatchEvent(new DataEvent(EventName.Skill_RuneUpgrade, _myData));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			if(_isFlowMovieFiltering)
			{
				EffectManager.glowFilterUnReg(_icon);
				_isFlowMovieFiltering = false;
			}
			_bg.dispose(isReuse);
			_bg = null;
			_icon.dispose(isReuse);
			_icon = null;
			_txtName.dispose(isReuse);
			_txtName = null;
			if(_lastImageUrl != null)
			{
				LoaderManager.instance.removeResourceEvent(_lastImageUrl,onLoadCompleteHandler);
				_lastImageUrl = null;
			}
			
			_txtLevel.dispose(isReuse);
			_txtLevel = null;
			
			_btnLevelUp.dispose(isReuse);
			_btnLevelUp = null;
		}
		
		public function setLocked():void
		{
			if(_isFlowMovieFiltering)
			{
				EffectManager.glowFilterUnReg(_icon);
				_isFlowMovieFiltering = false;
			}
			_icon.bitmapData = GlobalClass.getBitmapData(ImagesConst.Locked);
			_icon.filters = [];
			_icon.width = _width;
			_icon.height = _height;
			_txtName.filters = [FilterConst.colorFilter];
			_txtName.text = Language.getString(20202);
			DisplayUtil.removeMe(_btnLevelUp);
			DisplayUtil.removeMe(_txtLevel);
		}
	}
}