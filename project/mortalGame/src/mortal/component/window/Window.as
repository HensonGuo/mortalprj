package mortal.component.window
{
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.IDragDrop;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.display.BitmapDataConst;
	import mortal.common.sound.SoundManager;
	import mortal.common.sound.SoundTypeConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.PopupManager;
	import mortal.game.manager.WindowLayer;
	import mortal.game.manager.window3d.IWindow3D;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	import mortal.mvc.interfaces.IStageResize;
	import mortal.mvc.interfaces.IUIView;
	import mortal.mvc.interfaces.IView;
	
	[Event(name="close",type="mortal.component.window.WindowEvent")]
	public class Window extends GSprite implements IUIView,IDragDrop,ILayer,IStageResize,IWindow3D
	{
		protected var _closeBtn:GLoadedButton;
		
		protected var _isAddClolseButton:Boolean = true;//是否添加关闭按钮
		
		protected var _isCenter:Boolean = false;  //是否居中显示
		
		protected var _isFirstCenter:Boolean = true; // 是否第一次居中
		
		protected var _titleSpriteHight:Number = 40;
		
		protected var _tweenable:Boolean = true;
		
		//显示对象  内容层
		protected var contentSprite:Sprite;
		
		protected var _titleSprite:Sprite;
		
		protected var _popupSprite:Sprite;
		
		//3D显示对象层
		protected var _content3DSprite:Sprite;
		
		//位于3D层上面的层次
		protected var _contentTopOf3DSprite:Sprite;		
		
		//最高层次的内容，例如指引遮罩覆盖所有的内容  
		protected var _contentHighest:Sprite;
		
		//configParams
		protected var _contentX:Number = 0;
		
		protected var _contentY:Number = 0;
		
		protected var _titleHeight:Number = 35;
		
		public var isForbidenDrag:Boolean = false;
		
		public function Window( $layer:ILayer = null )
		{
			super();
			Log.debug(this);
			if( $layer == null )
			{
				layer = LayerManager.windowLayer;
			}
			else
			{
				layer = $layer;
			}
			isDisposeRemoveSelf = false;
			isHideDispose = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,onWindowDownHandler);
		}
		
		public function get contentTopOf3DSprite():Sprite
		{
			return _contentTopOf3DSprite;
		}

		override protected function configUI():void
		{
			configParams();
			contentSprite = UIFactory.sprite();
			contentSprite.mouseEnabled = false;
			contentSprite.x = _contentX;
			contentSprite.y = _contentY;
			$addChild(contentSprite);
			
			_titleSprite = UIFactory.sprite();
			_titleSprite.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);			
			contentSprite.addChild(_titleSprite);
			
			_content3DSprite = UIFactory.sprite();
			_content3DSprite.mouseEnabled = false;
			_content3DSprite.x = _contentX;
			_content3DSprite.y = _contentY;
			$addChild(_content3DSprite);
			
			_contentTopOf3DSprite = UIFactory.sprite();
			_contentTopOf3DSprite.mouseEnabled = false;
			$addChild(_contentTopOf3DSprite);
			
			_contentHighest = UIFactory.sprite();
			_contentHighest.mouseEnabled = false;
			$addChild(_contentHighest);
			
			_popupSprite = UIFactory.sprite();
			_popupSprite.mouseEnabled = false;
			$addChild(_popupSprite);
			
			super.configUI();
		}
		
		protected function configParams():void
		{
			_contentX = 0;
			_contentY = 0;
		}
		
		override protected function onAddToStageCreate(e:Event):void
		{
			super.onAddToStageCreate(e);
			updateSize();
		}
		
		public function get closeBtn():GLoadedButton
		{
			return _closeBtn;
		}
		
		private function onWindowDownHandler( event:MouseEvent ):void
		{
			if( layer is WindowLayer )
			{
				PopupManager.setTop(this);
			}
			else
			{
				layer.setTop(this);
			}
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			if( _isAddClolseButton )
			{
				addCloseButton();
			}
		}
		
		protected function addCloseButton():void
		{
			_closeBtn = UIFactory.gLoadedButton("CloseButton",0,0,28,27,null);
			_closeBtn.focusEnabled = true;
			_closeBtn.name = "Window_Btn_Close";
			_closeBtn.configEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			this.addChild(_closeBtn);
		}
		
		/**提供复写 释放子对象*/
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			if(_closeBtn)
			{
				_closeBtn.dispose(isReuse);
				_closeBtn = null;
			}
		}
		
		public function get highestContentContainer():DisplayObjectContainer
		{
			return _contentHighest;
		}
		
		public function get contentContainer():Sprite
		{
			return contentSprite;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return contentSprite.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(contentSprite.contains(child))
			{
				return contentSprite.removeChild(child);
			}
			else
			{
				return $removeChild(child);
			}
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return contentSprite.addChildAt(child,index);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return contentSprite.removeChildAt(index);
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			return contentSprite.getChildAt(index);
		}
		
		override public function get numChildren():int
		{
			return contentSprite.numChildren;
		}
		
		override public function contains(child:DisplayObject):Boolean
		{
			return contentSprite.contains(child);
		}
		
		protected function $addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		protected function $removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		
		protected function $addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child,index);
		}
		
		protected function $removeChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}
		
		private var _stagerect:Rectangle = new Rectangle();
		private var _startX:Number;
		private var _startY:Number;
		private var _baseX:Number;
		private var _baseY:Number;
		
		protected function onMouseDownHandler( event:MouseEvent ):void
		{
			if (isForbidenDrag)
			{
				return;
			}
			_startX = event.stageX;
			_startY = event.stageY;
			_baseX = this.x;
			_baseY = this.y;
			
			Global.stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUpHandler);
