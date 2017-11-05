/**
 * 2014-1-8
 * @author chenriji
 **/
package mortal.game.view.mainUI.shortcutbar
{

	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.manager.DragManager;
	import com.mui.manager.ToolTipsManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.item.CDItem;
	import mortal.game.view.skill.SkillInfo;
	import mortal.mvc.core.Dispatcher;
	
	public class ShortcutBarItem extends CDItem
	{
		private static var _bmpdCanNotUse:BitmapData;
		
		private var indexLabel:GTextFiled;
		
		private var lineBox:Sprite;
		
		private var _isShowBg:Boolean;
		
		private var _txtSkillTypeName:GTextFiled; // 技能， 需要显示技能的名字
		
		private var _bmpCanNotUse:Bitmap;
		
		private var _lockedIcon:GBitmap; //锁定图标, 锁的图标
		private var _isLocked:Boolean = false;
		
		private var _isDraging:Boolean = false;
		
		public function ShortcutBarItem(pos:int = 0)
		{
			super();
			this._pos = pos;
			_isShowLeftTimeEffect = true;
			_isShowFreezingEffect = true;
			this.buttonMode = true;
			this.useHandCursor = true;

			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			this.addEventListener(MouseEvent.CLICK, onShortcutsClickHandler);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onSlortcutsDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseupHandler);
		}
		
		public function setLock(isLock:Boolean):void
		{
			if(isLock == _isLocked)
			{
				return;
			}
			_isLocked = isLock;
			updateLockStatus();
		}
		private function updateLockStatus():void
		{
			this.isDragAble = !_isLocked;
			this.isDropAble = !_isLocked;
			this.isThrowAble = !_isLocked;
			if(_isLocked)
			{
				if(_lockedIcon == null)
				{
					_lockedIcon = UIFactory.bitmap(ImagesConst.LockIcon, 2, 2, this);//GlobalClass.getBitmap(ImagesConst.LockIcon);
					_lockedIcon.x = _width - 3 - _lockedIcon.width;
					_lockedIcon.y = _height - 3 - _lockedIcon.height;
				}
				if(_lockedIcon.parent == null && this.dragSource != null)
				{
					this.addChild(_lockedIcon);
				}
				else if(this.dragSource == null)
				{
					DisplayUtil.removeMe(_lockedIcon);
				}
			}
			else
			{
				DisplayUtil.removeMe(_lockedIcon);
			}
		}
		
		private function onSlortcutsDownHandler(event:MouseEvent):void
		{
			_isDraging=false;
			this.addEventListener(MouseEvent.MOUSE_MOVE, onShortcutMoveHandler);
		}
		
		private function mouseupHandler(evt:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onShortcutMoveHandler);
		}
		
		private function onShortcutMoveHandler(event:MouseEvent):void
		{
			_isDraging=true;
		}
		
		//点击快捷栏处理
		public function onShortcutsClickHandler(event:MouseEvent):void
		{
			if (!_isDraging)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarClicked, _pos));
			}
		}
		
		/**
		 * 不能使用的bitmapData 
		 * @return 
		 * 
		 */		
		public static function get bmpdCanNotUse():BitmapData
		{
			if(!_bmpdCanNotUse)
			{
				_bmpdCanNotUse = new BitmapData(36, 36);
				_bmpdCanNotUse.fillRect( new Rectangle(0, 0, 36, 36), 0x99000000);
			}
			return _bmpdCanNotUse;
		}
		
		/**
		 * 添加不能攻击蒙版 
		 * 
		 */		
		private function addCanNotAttackMask():void
		{
			if(!_bmpCanNotUse)
			{
				_bmpCanNotUse = new Bitmap();
				_bmpCanNotUse.x = 3;
				_bmpCanNotUse.y = 3;
				_bmpCanNotUse.bitmapData = bmpdCanNotUse;
			}
			this.addChild(_bmpCanNotUse);
		}
		
		/**
		 *移除不能攻击蒙版 
		 * 
		 */		
		private function removeCanNotAttackMask():void
		{
			if(_bmpCanNotUse && contains(_bmpCanNotUse))
			{
				removeChild(_bmpCanNotUse);
			}
		}
		
		override public function setSize(arg0:Number, arg1:Number):void
		{
			super.setSize(arg0, arg1);
		}
		
		override public function get bitmapdata():BitmapData
		{
			return super.bitmapdata;
		}
		
		override protected function configUI():void
		{
			if(!lineBox)
			{
				lineBox = new Sprite();
//				this.addChild(lineBox);
				lineBox.graphics.lineStyle(1,0x00ff00,1);//60e71e
				lineBox.graphics.drawRoundRect(1, 1, _width, _height, 4, 4);
				lineBox.graphics.endFill();
				lineBox.filters = [FilterConst.colorGlowFilter(0x00ff00)];
			}
			super.configUI();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			bgName = ImagesConst.shortcutItemBg;
			
			indexLabel = UIFactory.textField("",2,0,20,20,this,new GTextFormat(FontUtil.songtiName,11,0xffffff));
			indexLabel.autoSize = TextFieldAutoSize.LEFT;
			
			_txtSkillTypeName = UIFactory.textField("",20,20,20,20,this);
			_txtSkillTypeName.mouseEnabled = false;
			_txtSkillTypeName.textColor = 0xff0000;//CareerUtil.getSkillColor();
		}			
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			indexLabel.dispose(isReuse);
			_txtSkillTypeName.dispose(isReuse);
		}
		
		override protected function updateView():void
		{
			super.updateView();
			if(lineBox)
			{
				lineBox.width = _width;
				lineBox.height = _height;
			}
		}
		
		/**
		 * 当前人物状态是否可以使用技能 
		 * @param value
		 * 
		 */
		public function set canUseSkill(value:Boolean):void
		{
			_bmpCanNotUse.visible = value;
		}
		
		public function IndexLabelTxt(pos:int):void
		{
			indexLabel.htmlText = "<font color='#ffffff'>"+pos+"</font>";
		}
		
		/**
		 *设置标签 
		 * @param label
		 * 
		 */		
		public function setLabelTxt(label:String):void
		{
			indexLabel.htmlText = "<font color='#ffffff'>"+label+"</font>";
		}
		
		override public function set dragSource(value:Object):void
		{
			_dragSource = value;
			if(value)
			{
				if(value is SkillInfo)//技能
				{
					var skill:SkillInfo = value as SkillInfo;
					if(1)//skill.learned)
					{
						this.source = skill.tSkill.skillIcon+".jpg";
						updateCDEffect(value, CDDataType.skillInfo);
//						if(_cdData != null)
//						{
//							_cdData.startCoolDown();
//						}
					}
					else
					{
						detory();
					}
				}
				else if(value is ItemData)//物品
				{
					if(ItemData(value).itemInfo != null)
					{
						this.source = ItemData(value).itemInfo.url;
					}
					updateCDEffect(value, CDDataType.itemData);
					if(contains(_txtSkillTypeName))
					{
						removeChild(_txtSkillTypeName);
					}
				}
				else
				{
					this.source = null
					updateCDEffect();
					if(contains(_txtSkillTypeName))
					{
						removeChild(_txtSkillTypeName);
					}
				}
				ToolTipsManager.register(this);
			}
			else
			{
				if(contains(_txtSkillTypeName))
				{
					removeChild(_txtSkillTypeName);
				}
				
				this.source = null
				updateCDEffect();
				this.source = null;
				ToolTipsManager.unregister(this);
			}
			updateIsCanNotAttackMask();
		}
		
		/**
		 * 更新是否可以是否该技能 
		 * 
		 */		
		public function updateIsCanNotAttackMask():void
		{
//			if(_dragSource && _dragSource is SkillInfo)
//			{
//				var skillInfo:SkillInfo = _dragSource as SkillInfo;
//				if(!SkillsUtil.instance.isCanControlUseSkill(skillInfo))
//				{
//					addCanNotAttackMask();
//					return;
//				}
//			}
//			removeCanNotAttackMask();
		}
		
		/**
		 * 是否显示不能攻击的灰色mask 
		 * @param value
		 * 
		 */		
		public function set addCanNotAttackMaskValue(value:Boolean):void
		{
			if(value)
			{
				addCanNotAttackMask();
			}
			else
			{
				removeCanNotAttackMask();
			}
		}
		
