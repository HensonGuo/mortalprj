/**
 * @date	2011-2-24 上午10:25:09
 * @author  wangyang
 * 物品的基类，所有的物品都要继续这个类
 */	
package mortal.game.view.common.item
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.resource.info.ImageInfo;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GImageCell;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.DragManager;
	import com.mui.manager.IDragDrop;
	import com.mui.manager.ToolTipsManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.display.BitmapDataConst;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.effect.CDFreezingEffect;
	import mortal.game.view.common.cd.effect.CDLeftTimeEffect;


	public class BaseItem extends CDItem
	{
		//数量
		protected var _amount:int = 0;
		protected var amountLabel:GTextFiled;
		
		// 一层暗色的罩子， 挡住这个物品
		protected var canNotUseEffect:ScaleBitmap;// 不能使用效果
		protected var _cannotUse:Boolean = false;// 是否不能使用
		
		// 绑定的锁头图标
		protected var lockedIcon:GBitmap; //锁定图标, 锁的图标
		private var _isBind:Boolean = false; // 是否绑定
		protected var _isShowLock:Boolean = false;// 这个属性控制lockedIcon是否生效
	
		
		//物品数据
		protected var _itemData:ItemData;	
		
		public function BaseItem()
		{
			super();
		}
		
		override protected function updateView():void
		{
			if(canNotUseEffect)
			{
				canNotUseEffect.width = _width;
				canNotUseEffect.height = _height;
			}
			
			if(lockedIcon)
			{
				lockedIcon.x = _paddingLeft;
				lockedIcon.y = _paddingTop;
			}
			
			if(amountLabel)
			{
				amountLabel.width = _width - _paddingLeft*2;
				amountLabel.x = _paddingLeft;
				amountLabel.y = _height - _paddingTop - amountLabel.height;
			}
			
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			var vTf:TextFormat = new GTextFormat();
			vTf.align = flash.text.TextFormatAlign.RIGHT;
			vTf.color = 0xFFFFFF;
			vTf.size = 11;
			this.mouseChildren = false;
			amountLabel = UIFactory.textField("", 0, 20, _width, 16, _middleLayer, vTf);
			amountLabel.mouseEnabled = false;
			amountLabel.autoSize = flash.text.TextFieldAutoSize.NONE;
			
			canNotUseEffect = ResourceConst.getScaleBitmap(ImagesConst.PackDisable2);
			_middleLayer.addChild(canNotUseEffect);
			canNotUseEffect.visible = _cannotUse;
			
//			UIFactory.setObjAttri(_bg,0,0, _width + _paddingLeft*2 ,_height + _paddingTop*2,_bottomLayer);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			amountLabel.dispose(isReuse);
			canNotUseEffect.dispose(isReuse);
			if(lockedIcon)
			{
				lockedIcon.dispose(isReuse);
				lockedIcon = null;
			}
			_amount = 0;
			amountLabel = null;
			canNotUseEffect = null;
			
			_cannotUse = false;
			_isShowLock = false;
			_isBind = false;   
			
			_paddingLeft = 2;
			_paddingTop = 2;
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			if(this.itemData && this.isDragAble && !_cannotUse)
			{
				DragManager.instance.startDragItem(this,bitmapdata);
			}
		}
		
		public function get isShowLock():Boolean
		{
			return _isShowLock;
		}

		public function set isShowLock(value:Boolean):void
		{
			_isShowLock = value;
		}
		
		public function setAmountLabelPos(x:int, y:int):void
		{
			amountLabel.x = x;
			amountLabel.y = y;
		}
		
		public function setAmountLabelFormat(tf:TextFormat):void
		{
			amountLabel.defaultTextFormat = tf;
		}
		
		/**
		 *设置数量标签显示内容 
		 * @param str
		 * 
		 */		
		public function setAmountLabel(str:String):void
		{
			amountLabel.htmlText = str;
		}
		
		public function get amount():int
		{
			return _amount;
		}
		
		public function set amount(value:int):void
		{
			if(_amount != value)
			{
				_amount = value;				
				if(_amount <= 1)
				{
					amountLabel.text = "";
				}
				else
				{
					amountLabel.text = _amount + "";
				}
			}
		}
		
		public function get canNotUse():Boolean
		{
			return _cannotUse;
		}
		
		public function set canNotUse(value:Boolean):void
		{
			_cannotUse = value;
			canNotUseEffect.visible = value;
		}
		
		public override function get dragSource():Object
		{
			return this.itemData;
		}
		
		public override function set dragSource(value:Object):void
		{
			super.dragSource = value;
			if(value is ItemData)
			{
				this.itemData = value as ItemData ;
			}
		}
		
		public function get itemData():ItemData
		{
			return _itemData;
		}
		
		/**
		 * 设置数据，  也可以通过 set itemCode来设置数据 
		 * @param value
		 * 
		 */		
		public function set itemData(value:ItemData):void
		{
			if(value)
			{
				_itemData = value;
				this.source = value.itemInfo.url;
				this.amount = value.serverData.itemAmount;
				isBind = ItemsUtil.isBind(_itemData);
			}
			else
			{
				this.source =null;
				this.amount = 0;
				_itemData = null;
				isBind = false;
			}
			super.toolTipData = value;
		}	
		
		/**
		 * 设置数据，  也可以通过 set  itemData来设置数据 
		 * @param value
		 * 
		 */		
		public function set itemCode(value:int):void
		{
			this.itemData = new ItemData(value);
		}
		
		public function set isBind(value:Boolean):void
		{
			_isBind = value;
			if(!_isShowLock)
			{
				if(lockedIcon)
				{
					lockedIcon.visible = false;
				}
				return;
			}
			if(_isBind)
			{
				if(!lockedIcon)
				{
					lockedIcon = GlobalClass.getBitmap(ImagesConst.LockIcon);
					_middleLayer.addChild(lockedIcon);
					lockedIcon.x = _paddingLeft;
					lockedIcon.y = _paddingTop;
				}
			}
			if(lockedIcon)
			{
				lockedIcon.visible = _isBind;
			}
		}
		
		public function get isBind():Boolean
		{
			return _isBind;
		}
		
		/**
		 * 设置物品样式 
		 * @param itemSize  大小类型(在ItemStyleConst里面有枚举)
		 * @param bgName  背景框的资源名称
		 * @param paddingTop 顶部间距
		 * @param paddingLeft  左边间距
		 * 
		 */		
		public function setItemStyle(sizeType:int,bgName:String,paddingTop:int,paddingLeft:int):void
		{
//			_width = _height = sizeType;
			_paddingTop = paddingTop;
			_paddingLeft = paddingLeft;
			
			setSize(sizeType + _paddingLeft*2,sizeType + _paddingTop*2);
			
			this.bgName = bgName;
			
			_bg.width = _width;
			_bg.height = _height;
			
			if(_bitmap)
			{
				_bitmap.x = _bg.x  + _paddingLeft;
				_bitmap.y = _bg.y  + _paddingTop;
			}
			
		}
		
		override public function set bgName(value:String):void
		{
			if(_bgName == value)
			{
				return;
			}
			_bgName = value;
			if(value)
			{
				_bg.bitmapData = GlobalClass.getBitmapData(value);
				_bg.scale9Grid = ResourceConst.getRectangle(value);
			}
			else
			{
				_bg.bitmapData = GlobalClass.getBitmapData(BitmapDataConst.AlphaBMD);
				_bg.scale9Grid = ResourceConst.getRectangle(BitmapDataConst.AlphaBMD);
			}
			_bg.width = _width;
			_bg.height = _height;
		}
		
		override protected function resetBitmapSize():void
		{
			if(_bitmap)
			{
				_bitmap.width = _width - _paddingLeft*2 ;
				_bitmap.height = _height - _paddingTop*2;
			}
		}
	}
}