//			Global.instance.addEnterFrame(onMouseMoveHandler);
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMoveHandler);
//			Global.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
//			if( _layer is WindowLayer )
//			{
//				_stagerect.x = 0;
//				_stagerect.y = 0;
//				_stagerect.width = this.stage.stageWidth;
//				_stagerect.height = this.stage.stageHeight - this._titleHeight;
//				this.startDrag(false,_stagerect);
//			}
//			else
//			{
//				this.startDrag(false);
//			}
		}
		
		protected var _isPositionChange:Boolean = false;
		
		override public function set x(arg0:Number):void
		{
//			if(arg0 != super.x)
//			{
				super.x = arg0;
				dispatchMoveChange();
//			}
		}
		
		override public function set y(arg0:Number):void
		{
//			if(arg0 != super.y)
//			{
				super.y = arg0;
				dispatchMoveChange();
//			}
		}
		
		private function dispatchMoveChange():void
		{
//			if(!_isPositionChange)
//			{
//				_isPositionChange = true;
				this.dispatchEvent(new WindowEvent(WindowEvent.POSITIONCHANGE));
//				Global.instance.callLater(resetMoveChange);
//			}
		}
		
//		private function resetMoveChange():void
//		{
//			_isPositionChange = false;
//		}
		
		private function onMouseUpHandler( event:MouseEvent ):void
		{
			removeDrag();
//			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
//			this.stopDrag();
		}
		
		private function removeDrag():void
		{
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUpHandler);
//			Global.instance.removeEnterFrame(onMouseMoveHandler);
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMouseMoveHandler);
		}
		
		/**
		 * 鼠标移动
		 * @param e
		 *
		 */
		public function onMouseMoveHandler(e:MouseEvent):void
		{
//			var stageX:Number = Global.stage.mouseX;
//			var stageY:Number = Global.stage.mouseY;
			var stageX:Number = e.stageX;
			var stageY:Number = e.stageY;
			var dragX:Number = (stageX - _startX) + _baseX;
			var dragY:Number = (stageY - _startY) + _baseY;
			dragX = dragX < 0 ? 0 : dragX;
			dragX = dragX > this.stage.stageWidth - this.width ? this.stage.stageWidth - this.width : dragX;
			dragY = dragY < 0 ? 0 : dragY;
			dragY = dragY > this.stage.stageHeight - this._titleHeight ? this.stage.stageHeight - this._titleHeight : dragY;
			this.x = dragX;
			this.y = dragY;
		}
		
		private var _bgBitmap:ScaleBitmap;
		
		private function setTitleSprite(w:Number,h:Number):void
		{
			if( _bgBitmap == null )
			{
				_bgBitmap = ResourceConst.getScaleBitmap(BitmapDataConst.AlphaBMD);
				_titleSprite.addChildAt(_bgBitmap,0);
			}
			_bgBitmap.width = w;
			_bgBitmap.height = h;
		}
		
		protected function closeBtnClickHandler(e:MouseEvent):void
		{
			//音效 by cjx
			SoundManager.instance.soundPlay(SoundTypeConst.UIclose);
			hide();
		}
		
		public function set titleHeight(value:Number):void
		{
			_titleHeight = value;
		}
		public function get titleHeight():Number
		{
			return _titleHeight;
		}
		
		protected function updateSize():void
		{
			updateBtnSize();
			setTitleSprite(this.width,_titleSpriteHight);
		}
		
		protected function updateBtnSize():void
		{
			if( _closeBtn )
			{
				_closeBtn.x = this.width - _closeBtn.width - 5;
				_closeBtn.y = 1;
			}
		}
		
		protected var _layer:ILayer;
		public function set layer(value:ILayer):void
		{
			_layer = value;
		}
		
		public function get layer():ILayer
		{
			return _layer;
		}
		
		private var _isHide:Boolean = true; // 是否隐藏
		
		public function get isHide():Boolean
		{
			return _isHide;
		}
		
		public function hide():void
		{
			if( _layer && !_isHide)
			{
				Global.stage.focus = Global.stage;
				this.stopDrag();
				Global.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
				_isHide = true;
				_layer.removePopup(this,_tweenable);
				this.dispatchEvent(new WindowEvent(WindowEvent.CLOSE));
				Dispatcher.dispatchEvent(new DataEvent(EventName.WindowClosed, this));
				
				var sprite:DisplayObject;
				while( _popupSprite.numChildren > 0 )
				{
					sprite = _popupSprite.getChildAt(0);
					if( sprite is IView)
					{
						(sprite as IView).hide();
					}
					else
					{
						this.removeChild(sprite);
					}
				}
				
			}
		}
		
		public function show(x:int=0,y:int=0):void
		{
			if( _layer )
			{
				if(_isHide)
				{
					_isHide = false;
					_layer.addPopUp(this);
					if( _isFirstCenter )
					{
						_layer.centerPopup(this);
						_isFirstCenter = _isCenter;
					}
					this.dispatchEvent(new WindowEvent(WindowEvent.SHOW));
					Dispatcher.dispatchEvent(new DataEvent(EventName.WindowShowed, this));
				}
				else
				{
					_layer.setTop(this);
				}
				if(x != 0 && y != 0)
				{
					_layer.setPosition(this,x,y);
				}
			}
		}
		
		/**
		 * 将窗口与左边聊天窗口对齐 
		 * 
		 */		
		public function leftToChat():void
		{
			if(this.layer is WindowLayer)
			{
				(this.layer as WindowLayer).leftToChat(this);
			}
		}
		
		/**
		 * 将窗口与右边任务对齐 
		 * 
		 */		
		public function rightToTask():void
		{
			if(this.layer is WindowLayer)
			{
				(this.layer as WindowLayer).rightToTask(this);
			}
		}
		
		/**
		 * 实现IDragDrop接口
		 */
		
		public function get isDragAble():Boolean
		{
			return  false;
		}
		
		public function get isDropAble():Boolean
		{
			return true;
		}
		
		public function get isThrowAble():Boolean
		{
			return false;
		}
		
		public function get dragSource():Object
		{
			return {};
		}
		
		public function set dragSource(value:Object):void
		{
			
		}
		
		public function canDrop(dragItem:IDragDrop, dropItem:IDragDrop):Boolean
		{
			return true;
		}
		
		/**
		 * 实现 ILayer 接口 
		 * 
		 */		
		
		public function addPopUp( displayObject:DisplayObject , modal:Boolean = false ):void
		{
			if( displayObject && _popupSprite.contains(displayObject) == false )
			{			
				_popupSprite.addChild(displayObject);
			}
		}
		
		public function centerPopup( displayObject:DisplayObject ):void
		{
			if( this is WindowLayer )
			{
				displayObject.x = (Global.stage.stageWidth - displayObject.width)/2;
				displayObject.y = (Global.stage.stageHeight - displayObject.height)/2;
			}
			else
			{
				displayObject.x = (this.width - displayObject.width)/2;
				displayObject.y = (this.height - displayObject.height)/2;
			}
		}
		
		public function setPosition( displayObject:DisplayObject,x:int,y:int ):void
		{
			displayObject.x = x;
			displayObject.y = y;
		}
		
		public function isTop( displayObject:DisplayObject ):Boolean
		{
			if( _popupSprite.contains(displayObject) )
			{
				return _popupSprite.getChildIndex( displayObject ) == _popupSprite.numChildren-1;
			}
			return false;
		}
		
		public function removePopup( displayObject:DisplayObject,tweenable:Boolean=true):void
		{
			if( _popupSprite.contains(displayObject) )
			{
				_popupSprite.removeChild(displayObject);
			}
		}
		
		public function isPopup( displayObject:DisplayObject  ):Boolean
		{
			return _popupSprite.contains(displayObject);
		}
		
		public function setTop( displayObject:DisplayObject ):void
		{
			if( _popupSprite.contains(displayObject) )
			{
				if( _popupSprite.getChildIndex(displayObject) != _popupSprite.numChildren -1 )
				{
					_popupSprite.setChildIndex(displayObject,_popupSprite.numChildren - 1);
				}
			}
		}
		
		public function resize( sw:Number , sh:Number ):void
		{
			var display:DisplayObject;
			for( var i:int=0;i<numChildren;i++ )
			{
				display = this.getChildAt(i);
				if(display is IView)
				{
					display.x *=sw;
					display.y *=sh;
				}
			}
		}
		
		override protected function updateView():void
		{
			updateSize();
			updateDisplayList();
		}
		
		protected function updateDisplayList():void
		{
			
		}
		
		public function stageResize():void
		{
			
		}
	}
}