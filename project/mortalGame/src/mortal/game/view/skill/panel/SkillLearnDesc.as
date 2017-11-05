/**
 * 2014-1-26
 * @author chenriji
 **/
package mortal.game.view.skill.panel
{
	import Message.DB.Tables.TSkill;
	import Message.Public.ESkillTargetSelect;
	import Message.Public.ESkillType;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GLabel;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.SkillUtil;
	import mortal.mvc.core.Dispatcher;
	
	public class SkillLearnDesc extends GSprite
	{
		private var _bg:ScaleBitmap;
		private var _titleBg1:ScaleBitmap;
		private var _titleBg2:ScaleBitmap;
		private var _title1:GBitmap;
		private var _title2:GBitmap;
		private var _txtName:GTextFiled;
		private var _txtType:GTextFiled;
		private var _txtLevel:GTextFiled; // 可学习、可升级
		private var _line1:ScaleBitmap;
		private var _line2:ScaleBitmap;
		private var _txtLevel2:GTextFiled; // 8级别
		private var _txtDesc:GTextFiled; // 描述
		private var _txtHowToGet:GTextFiled; // 以学习，获取途径
		private var _cSelect:GCheckBox;
		// 右下角下一级的
		private var _txtUpLevel:GTextFiled;
		private var _txtNeed:GTextFiled;
		private var _txtExperience:GTextFiled;
		private var _txtSkillPoint:GTextFiled;
		private var _btnLearn:GButton;
		
		// 数据
		private var _info:SkillInfo;
		
		public function SkillLearnDesc()
		{
			super();
		}
		
		public function updateData(info:SkillInfo):void
		{
			if(info == null)
			{
				return;
			}
			_info = info;
			_txtName.htmlText = info.skillName;
			_txtType.text = SkillUtil.getSkillUseTypeName(info.tSkill);
			
			_txtLevel2.text = Language.getStringByParam(20105, info.tSkill.skillLevel); // 下1级别
			_txtDesc.htmlText = SkillUtil.getSkillDesc(info.tSkill.skillId); // 1级别的描述
			_btnLearn.label = Language.getString(20095);
			if(!info.learned)
			{
				_txtHowToGet.textColor = 0x00ff00;
				_txtHowToGet.text = "等物品获得描述系统开发好再弄";
				if(!info.learnable()) // 未能学习
				{
					_txtLevel.filters = [FilterConst.colorFilter];
					_txtLevel.htmlText = Language.getStringByParam(20110, Language.getString(20113), 0, info.maxLevel);
//					DisplayUtil.removeMe(_btnLearn);
					DisplayUtil.setEnabled(_btnLearn, false);
				}
				else // 可以学习
				{
					_txtLevel.filters = [];
					_txtLevel.htmlText = Language.getStringByParam(20110, Language.getString(20112), 0, info.maxLevel);
					DisplayUtil.setEnabled(_btnLearn, true);
					_btnLearn.label = Language.getString(20094);
				}
				
				updateNextLevelInfo(info, info.tSkill);
			}
			else
			{
				_txtHowToGet.textColor = 0xF1DE42;
				_txtHowToGet.text = Language.getString(20117);
				if(info.isMaxLevel()) // 满级
				{
					_txtLevel.filters = [FilterConst.colorFilter];
					_txtLevel.htmlText = Language.getStringByParam(20110, Language.getString(20107), info.skillLevel, info.maxLevel);
					DisplayUtil.setEnabled(_btnLearn, false);
					
					_txtUpLevel.htmlText = Language.getStringByParam(20086, "#ffff00",  Language.getString(20107))
					_txtNeed.htmlText = Language.getStringByParam(20088, "#ffff00", 0);
					_txtSkillPoint.htmlText = Language.getStringByParam(20090, "#ffff00", 0);
					_txtExperience.htmlText = Language.getStringByParam(20108, "#ffff00", 0);
				}
				else if(info.upgradable()) // 可以升级
				{
					_txtLevel.filters = [];
					_txtLevel.htmlText = Language.getStringByParam(20110, Language.getString(20111), info.skillLevel, info.maxLevel);
					DisplayUtil.setEnabled(_btnLearn, true);
					
					updateNextLevelInfo(info, info.nextSkill);
				}
				else // 未满级且不能升级
				{
					_txtLevel.filters = [FilterConst.colorFilter];
					_txtLevel.htmlText = Language.getStringByParam(20110, Language.getString(20111), info.skillLevel, info.maxLevel);
					DisplayUtil.setEnabled(_btnLearn, false);
					
					updateNextLevelInfo(info, info.nextSkill);
				}
			}
			
			// 是否显示自动显示目标
			if(info.tSkill.targetSelect == ESkillTargetSelect._ESkillTargetSelectMouse)
			{
				_cSelect.label = Language.getString(20092);
				this.addChild(_cSelect);
				_cSelect.selected = info.autoUse;
			}
			else if(info.tSkill.targetSelect == ESkillTargetSelect._ESkillTargetSelectMouseDirection 
				&& info.tSkill.type != ESkillType._ESkillTypeTransfer)
			{
				_cSelect.label = Language.getString(20093);
				this.addChild(_cSelect);
				_cSelect.selected = info.autoUse;
			}
			else
			{
				DisplayUtil.removeMe(_cSelect);
			}
			
		}
		
		/**
		 * 默认显示下一级的要求 
		 * @param info
		 * @param skill
		 * 
		 */		
		private function updateNextLevelInfo(info:SkillInfo, skill:TSkill=null):void
		{
			//#BBE8FF
			if(info.isLevelEnough(skill))
			{
				_txtUpLevel.htmlText = Language.getStringByParam(20086, "#BBE8FF", skill.levelLimit);
			}
			else
			{
				_txtUpLevel.htmlText = Language.getStringByParam(20086, "#ff0000", skill.levelLimit);
			}
			
			if(info.isCoinEnough(skill))
			{
				_txtNeed.htmlText = Language.getStringByParam(20088, "#BBE8FF", skill.needCoin);
			}
			else
			{
				_txtNeed.htmlText = Language.getStringByParam(20088, "#ff0000", skill.needCoin);
			}
			
			if(info.isSkillPointEnough(skill))
			{
				_txtSkillPoint.htmlText = Language.getStringByParam(20090, "#BBE8FF", skill.needVitalEnergy);
			}
			else
			{
				_txtSkillPoint.htmlText = Language.getStringByParam(20090, "#ff0000", skill.needVitalEnergy);
			}
			
			if(info.isExperienceEnough(skill))
			{
				_txtExperience.htmlText = Language.getStringByParam(20108, "#BBE8FF", skill.needExperience);
			}
			else
			{
				_txtExperience.htmlText = Language.getStringByParam(20108, "#ff0000", skill.needExperience);
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.bg(0, 0, 167, 506, this);
			_titleBg1 = UIFactory.bg(2, 2, 163, 26, this, ImagesConst.RegionTitleBg);
			_titleBg2 = UIFactory.bg(2, 363, 163, 26, this, ImagesConst.RegionTitleBg);
			_title1 = UIFactory.gBitmap(ImagesConst.SkillPanel_jnjs, _titleBg1.x + 8, _titleBg1.y + 5, this);
			_title2 = UIFactory.gBitmap(ImagesConst.SkillPanel_sjjn, _titleBg2.x + 8, _titleBg2.y + 5, this);
			_txtName = UIFactory.gTextField("", 8, 30, 200, 20, this);
			_txtName.textColor = 0xF9BC8D;
			_txtType = UIFactory.gTextField("", 8, 49, 200, 20, this);
			
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.letterSpacing = 2;
			_txtLevel = UIFactory.gTextField("", 8, 68, 200, 20, this, tf);
			_line1 = UIFactory.bg(8, 88, 156, 1, this, ImagesConst.SplitLine);
			_line2 = UIFactory.bg(8, 284, 156, 1, this, ImagesConst.SplitLine);
			_txtLevel2 = UIFactory.gTextField("", 8, 95, 200, 20, this);
			_txtLevel2.textColor = 0xF9BC8D;
			
			tf = GlobalStyle.textFormatPutong;
			tf.leading = 4;
			_txtDesc = UIFactory.gTextField("", 8, 115, 152, 170, this, tf);
			_txtDesc.multiline = true;
			_txtDesc.wordWrap = true;
			
			tf = GlobalStyle.textFormatPutong;
			tf.leading = 4;
			tf.align = TextFormatAlign.CENTER;
			_txtHowToGet  = UIFactory.gTextField("", 8, 294, 152, 170, this, tf);
			_txtHowToGet.multiline = true;
			_txtHowToGet.wordWrap = true;
			
			_cSelect = UIFactory.checkBox(Language.getString(20092), 35, 331, 120, 25, this);
			_cSelect.configEventListener(Event.CHANGE, autoSelectChangeHandler);
			
			_txtUpLevel = UIFactory.gTextField("", 8, 390, 200, 20, this);
			_txtNeed = UIFactory.gTextField("", 8, 406, 200, 20, this);
			_txtExperience = UIFactory.gTextField("", 8, 422, 200, 20, this);
			_txtSkillPoint = UIFactory.gTextField("", 8, 436, 200, 20, this);
			_btnLearn = UIFactory.gButton("", 50, 462, 62, 22, this);
			
			_btnLearn.configEventListener(MouseEvent.CLICK, learnSkillHandler);
		}
		
		private function autoSelectChangeHandler(evt:Event):void
		{
			ClientSetting.local.setIsDone(!_cSelect.selected, IsDoneType.SkillAutoSelectStart + _info.position - 1);
			_info.autoUse = _cSelect.selected;
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_bg.dispose(isReuse);
			this._btnLearn.dispose(isReuse);
			_btnLearn = null;
			
			_cSelect.dispose(isReuse);
			_cSelect = null;
			
			_txtHowToGet.dispose(isReuse);
			_txtHowToGet = null;
			
			_line1.dispose(isReuse);
			_line1 = null;
			
			_line2.dispose(isReuse);
			_line2 = null;
			
			_title1.dispose(isReuse);
			_title1 = null;
			
			_title2.dispose(isReuse);
			_title2 = null;
			
			_titleBg1.dispose(isReuse);
			_titleBg1 = null;
			
			_titleBg2.dispose(isReuse);
			_titleBg2 = null;
			
			_txtDesc.dispose(isReuse);
			_txtDesc = null;
			
			_txtExperience.dispose(isReuse);
			_txtExperience = null;
			
			_txtLevel.dispose(isReuse);
			_txtLevel = null;
			
			_txtLevel2.dispose(isReuse);
			_txtLevel2 = null;
			
			_txtName.dispose(isReuse);
			_txtName = null;
			
//			_txtNeed.dispose(isReuse);
//			_txtName = null;
			
			_txtNeed.dispose(isReuse);
			_txtNeed = null;
			
			_txtSkillPoint.dispose(isReuse);
			_txtSkillPoint = null;
			
			_txtType.dispose(isReuse);
			_txtType = null;
			
			_txtUpLevel.dispose(isReuse);
			_txtUpLevel = null;
			
		}
		
		private function learnSkillHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SkillUpgradeReq, _info.skillId));
		}
	}
}