//		override protected function resetBitmapSize():void
//		{
//			if(_bitmap)
//			{
//				_bitmap.width = 32;
//				_bitmap.height = 32;
//			}
//		}
		
		override public function get toolTipData():*
		{
			return this.dragSource;
//			if(!isShowToolTip)
//			{
//				return null;
//			}
//			var dragSource:Object = this.dragSource;
//			if(dragSource)
//			{
//				if(dragSource is SkillInfo)//技能
//				{
//					return (dragSource as SkillInfo).getShortToolTips();
//				}
//				else if(dragSource is ItemData)//物品
//				{
//					return (dragSource as ItemData).getToolTipData();
//				}
//				else if(dragSource is SPetInfo)
//				{
//					return PetUtil.getShortcutsPetTooltipsData(dragSource as SPetInfo);
//				}
//			}
//			return null;
		}
		
		override public function get isDragAble():Boolean
		{
			return _dragAble;
		}
		
		override public function set isDragAble(value:Boolean):void
		{
			_dragAble = value;
		}
		
		override protected function onMouseDown(e:MouseEvent):void
		{
			if(this.isDragAble && this.dragSource)
			{
				DragManager.instance.startDragItem(this,bitmapdata);
			}
		}
		
		public function detory():void
		{
			super.unRegisterEffects();
			_cdData = null;
			this.dragSource = null;
			this._txtSkillTypeName.text = "";
		}
		
		private function onMouseOverHandler(e:MouseEvent):void
		{
			this.addChild(lineBox);
		}
		
		private function onMouseOutHandler(e:MouseEvent):void
		{
			this.removeChild(lineBox);
		}
		
		/**
		 * 移除鼠标经过表面监听
		 * 
		 */		
		public function removeMouseOverOutListener():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
		}
		
		protected override function cdFinishedHandler():void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarCDFinished, _pos));
		}
		
	}
}