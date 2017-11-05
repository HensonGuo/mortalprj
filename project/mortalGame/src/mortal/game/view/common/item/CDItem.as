/**
 * 2014-1-10
 * @author chenriji
 **/
package mortal.game.view.common.item
{
	import com.gengine.core.IDispose;
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.resource.info.ImageInfo;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GImageCell;
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.DragManager;
	import com.mui.manager.IDragDrop;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.display.BitmapDataConst;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.cache.Cache;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.cd.ICDData;
	import mortal.game.view.common.cd.effect.CDEffectTimerType;
	import mortal.game.view.common.cd.effect.CDFreezingEffect;
	import mortal.game.view.common.cd.effect.CDLeftTimeEffect;
	
	public class CDItem extends GSprite implements IDragDrop,IToolTipItem
	{
		// 位置
		protected var _pos:int;

		public var dropChecktFunction:Function;//可以自定义检测是否可以放下的获取函数
		
		// 冷却相关//////////////////////////////////////////////////////////////////////////
		protected var _freezingEffect:CDFreezingEffect;
		protected var _isShowFreezingEffect:Boolean = false;
		
		protected var _leftTimeEffect:CDLeftTimeEffect;
		protected var _isShowLeftTimeEffect:Boolean = false;
		
		protected var _cdData:ICDData;
		protected var _myData:Object;
		
		// 拖动、丢弃、tips相关 ////////////////////////////////////////////////////////////////////
		protected var _dragAble:Boolean = true;
		protected var _dropAble:Boolean = true;
		protected var _throwAble:Boolean = true;
		protected var _isShowToolTip:Boolean = true;
		protected var _isRegistedToolTip:Boolean = false;
		
		// 图标相关 //////////////////////////////////////////////////////////////////////////////
		protected var _bitmapdata:BitmapData = null;
		protected var _bitmap:GBitmap = null;
		protected var imageUrl:String;
		
		protected var _bg:ScaleBitmap;
		protected var _bgName:String;
		
		// 层次相关
		protected var _bottomLayer:Sprite;
		protected var _middleLayer:Sprite;
		protected var _topLayer:Sprite;
		
		// 数据相关 ////////////////////////////////////////////////////////////////////////////////
		protected var _dragSource:Object;
		
		protected var _paddingTop:int = 2;
		protected var _paddingLeft:int = 2;
		
		public function CDItem()
		{
			_width = 32;
			_height = 32;
			super();
		}
		
		override protected function configUI():void
		{
			_bottomLayer = UIFactory.sprite(0,0,this);
			_middleLayer = UIFactory.sprite(0,0,this);
			_topLayer = UIFactory.sprite(0,0,this);
			setSize(40, 40);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			mouseEnabled = true;
			super.configUI();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			//给它创建一个透明的背景
			if(!_bgName)
			{
				_bgName = BitmapDataConst.AlphaBMD;
			}
			_bg = ResourceConst.getScaleBitmap(_bgName);
			UIFactory.setObjAttri(_bg,0,0,_width,_height,_bottomLayer);
			
			_bitmap = UIFactory.bitmap("", _paddingLeft, _paddingTop, _bottomLayer);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			if(_lastImageUrl != null)
			{
				LoaderManager.instance.removeResourceEvent(_lastImageUrl, onLoadCompleteHandler);
				_lastImageUrl = null;
			}
			_bg.dispose(isReuse);
			UIFactory.disposeGBitmap(_bitmap);
			_bg = null;
			_bitmap = null;
			dropChecktFunction = null;
			clearAllEffect();
			_bitmapdata = null;
			_lastImageUrl = "";
			_tooltipData = "";
			
			_dragAble = true;
			_dropAble = true;
			_throwAble = true;
			_isShowToolTip = true;
			_isRegistedToolTip = false;
			_paddingTop = 2;
			_paddingLeft = 2;
			_isShowFreezingEffect = false;
			_isShowLeftTimeEffect = false;
			_isShowToolTip = true;
			_isRegistedToolTip = false;
		}
		
		public function get pos():int
		{
			return _pos;
		}
		
		public function set pos(value:int):void
		{
			_pos = value;
		}
		
		protected function onAddToStage(e:Event):void
		{
			registerTips();
			registerEffects();
		}
		
		protected function onRemoveFromStage(e:Event):void
		{
			unRegisterTips();
			unRegisterEffects();
		}
		
		protected var _tooltipData:*;
		
		protected function judgeToolTip(e:Event = null):void
		{
			if(e && e.type == Event.ADDED_TO_STAGE && toolTipData
				|| !e && toolTipData && Global.stage.contains(this))
			{
				ToolTipsManager.register(this);
			}
			else
			{
				ToolTipsManager.unregister(this);
			}
		}
		
		/**
		 * 设置data的时候，必须调用此函数才会有CD的显示效果 
		 * @param source
		 * 
		 */		
		public function updateCDEffect(source:Object=null, cdDataType:int = 2):void
		{
			// 清除原来的
			unRegisterEffects();
			if(source == null)
			{
				_cdData = null;
				return;
			}
			_cdData = Cache.instance.cd.getCDData(source, cdDataType);
			registerEffects();
		}
		
		/**
		 * 是否在CD中 
		 * @return 
		 * 
		 */		
		public function get isCDing():Boolean
		{
			if(_cdData == null)
			{
				return false;
			}
			return _cdData.isCoolDown;
		}
		
		public function get toolTipData():*
		{
			return _tooltipData;
		}
		
		public function set toolTipData(value:*):void
		{
			_tooltipData = value;
			judgeToolTip();
		}
		
		public function set isShowToolTip(value:Boolean):void
		{
			_isShowToolTip = value;
			if(!_isShowToolTip)
			{
				unRegisterTips();
			}
			else
			{
				registerTips();
			}
		}
		
		protected function registerTips():void
		{
			if(_isShowToolTip && !_isRegistedToolTip)
			{
				ToolTipsManager.register(this);
				_isRegistedToolTip = true;
			}
		}
		
		protected function unRegisterTips():void
		{
			if(_isRegistedToolTip)
			{
				ToolTipsManager.unregister(this);
				_isRegistedToolTip = false;
			}
		}
		
		override protected function updateView():void
		{
			super.updateView();
			resetBitmapSize();
			_bg.width = _width;
			_bg.height = _height;
			resetEffectPlace();
		}
		
		protected function resetEffectPlace():void
		{
			if(_freezingEffect)
			{
				_freezingEffect.x = _width/2;
				_freezingEffect.y = _height/2;
				_freezingEffect.setMaskSize(_width - _paddingLeft*2, _height - _paddingTop*2);
			}
			if(_leftTimeEffect)
			{
				_leftTimeEffect.width = _width;
				_leftTimeEffect.height = 20;
				_leftTimeEffect.x = 0;
				_leftTimeEffect.y = (_height - _leftTimeEffect.height)/2;
			}
		}
		
		public function get dragSource():Object
		{
			return _dragSource;
		}
		
		public function set dragSource(value:Object):void
		{
			_dragSource = value;
		}
		
		public function get isDropAble():Boolean
		{
			return _dropAble;
		}
		
		public function set isDropAble(value:Boolean):void
		{
			_dropAble = value;
		}
		
		public function get isDragAble():Boolean
		{
			return _dragAble;
		}
		
		public function set isDragAble(value:Boolean):void
		{
			_dragAble = value;
			if(_dragAble)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			else
			{
				if(this.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				}
			}
		}
		protected function onMouseDown(e:MouseEvent):void
		{
			if(_dragAble)
			{
				DragManager.instance.startDragItem(this, bitmapdata);
			}
		}
		
		public function get isThrowAble():Boolean
		{
			return _throwAble;
		}
		
		public function set isThrowAble(value:Boolean):void
		{
			_throwAble = value;
		}
		
		/**
		 * 检测是否可以放下
		 */
		public function canDrop(dragItem:IDragDrop, dropItem:IDragDrop):Boolean
		{
			if(dropChecktFunction != null)
			{
				return this.dropChecktFunction(dragItem, this);
			}
			return isDropAble;
		}
		
		public function get bitmapdata():BitmapData
		{
			if( _bitmapdata )
			{
				if( _bitmapdata.width > this.width + 5 || _bitmapdata.height > this.height +5 )
				{
					var scal:Number = this.width/_bitmapdata.width;
					_bitmapdata = new BitmapData(this.width, this.height,true,0x00000000);
					_bitmapdata.draw(_bitmap,new Matrix(scal,0,0,scal,0,0));
				}
			}
			return _bitmapdata;
		}
		
		
		private var _lastImageUrl:String;
		
		public function set source(value:Object):void
		{
			//移除之前加载的
			if(_lastImageUrl)
			{
				LoaderManager.instance.removeResourceEvent(_lastImageUrl, onLoadCompleteHandler);
				_lastImageUrl = "";
			}
			if(value is Bitmap)
			{
				_bitmapdata = (value as Bitmap).bitmapData;
				_bitmap.bitmapData = _bitmapdata;
				resetBitmapSize();
				return;
			}
			else if( value is BitmapData )
			{
				_bitmap.bitmapData = value as BitmapData;
				resetBitmapSize();
				return;
			}
			else
			{
				_bitmap.bitmapData = null;
				if(value is String)
				{
					imageUrl = value as String;
					_lastImageUrl = imageUrl;
					LoaderManager.instance.load(imageUrl,onLoadCompleteHandler, LoaderPriority.LevelB);
				}
				else
				{
					if( imageUrl )
					{
						imageUrl = null;
					}
				}
			}
		}
		
		protected function onLoadCompleteHandler( info:ImageInfo ):void
		{
			_lastImageUrl = "";
			_bitmapdata = info.bitmapData;
			_bitmap.bitmapData = _bitmapdata;
			resetBitmapSize();
		}
		
		public function set bgName(value:String):void
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
		
		protected function resetBitmapSize():void
		{
			if(_bitmap)
			{
				_bitmap.width = _width - _paddingLeft * 2;
				_bitmap.height = _height - _paddingTop * 2;
			}
		}
		
		public override function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
		}
		
		protected function registerEffects():void
		{
			if(_cdData == null)
			{
				return;
			}
			registerFreezingEffect();
			registerLeftTimeEffect();
			_cdData.addFinishCallback(cdFinishedHandler);
		}
		
		protected function registerFreezingEffect():void
		{
			if(_cdData == null)
			{
				return;
			}
			if(_isShowFreezingEffect)
			{
				if(_freezingEffect == null)
				{
					_freezingEffect = new CDFreezingEffect();
					resetEffectPlace();
				}
				if(_freezingEffect.parent == null)
				{
					_topLayer.addChild(_freezingEffect);
				}
				if(!_freezingEffect.registed)
				{
					_cdData.addEffect(_freezingEffect);
				}
			}
		}
		
		protected function registerLeftTimeEffect():void
		{
			if(_cdData == null)
			{
				return;
			}
			if(_isShowLeftTimeEffect)
			{
				if(_leftTimeEffect == null)
				{
					_leftTimeEffect = new CDLeftTimeEffect();
					_leftTimeEffect.filters = [FilterConst.glowFilter];
					var textFormatCd:TextFormat = GlobalStyle.textFormatHuang;
					textFormatCd.align = TextFormatAlign.CENTER;
					textFormatCd.size = 13;
					_leftTimeEffect.defaultTextFormat = textFormatCd;
					resetEffectPlace();
				}
				if(_leftTimeEffect.parent == null)
				{
					_topLayer.addChild(_leftTimeEffect);
				}
				if(!_leftTimeEffect.registed)
				{
					_cdData.addEffect(_leftTimeEffect);
				}
			}
		}
		
		protected function unRegisterEffects():void
		{
			if(_cdData == null)
			{
				return;
			}
			unRegisterFreezingEffect();
			unRegisterLeftTimeEffect();
			_cdData.removeFinishCallback(cdFinishedHandler);
		}
		
		protected function unRegisterFreezingEffect():void
		{
			if(_freezingEffect && _freezingEffect.registed)
			{
				_freezingEffect.reset();
				_cdData.removeEffect(_freezingEffect);
				DisplayUtil.removeMe(_freezingEffect);
			}
		}
		
		protected function unRegisterLeftTimeEffect():void
		{
			if(_leftTimeEffect && _leftTimeEffect.registed)
			{
				_leftTimeEffect.reset();
				_cdData.removeEffect(_leftTimeEffect);
				DisplayUtil.removeMe(_leftTimeEffect);
			}
		}
		
		/**
		 * 冷却完成的时候的回调 
		 * 
		 */
		protected function cdFinishedHandler():void
		{
			
		}
		
		protected function clearAllEffect():void
		{
			if(_cdData)
			{
				if(_freezingEffect)
				{
					_cdData.removeEffect(_freezingEffect);
					DisplayUtil.removeMe(_freezingEffect);
					_freezingEffect = null;
				}
				if(_leftTimeEffect)
				{
					_cdData.removeEffect(_leftTimeEffect);
					DisplayUtil.removeMe(_leftTimeEffect);
					_leftTimeEffect = null;
				}
				_cdData = null;
			}
			
			unRegisterTips();
			_isShowFreezingEffect = false;
			_isShowLeftTimeEffect = false;
		}
		
		public function get isShowLeftTimeEffect():Boolean
		{
			return _isShowLeftTimeEffect;
		}
		
		public function set isShowLeftTimeEffect(value:Boolean):void
		{
			if(value == _isShowLeftTimeEffect)
			{
				return;
			}
			_isShowLeftTimeEffect = value;
			if(!value)
			{
				unRegisterLeftTimeEffect()
			}
			else if(value)
			{
				registerLeftTimeEffect()
			}
			
		}
		
		public function get isShowFreezingEffect():Boolean
		{
			return _isShowFreezingEffect;
		}
		
		public function set isShowFreezingEffect(value:Boolean):void
		{
			if(_isShowFreezingEffect == value)
			{
				return;
			}
			_isShowFreezingEffect = value;
			if(!value)
			{
				unRegisterFreezingEffect();
			}
			else
			{
				registerFreezingEffect();
			}
		}
	}
}