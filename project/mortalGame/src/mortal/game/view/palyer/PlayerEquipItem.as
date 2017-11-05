package mortal.game.view.palyer
{
	import com.gengine.debug.Log;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.common.swfPlayer.SWFPlayer;
	import mortal.common.swfPlayer.data.ModelType;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemExInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.forging.data.ForgingConst;
	import mortal.mvc.core.Dispatcher;
	
	public class PlayerEquipItem extends BaseItem
	{
		private var _category:int;
		private var _type:int;
		/** 强化等级美术字 */
		private var _txtStrenLv:BitmapNumberText;
		private var _disabledBg:ScaleBitmap;
		/** 选中特效 */
		public static var SelEffectSwf:SWFPlayer;
		
		public function PlayerEquipItem()
		{
			super();
			_bitmap.x = 4;
			_bitmap.y = 4;
		}
	
		public function get category():int
		{
			return _category;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_txtStrenLv = UIFactory.bitmapNumberText(0, 22, "EquipmentTipsNumber.png", 16, 16, -5, this);
			this._disabledBg = UIFactory.bg(0,0,width,height,this,ImagesConst.PackDisable2);
			this._disabledBg.visible = false;
		}
		
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_disabledBg.dispose(isReuse);
			_txtStrenLv.dispose(isReuse);
			
			_disabledBg = null;
			_txtStrenLv = null;
		}
		
		/**
		 * 设置装备选中/非选中状态的显示效果 
		 * @param value
		 * @param type 1--黄色滤镜  2--蓝色滤镜
		 */
		public function setLight(value:Boolean,type:int = 1):void
		{
			if(value)
			{
				switch(type)
				{
					case ForgingConst.YellowFilter:
						this._bitmap.filters = [FilterConst.colorGlowFilter(0xffff00)];
						break;
					case ForgingConst.BlueFilter:
						this._bitmap.filters = [FilterConst.colorGlowFilter(0x00ffff)];
						break;
				}
			}
			else
			{
				if(this._bitmap != null)
				{
					this._bitmap.filters = [];
				}
			}
		}
		
		/**
		 * 设置装备选中/非选中状态的显示效果 
		 */		
		public function setSelEffect(value:Boolean):void
		{
			if(!PlayerEquipItem.SelEffectSwf)
			{
				PlayerEquipItem.SelEffectSwf = ObjectPool.getObject(SWFPlayer);
				PlayerEquipItem.SelEffectSwf.timeRate = 3;
				PlayerEquipItem.SelEffectSwf.move(21, 21);
				PlayerEquipItem.SelEffectSwf.load("ArroundEffect.swf", ModelType.NormalSwf, null);
			}
			if(value)
			{
				this.addChild(PlayerEquipItem.SelEffectSwf);
			}
			else
			{
				DisplayUtil.removeMe(PlayerEquipItem.SelEffectSwf);
			}
		}
		
		/**
		 * 更新强化等级美术字 
		 */		
		public function updateStrengLevel():void
		{	
			if(this.itemData != null)
			{
				var level:int = this.itemData.extInfo.strengthen;
				if(level != 0)
				{
					_txtStrenLv.text = "+" + level;
					_txtStrenLv.x    = 40 - _txtStrenLv.width;
				}
				else
				{
					_txtStrenLv.text = "";
				}
			}
			else
			{
				_txtStrenLv.text = "";
			}
		}
		
		/**
		 * 设置装备镶嵌状态 
		 * @param value
		 */
		public function set isCanEmbed(value:Boolean):void
		{
			this._disabledBg.visible = !value;
			if(!value)
			{
				this._disabledBg.width   = _width - _paddingLeft * 2;
				this._disabledBg.height  = _height - _paddingTop * 2;
				this._disabledBg.x       = _paddingLeft;
				this._disabledBg.y       = _paddingTop;
			}
		}
		
		/**
		 * 更新装备镶嵌状态 
		 */		
		public function updateEmbedState():void
		{
			var exinfo:ItemExInfo = this.itemData.extInfo;
			for(var i:int = 1; i <= 8; i++)
			{
				if(exinfo["h"+i] == "0")
				{
					this.isCanEmbed = true;
					return;
				}
			}
			this.isCanEmbed = false;
		}
		
		
//		public function setEquipmentBg(category:int,type:int):void
//		{
//			_category = category;
//			_type = type;
//			if(_equipmentBg==null)
//			{
//				_equipmentBg = UIFactory.gBitmap(null,-3,-3);
//				addChildAt(_equipmentBg,0);
//			}
//		}
		
		
//		public function setNormalEquipBg(category:int,type:int):void
//		{
//			_category = category;
//			_type = type;
//			if(_equipmentBg==null)
//			{
//				_equipmentBg = ObjCreate.createBitmap(ImagesConst.equipmentBg,-3,-3);
//				addChildAt(_equipmentBg,0);
//			}
//		}
		
	}
}