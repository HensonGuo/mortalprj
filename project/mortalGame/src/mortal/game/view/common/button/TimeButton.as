/**
 * @date 2011-3-16 下午09:20:45
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.common.button
{
	import com.mui.controls.GButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.cd.ICDData;
	import mortal.game.view.common.cd.effect.CDFreezingEffect;
	import mortal.game.view.common.cd.effect.CDLeftTimeEffect;
	
	public class TimeButton extends GButton
	{
		public static const COUNTDOWN:String = "countDown";
		public static const CD:String = "cd";
		
		private var _cdTime:int;
		private var _templabel:String = "";
		
		private var _type:String;
		
		private var _freezingEffect:CDFreezingEffect;
		private var _leftTimeEffect:CDLeftTimeEffect;
		private var _cdData:ICDData;
		private var _cacheName:String;
		private var _isByClick:Boolean = true;
		/**
		 * CD按钮，或者倒计时按钮， 时间单位为毫秒
		 * @param timeCount
		 * @param isClickTrigger
		 * @param type
		 * 
		 */
		public function TimeButton(cdSeconds:int = 30000, $type:String = TimeButton.COUNTDOWN, $cacheName:String="")
		{
			super();
			_cdTime = cdSeconds;
			_type = $type;
			cacheName = $cacheName;
			
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		/**
		 * 点击立马启动cd 
		 */
		public function get isByClick():Boolean
		{
			return _isByClick;
		}

		/**
		 * @private
		 */
		public function set isByClick(value:Boolean):void
		{
			_isByClick = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}

		private function addToStageHandler(evt:Event):void
		{
			registerEffects();
			updateCDStatus();
		}
		
		private function removeFromStageHandler(evt:Event):void
		{
			unRegisterEffects();
		}
		
		private function cdEndHandler():void
		{
			this.enabled = true;
			this.filters = [];
			super.label = _templabel;
		}
		
		protected function registerEffects():void
		{
			if(_cdData == null)
			{
				return;
			}
			if(_type == CD)
			{
				if(_freezingEffect == null)
				{
					_freezingEffect = new CDFreezingEffect();
					resetEffectPlace();
				}
				_cdData.addEffect(_freezingEffect);
				this.addChild(_freezingEffect);
			}
			else if(_type == COUNTDOWN)
			{
				if(_leftTimeEffect == null)
				{
					_leftTimeEffect = new CDLeftTimeEffect();
					_leftTimeEffect.filters = [FilterConst.glowFilter];
					var textFormatCd:TextFormat = GlobalStyle.textFormatHuang;
					textFormatCd.align = TextFormatAlign.CENTER;
					_leftTimeEffect.defaultTextFormat = textFormatCd;
					resetEffectPlace();
				}
				_cdData.addEffect(_leftTimeEffect);
				this.addChild(_leftTimeEffect);
			}
			
			_cdData.addFinishCallback(cdEndHandler);
			_cdData.addStartCallback(updateCDStatus);
		}
		
		protected function unRegisterEffects():void
		{
			if(_cdData == null)
			{
				return;
			}
			if(_freezingEffect && _freezingEffect.registed)
			{
				_cdData.removeEffect(_freezingEffect);
			
			}
			if(_leftTimeEffect && _leftTimeEffect.registed)
			{
				_cdData.removeEffect(_leftTimeEffect);
			
			}
			
			DisplayUtil.removeMe(_freezingEffect);
			DisplayUtil.removeMe(_leftTimeEffect);
			_cdData.removeFinishCallback(cdEndHandler);
			_cdData.removeStartCallback(updateCDStatus);
		}
		
		private function resetEffectPlace():void
		{
			if(_freezingEffect)
			{
				_freezingEffect.x = _width/2;
				_freezingEffect.y = _height/2;
				_freezingEffect.setMaskSize(_width, _height);
			}
			if(_leftTimeEffect)
			{
				_leftTimeEffect.width = _width;
				_leftTimeEffect.height = 18;
				_leftTimeEffect.x = 0;
				_leftTimeEffect.y = (_height - _leftTimeEffect.height)/2;
			
			}
		}
		
		public function set cacheName(cacheName:String):void
		{
			_cacheName = cacheName;
			if(cacheName == null || cacheName == "")
			{
				if(_cdData == null)
				{
					_cdData = new CDData();
				}
				_cdData.totalTime = _cdTime;
				return;
			}
			
			var data:ICDData = Cache.instance.cd.getCDData(_cacheName, CDDataType.timeButton);
			if(data == null)
			{
				_cdData = new CDData();
				_cdData.totalTime = _cdTime;
				Cache.instance.cd.registerCDData(CDDataType.timeButton, _cacheName, _cdData);
			}
			else
			{
				_cdData = data;
				_cdData.totalTime = _cdTime;
				updateCDStatus();
			}
		}
		
		private function updateCDStatus():void
		{
			if(!_cdData.isCoolDown)
			{
				if(_freezingEffect)
				{
					_freezingEffect.reset();
				}
				if(_leftTimeEffect)
				{
					_leftTimeEffect.reset();
				}
				cdEndHandler();
				return;
			}
			
			if(_type == COUNTDOWN)
			{
				super.label = "";
			}
			this.enabled = false;
			this.filters = [FilterConst.colorFilter2];
		}
		

		/**
		 * 设置冷却时间，单位为毫秒
		 * @param value
		 * 
		 */		
		public function set cdTime(value:int):void
		{
			_cdTime = value;
			cacheName = _cacheName;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if(!_isByClick)
			{
				return;
			}
			_cdData.startCoolDown();
			updateCDStatus();
		}
		
		/**
		 * 手动开启 
		 * 
		 */		
		public function startCoolDown():void
		{
			if(_cdData == null)
			{
				return;
			}
			_cdData.startCoolDown();
			updateCDStatus();
		}
	
		
		/**
		 * 是否正在冷却中 
		 * @return 
		 * 
		 */		
		public function get running():Boolean
		{
			return _cdData.isCoolDown;
		}
		
		override public function set label(arg0:String):void
		{
			_templabel = arg0;
			super.label = arg0;
			updateCDStatus();
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			unRegisterEffects();
			
			if(_cacheName == null || _cacheName == "")
			{
				_cdData.stopCoolDown();
			}
			
			_leftTimeEffect.text = "";
			_cdData = null;
			_cdTime = 30000;
			_cacheName = null;
			_type = TimeButton.COUNTDOWN;
			_isByClick = true;
			this.enabled = true;
			this.filters = [];
			super.dispose(isReuse);
		}
	}
}