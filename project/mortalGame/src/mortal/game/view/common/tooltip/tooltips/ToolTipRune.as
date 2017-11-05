/**
 * 2014-4-8
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import Message.DB.Tables.TRune;
	import Message.DB.Tables.TSkill;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.common.text.AutoLayoutTextContainer;
	import mortal.game.cache.Cache;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.tooltip.tooltips.base.ToolTipScaleBg;
	import mortal.game.view.skill.SkillInfo;
	
	public class ToolTipRune extends ToolTipScaleBg
	{
		private var _txtName:GTextFiled;
		private var _line1:ScaleBitmap;
		private var _txtLevel:GTextFiled;
		private var _txtDesc:GTextFiled;
		private var _line2:ScaleBitmap;
		private var _txtLevel2:GTextFiled;
		private var _txtDesc2:GTextFiled;
		private var _line3:ScaleBitmap;
		private var _txtReq:AutoLayoutTextContainer;
		
		private var _rune:TRune;
		
		public function ToolTipRune()
		{
			super();
			paddingLeft = 8;
			paddingRight = 8;
			initUI();
		}
		
		private function initUI():void
		{
			setBg(ImagesConst.ToolTipBg);
			
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.size = 14;
			tf.bold = true;
			tf.align = TextFormatAlign.CENTER;
			_txtName = UIFactory.gTextField("", 0, 0, 200, 20, contentContainer2D, tf);
			_line1 = UIFactory.bg(0, 24, 200, 2, contentContainer2D, ImagesConst.SplitLine);
			
			_txtLevel = UIFactory.gTextField("", 0, _line1.y + 4, 200, 20, contentContainer2D);
			_txtDesc = UIFactory.gTextField("", 0, _txtLevel.y + 20, 200, 20, contentContainer2D);
			_txtDesc.multiline = true;
			_txtDesc.wordWrap = true;
			
			_line2 = UIFactory.bg(0, 22, 200, 2, contentContainer2D, ImagesConst.SplitLine);
			
			_txtLevel2 = UIFactory.gTextField("", 0, 0, 200, 20, contentContainer2D);
			_txtDesc2 = UIFactory.gTextField("", 0, 0, 200, 20, contentContainer2D);
			_txtDesc2.multiline = true;
			_txtDesc2.wordWrap = true;
			
			_line3 = UIFactory.bg(0, 22, 200, 2, contentContainer2D, ImagesConst.SplitLine);
			
			_txtReq = new AutoLayoutTextContainer();
			this.addChild(_txtReq);
			_txtReq.y = 135;
			_txtReq.verticalGap = -2;
			_txtReq.addNewText(200, "", 12, 0xffff00);
			_txtReq.addNewText(200, "", 12, 0xffff00);
			_txtReq.addNewText(200, "", 12, 0xffff00);
			_txtReq.addNewText(200, "", 12, 0xffff00);
			_txtReq.addNewText(200, "", 12, 0xffff00);
		}
		
		public override function get height():Number
		{
			return _scaleBg.height;
		}
		
		public override function get width():Number
		{
			return _scaleBg.width;
		}
		
		public override function set data(value:*):void
		{
			super.data = value;
			if(value is ItemData)
			{
				_rune = SkillConfig.instance.getRuneByItemCode((value as ItemData).itemCode);
			}
			else
			{
				_rune = value as TRune;
			}
			
			if(_rune == null)
			{
				return;
			}
			var isActived:Boolean = (Cache.instance.skill.getMyRune(_rune.runeId) != null);
			var myY:int;
			if(isActived)
			{
				myY = updateActivedMode();
			}
			else
			{
				myY = updateUnactivedMode();
			}
			
			_scaleBg.setSize(200 + paddingLeft + paddingRight, myY + paddingBottom + paddingTop);
		}
		
		private function updateUnactivedMode():int
		{
			var myY:int = 20;
			_txtName.text = _rune.name; 
			
			// 下一等级
			_txtLevel.htmlText = Language.getStringByParam(20225, _rune.level);
			_txtDesc.htmlText = _rune.description;
			// 调整第二个分割线的位置
			_line2.y = _txtDesc.y + _txtDesc.textHeight + 4;
			
			// 移除
			DisplayUtil.removeMe(_txtLevel2);
			DisplayUtil.removeMe(_txtDesc2);
			DisplayUtil.removeMe(_line3);
			if(_txtReq.parent == null)
			{
				contentContainer2D.addChild(_txtReq);
			}
			
			updateNeed(_rune);
			_txtReq.y = _line2.y + 6;
			
			myY = _txtReq.y + _txtReq.getTextByIndex(4).y + 20;
			
			return myY;
		}
		
		private function updateActivedMode():int
		{
			var myY:int = 20;
			_txtName.text = _rune.name; 
			
			// 当前等级
			_txtLevel.htmlText = Language.getStringByParam(20224, _rune.level);
			_txtDesc.htmlText = _rune.description;
			// 调整第二个分割线的位置
			_line2.y = _txtDesc.y + _txtDesc.textHeight + 4;
			
			// 下一等级
			_txtLevel2.y = _line2.y + 6;
			_txtDesc2.y = _txtLevel2.y + 20;
			var next:TRune = SkillConfig.instance.getNextLevelRune(_rune.runeId);
			
			if(_txtLevel2.parent == null)
			{
				contentContainer2D.addChild(_txtLevel2);
			}
			if(next == null)
			{
				// 已经满级 30223
				_txtLevel2.htmlText = Language.getStringByParam(20225, Language.getString(30223));
				DisplayUtil.removeMe(_txtDesc2);
				DisplayUtil.removeMe(_line3);
				DisplayUtil.removeMe(_txtReq);
				myY = _txtLevel2.y + 20;
			}
			else
			{
				_txtLevel2.htmlText = Language.getStringByParam(20225, next.level);
				if(_txtDesc2.parent == null)
				{
					contentContainer2D.addChild(_txtDesc2);
				}
				if(_line3.parent == null)
				{
					contentContainer2D.addChild(_line3);
				}
				if(_txtReq.parent == null)
				{
					contentContainer2D.addChild(_txtReq);
				}
				
				updateNeed(next);
				
				if(_line3.parent == null)
				{
					contentContainer2D.addChild(_line3);
				}
				_line3.y = _txtDesc2.y + _txtDesc2.height + 4;
				_txtReq.y = _line3.y + 6;
				myY = _txtReq.y + _txtReq.getTextByIndex(4).y + 20;
			}
			return myY;
		}
		
		private function updateNeed(next:TRune):void
		{
			var skill:TSkill = SkillConfig.instance.getFirstSkillBySerialId(_rune.skillBelong);
			var mySkill:SkillInfo = Cache.instance.skill.getSkillBySerialId(_rune.skillBelong);
			
			_txtDesc2.htmlText = next.description;
			_txtReq.setText(0, Language.getString(20226));
			// 技能
			if(mySkill == null || mySkill.tSkill.skillLevel < next.skillBelongLevel)
			{
				_txtReq.setText(1, Language.getStringByParam(20231, skill.name, next.skillBelongLevel));
			}
			else
			{
				_txtReq.setText(1, Language.getStringByParam(20227, skill.name, next.skillBelongLevel));
			}
			// 经验
			if(next.exp > Cache.instance.role.roleInfo.experience)
			{
				_txtReq.setText(2, Language.getStringByParam(20228,
					"<font color='#ff0000'>" + next.exp + "</font>"));
			}
			else
			{
				_txtReq.setText(2, Language.getStringByParam(20228, next.exp));
			}
			// 铜币
			if(next.coin > Cache.instance.role.money.coin + Cache.instance.role.money.coinBind)
			{
				_txtReq.setText(3, Language.getStringByParam(20229,
					"<font color='#ff0000'>" + next.coin + "</font>"));
			}
			else
			{
				_txtReq.setText(3, Language.getStringByParam(20229, next.coin));
			}
			// 符能
			if(next.runicPower > Cache.instance.role.money.runicPower)
			{
				_txtReq.setText(4, Language.getStringByParam(20230,
					"<font color='#ff0000'>" + next.runicPower + "</font>"));
			}
			else
			{
				_txtReq.setText(4, Language.getStringByParam(20230, next.runicPower));
			}
		}
	}
}