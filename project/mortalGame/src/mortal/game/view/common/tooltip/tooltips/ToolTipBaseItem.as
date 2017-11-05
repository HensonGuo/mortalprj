/**
 * 2014-4-17
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import Message.Public.EPlayerItemPosType;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GTextFiled;
	import com.mui.manager.IToolTipBaseItem;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.common.text.AutoLayoutTextContainer;
	import mortal.game.cache.Cache;
	import mortal.game.manager.ClockManager;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.DefInfo;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.common.tooltip.ToolTipUtil;
	import mortal.game.view.common.tooltip.tooltips.base.ToolTipScaleBg;
	import mortal.game.view.shopMall.view.ShopSellItem;
	
	public class ToolTipBaseItem extends ToolTipScaleBg implements IToolTipBaseItem
	{
		protected var _txtType:GTextFiled;
		protected var _txtName:GTextFiled;
		protected var _icon:ShopSellItem;
		protected var _txtLv:AutoLayoutTextContainer;
		// 描述
		protected var _txtDesc:GTextFiled;
		// 提示
		protected var _txtTips:GTextFiled;
		
		///////////////////////////////// 数据
		protected var _data:ItemData;
		
		public function ToolTipBaseItem()
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
			// 更新背景
			setBg(ToolTipUtil.getBgNameByColor(_data.itemInfo.color));
			_scaleBg.setSize(288, paddingTop + paddingBottom + _txtDesc.y + _txtDesc.textHeight + 8);
			// 更新图标
			var isBind:Boolean = ItemsUtil.isBind(_data);
			_icon.itemData = _data;
			_icon.isBind = isBind;
			
			// 等级、品质、类型
			_txtLv.setText(0, Language.getStringByParam(20243, _data.itemInfo.level));
			_txtLv.setText(1, Language.getStringByParam(20244, ColorConfig.instance.getItemColor(_data.itemInfo.color).colorText));
			// 有使用时间限制的 为活动道具， 没时间限制的为普通道具
			var begin:int = _data.itemInfo.beginTime.time;
			var end:int = _data.itemInfo.endTime.time;
			if(begin == end)
			{
				_txtLv.setText(2, Language.getString(20247));
			}
			else
			{
				var now:int = ClockManager.instance.nowDate.time;
				if(now >= begin && now < end)
				{
					_txtLv.setText(2, Language.getString(20245));
				}
				else
				{
					_txtLv.setText(2, Language.getString(20245) + Language.getString(20246));
				}
			}
			
			// 描述
			if(_data.itemInfo.descStr != null)
			{
				_txtDesc.htmlText = _data.itemInfo.descStr;
			}
			else
			{
				_txtDesc.htmlText = "找策划";
			}
			_txtDesc.height = _txtDesc.textHeight + 7;
			
			// 更新名字
			updateName();
			
			_txtTips.y = _txtDesc.y + _txtDesc.height;
			
			// 更新背景的大小
			updateBg();
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
		
		public function updateBg():void
		{
			_scaleBg.setSize(288, _txtTips.y + 20 + paddingBottom + paddingTop);
		}
		
		public override function get width():Number
		{
			return _scaleBg.width;
		}
		
		public override function get height():Number
		{
			return _scaleBg.height;
		}
		
		protected function updateName():void
		{
			
			_txtName.width = _scaleBg.width;
			var def:DefInfo = GameDefConfig.instance.getECategory(_data.itemInfo.category);
			if(def != null)
			{
				_txtType.text = "[" + def.text + "]";
			}
			else
			{
				_txtType.text = "[未知类型]";
			}
			if(_txtType.text.length >= 4)
			{
				_txtType.x = 8;
			}
			else
			{
				_txtType.x = 16;
			}
			_txtName.htmlText = _data.itemInfo.htmlName
		}
		
		protected function createChildren():void
		{
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.size = 15;
			tf.bold = true;
			_txtType = UIFactory.gTextField("", 16, 0, 80, 24, this, tf);
			tf = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.CENTER;
			tf.size = 15;
			tf.bold = true;
			_txtName = UIFactory.gTextField("", -4, 0, 288, 24, this, tf);
			
			_icon = UICompomentPool.getUICompoment(ShopSellItem);
			_icon.x = 0;
			_icon.y = 26;
			_icon.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,6,6);
			_icon.createDisposedChildren();
			this.addChild(_icon);
			_icon.isShowLock = true;
			
			_txtLv = new AutoLayoutTextContainer();
			_txtLv.x = 80;
			_txtLv.y = 35;
			_txtLv.addNewText(200, "", 12, 0xffffff);
			_txtLv.addNewText(200, "", 12, 0xffffff);
			_txtLv.addNewText(200, "", 12, 0xffffff);
			_txtLv.verticalGap = -5;
			contentContainer2D.addChild(_txtLv);
			
			// 描述
			_txtDesc = UIFactory.gTextField("", 0, 110, 270, 120, contentContainer2D, 
				GlobalStyle.textFormatPutong.setLeading(-3));
			_txtDesc.multiline = true;
			_txtDesc.wordWrap = true;
			
			_txtTips = UIFactory.gTextField(Language.getString(20248), 0, _txtDesc.y + 60, 280, 20, contentContainer2D);
			_txtTips.textColor = 0x36F8FD;
		}
	}
}