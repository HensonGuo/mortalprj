/**
 * 2014-4-15
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import Message.DB.Tables.TSkill;
	
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.common.text.AutoLayoutTextContainer;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.tooltip.tooltips.base.ToolTipScaleBg;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.SkillUtil;
	
	public class ToolTipSkillShowNext extends ToolTipScaleBg
	{
		private var _skill:TSkill;
		
		private var _txtType:GTextFiled;
		private var _txtName:GTextFiled;
		private var _cur:AutoLayoutTextContainer;
		private var _line1:ScaleBitmap;
		private var _next:AutoLayoutTextContainer;
		private var _txtMax:GTextFiled;
		private var _line2:ScaleBitmap;
		private var _txtDesc:GTextFiled;
		
		public function ToolTipSkillShowNext()
		{
			super();
			initUI();
		}
		
		public override function get width():Number
		{
			return 235;
		}
		
		public override function get height():Number
		{
			return _txtDesc.y + _txtDesc.textHeight + paddingBottom + paddingTop;
		}
		
		private function initUI():void
		{
			setBg(ImagesConst.ToolTipBg);
			this.paddingLeft = 8;
			this.paddingTop = 8;
			this.paddingBottom = 8;
			this.paddingRight = 8;
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.size = 14;
			tf.color = 0xffffff;
			tf.bold = true;
			_txtType = UIFactory.gTextField("", 0, 0, 120, 22, contentContainer2D, tf);
			tf = GlobalStyle.textFormatPutong;
			tf.size = 14;
			tf.color = 0x00ff00;
			tf.bold = true;
			_txtName = UIFactory.gTextField("", 85, 0, 120, 22, contentContainer2D, tf);
			_cur = new AutoLayoutTextContainer();
			_cur.y = 30;
			_cur.addNewText(120, "", 12, GlobalStyle.colorAnjinUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.verticalGap = -6;
			contentContainer2D.addChild(_cur);
			
			_line1 = UIFactory.bg(0, 137, 232, 2, contentContainer2D, ImagesConst.SplitLine);
			
			_txtMax = UIFactory.gTextField("", 0, 145, 200, 20, contentContainer2D);
			_txtMax.textColor = GlobalStyle.colorHongUint;
			_next = new AutoLayoutTextContainer();
			_next.y = 145;
			_next.addNewText(120, "", 12, GlobalStyle.colorHongUint);
			_next.addNewText(120, "", 12, GlobalStyle.colorHuiUint);
			_next.addNewText(120, "", 12, GlobalStyle.colorHuiUint);
			_next.addNewText(120, "", 12, GlobalStyle.colorHuiUint);
			_next.addNewText(120, "", 12, GlobalStyle.colorHuiUint);
			_next.addNewText(120, "", 12, GlobalStyle.colorHuiUint);
			_next.verticalGap = -6;
			contentContainer2D.addChild(_next);
			
			_line2 = UIFactory.bg(0, 260, 232, 2, contentContainer2D, ImagesConst.SplitLine);
			
			tf = GlobalStyle.textFormatPutong;
			tf.leading = -3;
			_txtDesc = UIFactory.gTextField("", 0, 268, 222, 100, contentContainer2D, tf);
			_txtDesc.multiline = true;
			_txtDesc.wordWrap = true;
		}
		
		public override function set data(value:*):void
		{
			super.data = value;
			var learaned:Boolean = (value as SkillInfo).learned;
			_skill = (value as SkillInfo).tSkill;
			_txtType.text = "[" + SkillUtil.getSkillUseTypeName(_skill) + "]";
			_txtName.text = _skill.name;
			
			if(learaned)
			{
				showLearnedMode();
			}
			else
			{
				showNoLearnedMode();
			}
			
			// 技能描述
			_txtDesc.htmlText = _skill.skillDescription;
			
			// 更新背景
			_scaleBg.setSize(this.width, this.height);
		}
		
		private function showNoLearnedMode():void
		{
			DisplayUtil.removeMe(_cur);
			DisplayUtil.removeMe(_txtMax);
			DisplayUtil.removeMe(_line1);
			if(_next.parent == null)
			{
				contentContainer2D.addChild(_next);
			}
			if(_line2.parent == null)
			{
				contentContainer2D.addChild(_line2);
			}
			
			_next.y = _cur.y;
			_line2.y = _next.y + 107;
			_txtDesc.y = _line2.y + 8;
			
			_next.setText(0, Language.getStringByParam(20242, _skill.skillLevel));
			_next.setText(1, Language.getStringByParam(20237, _skill.consume));
			_next.setText(2, Language.getStringByParam(20238, int(_skill.cooldownTime/1000)));
			_next.setText(3, Language.getStringByParam(20239, _skill.distance));
			_next.setText(4, Language.getStringByParam(20240, SkillUtil.getBassicAttackPercentage(_skill)));
			_next.setText(5, Language.getStringByParam(20241, SkillUtil.getAttachAttackValue(_skill)));
		}
		
		private function showLearnedMode():void
		{
			if(_line1.parent == null)
			{
				contentContainer2D.addChild(_line1);
			}
			if(_cur.parent == null)
			{
				contentContainer2D.addChild(_cur);
			}
			_cur.setText(0, Language.getStringByParam(20236, _skill.skillLevel));
			_cur.setText(1, Language.getStringByParam(20237, _skill.consume));
			_cur.setText(2, Language.getStringByParam(20238, int(_skill.cooldownTime/1000)));
			_cur.setText(3, Language.getStringByParam(20239, _skill.distance));
			_cur.setText(4, Language.getStringByParam(20240, SkillUtil.getBassicAttackPercentage(_skill)));
			_cur.setText(5, Language.getStringByParam(20241, SkillUtil.getAttachAttackValue(_skill)));
			
			if(_line2.parent == null)
			{
				contentContainer2D.addChild(_line2);
			}
			var nextSkill:TSkill = SkillConfig.instance.getSkillByLevel(_skill.series, _skill.skillLevel + 1);
			if(nextSkill == null) // 已经满级
			{
				DisplayUtil.removeMe(_next);
				if(_txtMax.parent == null)
				{
					contentContainer2D.addChild(_txtMax);
				}
				_txtMax.text = Language.getString(20107);
				_line2.y = _txtMax.y + 26;
			}
			else // 显示下一级
			{
				if(_next.parent == null)
				{
					contentContainer2D.addChild(_next);
				}
				DisplayUtil.removeMe(_txtMax);
				
				_next.setText(0, Language.getStringByParam(20242, nextSkill.skillLevel));
				_next.setText(1, Language.getStringByParam(20237, nextSkill.consume));
				_next.setText(2, Language.getStringByParam(20238, int(nextSkill.cooldownTime/1000)));
				_next.setText(3, Language.getStringByParam(20239, nextSkill.distance));
				_next.setText(4, Language.getStringByParam(20240, SkillUtil.getBassicAttackPercentage(nextSkill)));
				_next.setText(5, Language.getStringByParam(20241, SkillUtil.getAttachAttackValue(nextSkill)));
				_next.y = _line1.y + 8;
				_line2.y = _next.y + 107;
			}
			
			_txtDesc.y = _line2.y + 6;
		}
	}
}