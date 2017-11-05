/**
 * 2014-3-28
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.IToolTipBaseItem;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.common.text.AutoLayoutTextContainer;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.DefInfo;
	import mortal.game.resource.info.item.AttributeData;
	import mortal.game.resource.info.item.EquipmentSuitData;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemEquipInfo;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.common.tooltip.ToolTipUtil;
	import mortal.game.view.common.tooltip.tooltips.base.ToolTipScaleBg;
	import mortal.game.view.common.tooltip.tooltips.equipment.ToolTipStoneData;
	import mortal.game.view.common.tooltip.tooltips.equipment.ToolTipStoneItem;
	import mortal.game.view.common.util.AttributeUtil;
	import mortal.game.view.common.util.EquipmentUtil;
	import mortal.game.view.shopMall.view.ShopSellItem;
	
	public class ToolTipEquipment extends ToolTipScaleBg implements IToolTipBaseItem
	{
		private var _txtName:GTextFiled;
		private var _icon:ShopSellItem;
		private var _txtStrenLv:BitmapNumberText;
		private var _lockIcon:GBitmap;
		private var _txtBind:GTextFiled;
		private var _txtFight:GTextFiled;
		private var _txtSuitType:GTextFiled;
		private var _txtLevel:GTextFiled;
		private var _txtCareer:GTextFiled;
		private var _txtNaijiu:GTextFiled;
		
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
		// 宝石属性
		private var _baoshiContainer:GSprite;
		private var _txtBaoShi:GTextFiled;
		private var _txtBaoShi2:GTextFiled;
		private var _lineBaoShi:ScaleBitmap;
		private var _stones:Array;
		// 套装属性
		private var _suitContainer:GSprite;
		private var _txtSuit:GTextFiled;
		private var _txtSuitName:GTextFiled;
		private var _suits:Array;
		private var _suitAdds:Array;
		private var _lineSuit:ScaleBitmap;
		// 描述
		private var _txtDesc:GTextFiled;
		// 提示
		protected var _txtTips:GTextFiled;
		
		///////////////////////////////// 数据
		private var _data:ItemData;
		private var _info:ItemEquipInfo;
		
		public function ToolTipEquipment()
		{
			super();
			createChildren();
			paddingBottom = 8;
			paddingLeft = 12;
			paddingRight = 8;
			paddingTop = 8;
		}
		
		public override function set data(value:*):void
		{
			_data = value as ItemData;
			if(_data == null)
			{
				return;
			}
			super.data = _data;
			_info = _data.itemInfo as ItemEquipInfo;
			
			// 更新tips
			setBg(ToolTipUtil.getBgNameByColor(_info.color));
			
			// 最上面的部分, 名字图标
			updateTopPart();
			// 更新基础属性
			updateBasicAttr();
			if(_data.extInfo != null)
			{
				// 更新洗练数据
				updateXiLianAtrr();
				// 宝石属性
				updateStonesAttr();
				
				_txtXilian2.text = Language.getString(20215);
				_txtBaoShi2.text = Language.getString(20216);
				
				if(_txtXilianLeft.parent == null)
				{
					contentContainer2D.addChild(_txtXilianLeft);
				}
				if(_txtXilianRight.parent == null)
				{
					contentContainer2D.addChild(_txtXilianRight);
				}
				if(_baoshiContainer.parent == null)
				{
					contentContainer2D.addChild(_baoshiContainer);
				}
			}
			else
			{
				DisplayUtil.removeMe(_txtXilianLeft);
				DisplayUtil.removeMe(_txtXilianRight);
				DisplayUtil.removeMe(_baoshiContainer);
				_txtXilian2.text = "（" + Language.getString(20220) + "）";// 未洗练
				if(_data.itemInfo.level < 40)
				{
					_txtBaoShi2.text = "（" + Language.getString(20221) + "）";
				}
				else
				{
					_txtBaoShi2.text = Language.getString(20216);
				}
			}
			// 套装属性
			updateSuitAttr();
			// 更新坐标
			updateLayout();
			// 更新背景
			_scaleBg.setSize(288, paddingTop + paddingBottom + _txtTips.y + 20);
			// 更新名字
			updateName();
		}
		
		public function setBuyback(price:int):void
		{
			if(price < 0)
			{
				_txtTips.text = Language.getString(20248);
				_txtTips.textColor = 0x36F8FD;
			}
			else
			{
				var priceName:String = GameDefConfig.instance.getEPrictUnitName(_data.itemInfo.sellUnit);
				var isEnougth:Boolean = Cache.instance.role.enoughMoney(_data.itemInfo.sellUnit, price);
				if(!isEnougth)
				{
					_txtTips.textColor = 0xff0000;
				}
				else
				{
					_txtTips.textColor = 0x00ff00;
				}
				_txtTips.text = Language.getStringByParam(20260, price.toString() + priceName);
			}
		}
		
		public override function get width():Number
		{
			return _scaleBg.width;
		}
		
		public override function get height():Number
		{
			return _scaleBg.height;
		}
		
		private function updateTopPart():void
		{
			var isBind:Boolean = ItemsUtil.isBind(_data);
			_icon.itemData = _data;
			_icon.isBind = isBind;
			
			if(_data.extInfo != null && _data.extInfo.strengthen > 0)
			{
				_txtStrenLv.text = "+" + _data.extInfo.strengthen.toString();
				_txtStrenLv.x = 69 - _txtStrenLv.width;
			}
			else
			{
				_txtStrenLv.text = "";
			}
			
			_lockIcon.visible = isBind;
			if(isBind)
			{
				_txtBind.textColor = GlobalStyle.colorHongUint;
				_txtBind.text = Language.getString(20206);
				_txtBind.x = 100;
			}
			else
			{
				_txtBind.textColor = GlobalStyle.colorLvUint;
				_txtBind.text = Language.getString(20205);
				_txtBind.x = 79;
			}
			
			_txtFight.text = Language.getString(30221) + "：" + "还没有";
			
			if(_info.suitGroup > 0)
			{
				_txtSuitType.text = Language.getString(20208);
			}
			else
			{
				_txtSuitType.text = Language.getString(20207);
			}
			
			// 等级
			_txtLevel.text = Language.getString(30011) + "：" + _info.level.toString();
			// 职业
			_txtCareer.text = GameDefConfig.instance.getCarrer(_info.career);
			// 耐久度
			_txtNaijiu.text = Language.getString(20209) + "还没有" + "/" + _info.durable;
			
//			if( _info.descStr != null)
//			{
			_txtDesc.height = 200;
				_txtDesc.htmlText = "实现愿望要努力，实在做事用臂力，若善用潜力一分一刻一招一式一挥一击一百倍威力；" + 
					"大敌临阵尽我力， 大路闯荡用魄力，聚会神力一分一刻一招一式一挥一击都有气力";//_info.descStr;
//				_txtDesc.height = _txtDesc.numLines * (_txtDesc.defaultTextFormat.size + int(_txtDesc.defaultTextFormat.leading) + 5);
				_txtDesc.height = _txtDesc.textHeight + 8;
//			}
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
			var left:int = Math.ceil(attrs.length/2);
			var right:int = attrs.length - left;
			
			_txtXilianLeft.split(left);
			for(var i:int = 0; i < left; i++)
			{
				if(_txtXilianLeft.getTextByIndex(i) == null)
				{
					_txtXilianLeft.addNewText(220, "", 12, GlobalStyle.colorLanUint);
				}
				var attr:AttributeData = attrs[i];
				_txtXilianLeft.setText(i, attr.name + "：" + attr.value, false);
			}
			
			_txtXilianRight.split(right);
			for(i = 0; i < right; i++)
			{
				if(_txtXilianRight.getTextByIndex(i) == null)
				{
					_txtXilianRight.addNewText(220, "", 12, GlobalStyle.colorLanUint);
				}
				attr = attrs[i + right];
				_txtXilianRight.setText(i, attr.name + "：" + attr.value, false);
			}
		}
		
		private var _stoneNum:int = 0;
		private function updateStonesAttr():void
		{
			var datas:Array = EquipmentUtil.getEquipmentStonesData(_data);
			_stoneNum = datas.length;
			for(var i:int = 0; i < datas.length; i++)
			{
				var data:ToolTipStoneData = datas[i];
				var stone:ToolTipStoneItem = _stones[i];
				stone.stoneData = data;
				if(stone.parent == null)
				{
					_baoshiContainer.addChild(stone);
				}
			}
			for(i = _stoneNum; i < _stones.length; i++)
			{
				stone = _stones[i];
				DisplayUtil.removeMe(stone);
			}
		}
		
		private function updateSuitAttr():void
		{
			var data:EquipmentSuitData =EquipmentUtil.getEquipmentSuitData(_data);
			var has:Array = data.codeHas;
			for(var i:int = 0; i < data.codes.length; i++)
			{
				var code:int = data.codes[i];
				var info:ItemInfo = ItemConfig.instance.getConfig(code);
				var txt:GTextFiled = _suits[i];
				txt.htmlText = info.htmlName;
				if(has.indexOf(code.toString()) >= 0)
				{
					txt.filters = [];
				}
				else
				{
					txt.filters [FilterConst.colorFilter];
				}
			}
			
			txt = _suitAdds[0];
			txt.text = data.suitDes[0];
			if(has.length > 2)
			{
				txt.filters = [];
			}
			else
			{
				txt.filters = [FilterConst.colorFilter];
			}
			
			txt = _suitAdds[1];
			txt.text = data.suitDes[1];
			if(has.length > 4)
			{
				txt.filters = [];
			}
			else
			{
				txt.filters = [FilterConst.colorFilter];
			}
			
			txt = _suitAdds[2];
			txt.text = data.suitDes[2];
			if(has.length > 7)
			{
				txt.filters = [];
			}
			else
			{
				txt.filters = [FilterConst.colorFilter];
			}
			
			//
			_txtSuitName.htmlText = HTMLUtil.addColor(data.name + "(" + has.length + "/" + data.codes.length + ")",
				ColorConfig.instance.getItemColorString(data.color));
		}
		
		private function updateName():void
		{
			_txtName.width = _scaleBg.width;
			var def:DefInfo = GameDefConfig.instance.getEPrefixx(_data.itemInfo.color, 0);
			if(_data.extInfo != null)
			{
				def = GameDefConfig.instance.getEPrefixx(_data.extInfo.qual, 0);
			}
			var str:String = HTMLUtil.addColor("[" + def.text + "]", def.text1);
			if(_data.extInfo != null && _data.extInfo.strengthen > 0)
			{
				var color:String = ColorConfig.instance.getItemColorString(_data.extInfo.qual);
				if(_data.extInfo.currentStrengthen != 0 || _data.extInfo.currentStrengthen == 10000) // 完美+00xx
				{
					str += HTMLUtil.addColor(_data.itemInfo.name + "(" + Language.getString(20218) + "+" + _data.extInfo.strengthen + ")", color);
				}
				else
				{
					str += HTMLUtil.addColor(_data.itemInfo.name + "(+" + _data.extInfo.strengthen + ")", color);
				}
			}
			else
			{
				str += _data.itemInfo.htmlName;
			}
			_txtName.htmlText = str;
			_txtName.x = -6;
		}

		private function createChildren():void
		{
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.CENTER;
			tf.size = 14;
			tf.bold = true;
			_txtName = UIFactory.gTextField("", -6, 0, 220, 25, this, tf);
			
			_icon = UICompomentPool.getUICompoment(ShopSellItem);
			_icon.x = 0;
			_icon.y = 26;
			_icon.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,6,6);
			_icon.createDisposedChildren();
			this.addChild(_icon);
			_icon.isShowLock = false;
			
//			_icon = UIFactory.baseItem(0, 26, 68, 68, contentContainer);
//			_icon.bgName = ImagesConst.ShopItemBg;
//			_icon.isShowLock = false;
			
			tf = GlobalStyle.embedNumberTf;
			tf.color = GlobalStyle.colorHuangUint;
			tf.align = TextFormatAlign.RIGHT;
			_txtStrenLv = UIFactory.bitmapNumberText(_icon.x, _icon.y + 50, "EquipmentTipsNumber.png", 16, 16, -5, this);
			
			_lockIcon = UIFactory.bitmap(ImagesConst.LockIcon, 81, 34, contentContainer2D);
			_txtBind = UIFactory.gTextField("", 100, 30, 100, 20, contentContainer2D);
			_txtFight = UIFactory.gTextField("", 158, 30, 120, 20, contentContainer2D);
			_txtFight.textColor = 0xF2C95F;
			
			_txtSuitType = UIFactory.gTextField("", 79, 52, 100, 20, contentContainer2D);
			_txtLevel = UIFactory.gTextField("", 158, 52, 100, 20, contentContainer2D);
			
			_txtCareer = UIFactory.gTextField("", 79, 74, 100, 20, contentContainer2D);
			_txtCareer.textColor = 0xF2C95F;
			_txtNaijiu = UIFactory.gTextField("", 158, 74, 120, 20, contentContainer2D);
			
			/////////////////////////////////////////////////// 基础属性
			_txtBasic = UIFactory.gTextField(Language.getString(20210), 0, 114, 100, 20, contentContainer2D);
			_txtBasic.textColor = GlobalStyle.colorChenUint;
			_txtBasic2 = UIFactory.gTextField(Language.getString(20214), 79, 114, 160, 20, contentContainer2D);
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
			
			
			_lineBasic = UIFactory.bg(0, 186, 256, 2, contentContainer2D, ImagesConst.SplitLine);
			
			/////////////////////////////////////////////////// 洗练属性
			_txtXilian = UIFactory.gTextField(Language.getString(20211), 0, 194, 100, 20, contentContainer2D);
			_txtXilian.textColor = GlobalStyle.colorChenUint;
			_txtXilian2 = UIFactory.gTextField(Language.getString(20215), 79, 194, 160, 20, contentContainer2D);
			
			_txtXilianLeft = new AutoLayoutTextContainer();
			_txtXilianLeft.x = _txtXilian.x;
			_txtXilianLeft.y = _txtXilian.y + 22;
			_txtXilianLeft.verticalGap = -7;
			contentContainer2D.addChild(_txtXilianLeft);
			
			_txtXilianRight = new AutoLayoutTextContainer();
			_txtXilianRight.x = _txtXilian.x + 130;
			_txtXilianRight.y = _txtXilian.y + 22;
			_txtXilianRight.verticalGap = -7;
			contentContainer2D.addChild(_txtXilianRight);
			
			_lineXilian = UIFactory.bg(0, 264, 256, 2, contentContainer2D, ImagesConst.SplitLine);
			
			/////////////////////////////////////////////////// 宝石属性
		
			_txtBaoShi = UIFactory.gTextField(Language.getString(20212), 0, 271, 100, 20, contentContainer2D);
			_txtBaoShi.textColor = GlobalStyle.colorChenUint;
			_txtBaoShi2 = UIFactory.gTextField(Language.getString(20216), 79, 271, 160, 20, contentContainer2D);
			
			_baoshiContainer = new GSprite();
			contentContainer2D.addChild(_baoshiContainer);
			_stones = [];
			for(var i:int = 0; i < 8; i++)
			{
				var stone:ToolTipStoneItem = new ToolTipStoneItem();
				_baoshiContainer.addChild(stone);
				_stones.push(stone);
				if(i%2 == 0)
				{
					stone.x = _txtBaoShi.x;
				}
				else
				{
					stone.x = _txtBaoShi.x + 130;
				}
				stone.y = int(i/2)*33;
			}
			
			_lineBaoShi = UIFactory.bg(0, 391, 256, 2, contentContainer2D, ImagesConst.SplitLine);
			
			/////////////////////////////////////////////////// 套装属性
			_suitContainer = new GSprite(); // 396
			contentContainer2D.addChild(_suitContainer);
			_txtSuit = UIFactory.gTextField(Language.getString(20213), 0, 0, 100, 20, _suitContainer);
			_txtSuit.textColor = GlobalStyle.colorChenUint;
			_txtSuitName = UIFactory.gTextField("", 79, 0, 160, 20, _suitContainer);
			
			_suits = [];
			_suits.push(UIFactory.gTextField("", _txtSuit.x + 24, _txtSuit.y + 17, 120, 20, _suitContainer));
			_suits.push(UIFactory.gTextField("", _txtSuit.x + 65, _txtSuit.y + 17, 120, 20, _suitContainer));
			_suits.push(UIFactory.gTextField("", _txtSuit.x + 106, _txtSuit.y + 17, 120, 20, _suitContainer));
			_suits.push(UIFactory.gTextField("", _txtSuit.x + 147, _txtSuit.y + 17, 120, 20, _suitContainer));
			_suits.push(UIFactory.gTextField("", _txtSuit.x + 24, _txtSuit.y + 34, 120, 20, _suitContainer));
			_suits.push(UIFactory.gTextField("", _txtSuit.x + 65, _txtSuit.y + 34, 120, 20, _suitContainer));
			_suits.push(UIFactory.gTextField("", _txtSuit.x + 106, _txtSuit.y + 34, 120, 20, _suitContainer));
			
			_suitAdds = [];
			_suitAdds.push(UIFactory.gTextField("", _txtSuit.x + 24, _txtSuit.y + 51, 220, 20, _suitContainer, GlobalStyle.textFormatLv));
			_suitAdds.push(UIFactory.gTextField("", _txtSuit.x + 24, _txtSuit.y + 68, 220, 20, _suitContainer, GlobalStyle.textFormatLv));
			_suitAdds.push(UIFactory.gTextField("", _txtSuit.x + 24, _txtSuit.y + 85, 220, 20, _suitContainer, GlobalStyle.textFormatLv));
			
			_lineSuit = UIFactory.bg(0, 107, 256, 2, _suitContainer, ImagesConst.SplitLine);
			
			
			// 描述
			_txtDesc = UIFactory.gTextField("", 0, _lineSuit.y + 4, 270, 120, contentContainer2D, 
				GlobalStyle.textFormatPutong.setLeading(-3));
			_txtDesc.multiline = true;
			_txtDesc.wordWrap = true;
			
			_txtTips = UIFactory.gTextField(Language.getString(20248), 0, _txtDesc.y + 60, 280, 20, contentContainer2D);
			_txtTips.textColor = 0x36F8FD;
		}
		
		private function updateLayout():void
		{
			_txtBasicLeft.y = _txtBasicRight.y = _txtBasic.y + 25;
			_lineBasic.y = _txtBasicLeft.y + _txtBasicLeft.height;
			_txtXilian.y = _txtXilian2.y = _lineBasic.y + 4;
			_txtXilianLeft.y = _txtXilianRight.y = _txtXilian.y + 24;
			if(_txtXilianLeft.numChildren >= 1 && _txtXilianLeft.parent != null)
			{
				_lineXilian.y = _txtXilianLeft.y + _txtXilianLeft.numChildren * 18 - 3;
			}
			else
			{
				_lineXilian.y = _txtXilianLeft.y + 2 ;
			}
			_txtBaoShi.y = _txtBaoShi2.y = _lineXilian.y + 5;
			_baoshiContainer.y = _txtBaoShi.y + 22;
			if(_baoshiContainer.parent != null)
			{
				_lineBaoShi.y =  _baoshiContainer.y + _baoshiContainer.height + 4;
			}
			else
			{
				_lineBaoShi.y = _txtBaoShi.y + 23;
			}
			_suitContainer.y = _lineBaoShi.y + 4;
			_txtDesc.y = _suitContainer.y + 113;
			
			_txtTips.y = _txtDesc.y + _txtDesc.height;
		}

	}
}