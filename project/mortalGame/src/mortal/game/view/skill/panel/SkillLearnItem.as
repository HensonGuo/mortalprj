/**
 * 2014-1-15
 * @author chenriji
 **/
package mortal.game.view.skill.panel
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.EffectManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.skill.SkillInfo;
	import mortal.mvc.core.Dispatcher;
	
	public class SkillLearnItem extends GSprite
	{
		private var _txtBg:GBitmap;
		private var _txtName:GTextFiled;
		private var _btnAdd:GLoadedButton;
		private var _bg:GBitmap; // 圆的底
		private var _iconBg:GBitmap;
		private var _txtLevel:GTextFiled;
		
		private var _skillItem:SkillItem;
		private var _skillInfo:SkillInfo;
		private var _learnable:Boolean = false;
		private var _isFlowMovieFiltering:Boolean = false;
		
		private var _pos:int;
		
		public function SkillLearnItem()
		{
			super();
		}
		
		public function get pos():int
		{
			return _pos;
		}
		
		public function set pos(value:int):void
		{
			_pos = value;
		}

		public function set selected(value:Boolean):void
		{
			if(value)
			{
				_skillItem.filters = [FilterConst.colorGlowFilter(0xffff00)];
			}
			else if(_skillInfo.learned)
			{
				_skillItem.filters = [];
			}
			else
			{
				_skillItem.filters = [FilterConst.colorFilter];
			}
		}
		
		public function get skillItem():SkillItem
		{
			return _skillItem;
		}
		
		public function set skillInfo(info:SkillInfo):void
		{
			_skillInfo = info;
			_txtName.htmlText = info.tSkill.name;
			_skillItem.setSkillInfo(info);
			if(info.learned)
			{
				_skillItem.filters = [];
				_skillItem.isDragAble = true;
			}
			else
			{
				_skillItem.filters = [FilterConst.colorFilter];
				_skillItem.isDragAble = false;
			}
			
			updateUpgradable();
			updateLearnable();
		}
		
		public function get skillInfo():SkillInfo
		{
			return _skillInfo;
		}
		
		public function updateUpgradable():void
		{
			if(_skillInfo == null)
			{
				return;
			}
			if(_skillInfo.learned)
			{
				this.addChild(_txtLevel);
				_txtLevel.text = _skillInfo.skillLevel.toString();
			}
			else
			{
				DisplayUtil.removeMe(_txtLevel);
			}
		}
		
		public function updateLearnable():void
		{
			if(_skillInfo == null)
			{
				return;
			}
			if(_skillInfo.upgradable() || _skillInfo.learnable())
			{
				this.addChild(_btnAdd);
				if(!_isFlowMovieFiltering)
				{
					EffectManager.glowFilterReg(_skillItem);
					_isFlowMovieFiltering = true;
				}
			}
			else
			{
				DisplayUtil.removeMe(_btnAdd);
				if(_isFlowMovieFiltering)
				{
					EffectManager.glowFilterUnReg(_skillItem);
					_isFlowMovieFiltering = false;
				}
			}
		}
		
		public function isLearnable():Boolean
		{
			return _learnable;
		}
		
		public function getSkillInfo():SkillInfo
		{
			return _skillInfo;
		}
		
		public var isOpened:Boolean = true;
		public function setNotOpen():void
		{
			isOpened = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_bg.filters = [FilterConst.colorFilter];
			_iconBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.SkillRuneBgDisable);
			_txtBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.TextBgDisable);
			_txtName.filters = [FilterConst.colorFilter];
			DisplayUtil.removeMe(_txtLevel);
			DisplayUtil.removeMe(_btnAdd);
			
			if(_skillItem)
			{
				_skillItem.setLocked();
			}
		}
		
		private function upgradeHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SkillUpgradeReq, _skillInfo.skillId));
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			var tf:GTextFormat
			_bg = UIFactory.gBitmap(ImagesConst.SkillPanel_Circle, 10, 12, this);
			
			// 名字
			_txtBg = UIFactory.gBitmap(ImagesConst.TextBg, 0, 0, this);
			tf = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.CENTER;
			_txtName = UIFactory.gTextField("", 0, 2, _txtBg.width, 20, this, tf);
			
			_iconBg = UIFactory.gBitmap(ImagesConst.SkillRuneBg, 22, 21, this);
			
			_skillItem = new SkillItem();
			_skillItem.x = _iconBg.x + 5;
			_skillItem.y = _iconBg.y + 5;
			_skillItem.toolTipMode = SkillItem.TooltipMode_ShowNext;
			this.addChild(_skillItem);
			
			// 升级 + 号
			_btnAdd = UIFactory.gLoadedButton("Add", 76, 2, 18, 18, this);
			
			tf = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.RIGHT;
			tf.color = 0xffff00;
			_txtLevel = UIFactory.gTextField("0", _iconBg.x, _iconBg.y + 27, 46, 20, this, tf);
			_txtLevel.mouseEnabled = false;
		
			_btnAdd.configEventListener(MouseEvent.CLICK, upgradeHandler);
			this.configEventListener(MouseEvent.CLICK, showSkillInfo);
		}
		
		public function showSkillInfo(evt:MouseEvent=null):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SkillShowSkillInfo, _skillInfo));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bg.dispose(isReuse);
			_txtBg.dispose(isReuse);
			_btnAdd.dispose(isReuse);
			_iconBg.dispose(isReuse);
			_txtLevel.dispose(isReuse);
			_skillItem.dispose(false);
			_txtName.dispose(isReuse);
			
			_bg = null;
			_txtBg = null;
			_btnAdd = null;
			_iconBg = null;
			_txtLevel = null;
			_skillItem = null;
			_skillInfo = null;
			_txtName = null;
		}
	}
}