/**
 * 2014-4-17
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import mortal.common.global.GlobalStyle;
	import mortal.common.text.AutoLayoutTextContainer;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.AttributeData;
	import mortal.game.resource.info.item.ItemEquipInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.util.AttributeUtil;
	import mortal.game.view.common.util.EquipmentUtil;

	public class ToolTipWingItem extends ToolTipBaseItem3D
	{
		// 基础属性
		private var _txtBasic:GTextFiled;
		private var _txtBasic2:GTextFiled;
		private var _txtBasicLeft:AutoLayoutTextContainer;
		private var _txtBasicRight:AutoLayoutTextContainer;
		private var _lineBasic:ScaleBitmap;
		// 洗练属性
		private var _txtXilian:GTextFiled;
		private var _txtXilian2:GTextFiled;
		private var _txtXilianLeft:AutoLayoutTextContainer;
		private var _txtXilianRight:AutoLayoutTextContainer;
		private var _lineXilian:ScaleBitmap;
		
		public function ToolTipWingItem()
		{
			super();
		}
		
		private var _info:ItemEquipInfo;
		public override function set data(value:*):void
		{
			super.data = value;
			_info = _data.itemInfo as ItemEquipInfo;
			updateBasicAttr();
			updateXiLianAtrr();
			updateBg();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			/////////////////////////////////////////////////// 基础属性
			_txtBasic = UIFactory.gTextField(Language.getString(20210), 0, 283, 100, 20, contentContainer2D);
			_txtBasic.textColor = GlobalStyle.colorChenUint;
			_txtBasic2 = UIFactory.gTextField(Language.getString(20214), 79, 283, 160, 20, contentContainer2D);
			_txtBasicLeft = new AutoLayoutTextContainer();
			_txtBasicLeft.x = _txtBasic.x;
			_txtBasicLeft.y = _txtBasic.y + 22;
			_txtBasicLeft.verticalGap = -7;
			this.addChild(_txtBasicLeft);
			
			_txtBasicRight = new AutoLayoutTextContainer();
			_txtBasicRight.x = _txtBasic2.x + 3;
			_txtBasicRight.y = _txtBasicLeft.y;
			_txtBasicRight.verticalGap = -7;
			this.addChild(_txtBasicRight);
			
			
			_lineBasic = UIFactory.bg(0, _txtBasic.y + 71, 256, 2, contentContainer2D, ImagesConst.SplitLine);
			
			/////////////////////////////////////////////////// 洗练属性
			_txtXilian = UIFactory.gTextField(Language.getString(20211), 0, 357, 100, 20, contentContainer2D);
			_txtXilian.textColor = GlobalStyle.colorChenUint;
			_txtXilian2 = UIFactory.gTextField(Language.getString(20215), 79, 357, 160, 20, contentContainer2D);
			
			_txtXilianLeft = new AutoLayoutTextContainer();
			_txtXilianLeft.x = _txtXilian.x;
			_txtXilianLeft.y = _txtXilian.y + 22;
			_txtXilianLeft.verticalGap = -7;
			this.addChild(_txtXilianLeft);
			
			_txtXilianRight = new AutoLayoutTextContainer();
			_txtXilianRight.x = _txtXilian.x + 130;
			_txtXilianRight.y = _txtXilian.y + 22;
			_txtXilianRight.verticalGap = -7;
			this.addChild(_txtXilianRight);
			
			_lineXilian = UIFactory.bg(0, _txtXilian.y + 71, 256, 2, contentContainer2D, ImagesConst.SplitLine);
			
			_txtDesc.y = _lineXilian.y + 8;
			_txtTips.y = _txtDesc.y + _txtDesc.height;
		}
		
		private function updateBasicAttr():void
		{
			var attrs:Vector.<AttributeData> = AttributeUtil.getEquipmentBasicAttrs(_data.itemInfo as ItemEquipInfo);
			var curNum:int = _txtBasicLeft.numChildren;
			var dNum:int = attrs.length - curNum;
			if(dNum > 0)
			{
				for(var i:int = 0; i < dNum; i++)
				{
					_txtBasicLeft.addNewText(120);
					_txtBasicRight.addNewText(120, "", 12, GlobalStyle.colorLvUint);
				}
			}
			else if(dNum < 0)
			{
				_txtBasicLeft.split(attrs.length);
				_txtBasicRight.split(attrs.length);
			}
			
			if(_data.extInfo != null)
			{
				var rate:Number = EquipmentUtil.getStrengthenAddRatio(_data);
			}
			else
			{
				rate = 0;
			}
			for(i = 0; i < attrs.length; i++)
			{
				var data:AttributeData = attrs[i];
				_txtBasicLeft.setText(i, data.name + ":" + data.value);
				if(rate > 0)
				{
					_txtBasicRight.setText(i, "(+" + (Math.ceil(data.value*rate)).toString() + ")");
				}
				else
				{
					_txtBasicRight.setText(i, "");
				}
			}
		}
		
		private function updateXiLianAtrr():void
		{
			var attrs:Vector.<AttributeData> = EquipmentUtil.getEquipmentXiLianAttrs(_data);
			var len:int = attrs.length>3?3:attrs.length;
			var curNum:int = _txtXilianLeft.numChildren;
			var i:int;
			var dNum:int = len - curNum;
			if(dNum > 0)
			{
				for(i = 0; i < dNum; i++)
				{
					_txtXilianLeft.addNewText(130, "", 12, GlobalStyle.colorLanUint);
				}
			}
			else if(dNum < 0)
			{
				_txtXilianLeft.split(len);
			}
			
			if(attrs.length <= 3)
			{
				_txtXilianRight.visible = false;
			}
			else
			{
				_txtXilianRight.visible = true;
				len = attrs.length - 3;
				curNum = _txtXilianRight.numChildren;
				dNum = len - curNum;
				if(dNum > 0)
				{
					for(i = 0; i < dNum; i++)
					{
						_txtXilianRight.addNewText(130, "", 12, GlobalStyle.colorLanUint);
					}
				}
				else if(dNum < 0)
				{
					_txtXilianRight.split(len);
				}
			}
			
			// 左边的
			len = Math.min(3, attrs.length);
			for(i = 0; i < len; i++)
			{
				var data:AttributeData = attrs[i];
				_txtXilianLeft.setText(i, data.name + "：" + data.value.toString(), false);
			}
			
			len = attrs.length;
			for(i = 3; i < len; i++)
			{
				data = attrs[i];
				_txtXilianRight.setText(i-3, data.name + "：" + data.value.toString(), false);
			}
		}
	}
}