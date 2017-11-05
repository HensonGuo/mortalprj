/**
 * 2014-1-9
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import Message.DB.Tables.TSkill;
	
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.common.text.AutoLayoutTextContainer;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.tooltip.tooltips.base.ToolTipScaleBg;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.SkillUtil;
	
	public class ToolTipSkill extends ToolTipScaleBg
	{
		private var _skill:TSkill;
		
		private var _txtDesc:GTextFiled;
		private var _txtType:GTextFiled;
		private var _txtName:GTextFiled;
		private var _cur:AutoLayoutTextContainer;
		private var _line1:ScaleBitmap;
		
		public function ToolTipSkill()
		{
			super();
			initUI();
		}
		
		
		
		public override function get width():Number
		{
			return _scaleBg.width;
		}
		
		public override function get height():Number
		{
			return _scaleBg.height;
		}
		
		private function initUI():void
		{
			setBg(ImagesConst.ToolTipBg);
			this.paddingLeft = 8;
			this.paddingTop = 8;
			this.paddingBottom = 8;
			this.paddingRight = 8;
			
			// 类型
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.size = 14;
			tf.color = 0xffffff;
			tf.bold = true;
			_txtType = UIFactory.gTextField("", 0, 0, 120, 22, contentContainer2D, tf);
			
			// 名字
			tf = GlobalStyle.textFormatPutong;
			tf.size = 14;
			tf.color = 0x00ff00;
			tf.bold = true;
			_txtName = UIFactory.gTextField("", 85, 0, 120, 22, contentContainer2D, tf);
			
			// 描述
			tf = GlobalStyle.textFormatPutong;
			tf.leading = -3;
			_txtDesc = UIFactory.gTextField("", 0, 30, 222, 100, contentContainer2D, tf);
			_txtDesc.multiline = true;
			_txtDesc.wordWrap = true;
			
			_line1 = UIFactory.bg(0, 30, 232, 2, contentContainer2D, ImagesConst.SplitLine);
			
			// 
			_cur = new AutoLayoutTextContainer();
			_cur.y = 137;
			_cur.addNewText(120, "", 12, GlobalStyle.colorAnjinUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.addNewText(120, "", 12, GlobalStyle.colorLanUint);
			_cur.verticalGap = -6;
			contentContainer2D.addChild(_cur);
		}
		
		public override function set data(value:*):void
		{
			super.data = value;
			_skill = (value as SkillInfo).tSkill;
			_txtType.text = "[" + SkillUtil.getSkillUseTypeName(_skill) + "]";
			_txtName.text = _skill.name;
			
			// 技能描述
			_txtDesc.htmlText = _skill.skillDescription;
			
			// 技能属性
			_cur.setText(0, Language.getStringByParam(20236, _skill.skillLevel));
			_cur.setText(1, Language.getStringByParam(20237, _skill.consume));
			_cur.setText(2, Language.getStringByParam(20238, int(_skill.cooldownTime/1000)));
			_cur.setText(3, Language.getStringByParam(20239, _skill.distance));
			_cur.setText(4, Language.getStringByParam(20240, SkillUtil.getBassicAttackPercentage(_skill)));
			_cur.setText(5, Language.getStringByParam(20241, SkillUtil.getAttachAttackValue(_skill)));
			
			_line1.y = _txtDesc.y + _txtDesc.textHeight + 8;
			_cur.y = _line1.y + 10;
			
			// 更新背景
			_scaleBg.setSize(235, _cur.y + _cur.height + paddingBottom + paddingTop - 3);
		}
	}
}