/**
 * @date 2011-10-25 下午03:08:37
 * @author  陈炯栩
 * 
 */ 
package mortal.game.view.effect
{
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.SWFInfo;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.info.ExpAddEffectInfo;
	import mortal.game.scene.player.AttributeText;
	import mortal.game.scene.player.AttributeValue;
	import mortal.game.scene.player.type.AttributeTextType;

	public class ExpAddEffect
	{
		private var _info:ExpAddEffectInfo;
		
		private var _effectStart:MovieClip;
		private var _effectEnd:MovieClip;
		
		private var attributeText:AttributeText;
		
		public function ExpAddEffect(info:ExpAddEffectInfo)
		{
			_info = info;
		}
		
		/**
		 * 播放经验获得特效
		 * 
		 */		
		public function playEffect():void
		{
			if(!_effectStart || !_effectEnd)
			{
				loadExpEffect();
			}
			else
			{
				startExpEffectPlay();
			}
		}
		
		/**
		 * 加载特效自语啊
		 * 
		 */		
		private function loadExpEffect():void
		{
			//LoaderManager.instance.load("ExpAddEffectStart.swf",onStartEffLoaded);
			LoaderManager.instance.load("ExpEffect.swf",onStartEffLoaded);
		}
		private function onStartEffLoaded(swf:SWFInfo):void
		{
			var starEff:Class = swf.getAssetClass("ExpEffectStart");
			var endEff:Class = swf.getAssetClass("ExpEffectEnd");
			_effectStart = new starEff();
			_effectEnd = new endEff();
			startExpEffectPlay();
			//LoaderManager.instance.load("ExpAddEffectEnd.swf",onEndEffLoaded);
		}
		private function onEndEffLoaded(swf:SWFInfo):void
		{
			_effectEnd = swf.clip;
			startExpEffectPlay();
		}
		
		/**
		 * 开始播放特效
		 * 
		 */		
		private function startExpEffectPlay():void
		{
			if(_info.startX == _info.endX && _info.startY == _info.endY)
			{
				onStartEffectComplect();
			}
			else
			{
				_effectStart.x = _info.startX - 66;
				_effectStart.y = _info.startY - 72;
				_effectStart.mouseEnabled = false;
				_effectStart.mouseChildren = false;
				if( _info.parent )
				{
					_info.parent.addChild( _effectStart );
				}
				else
				{
					LayerManager.msgTipLayer.addChild(_effectStart);
				}
				_effectStart.addEventListener(Event.ENTER_FRAME,onExpStartEffEnterFrame);
				_effectStart.gotoAndPlay(1);
			}
		}
		private function onExpStartEffEnterFrame(e:Event):void
		{
			if(_effectStart.currentFrame == _effectStart.totalFrames)
			{
				_effectStart.removeEventListener(Event.ENTER_FRAME,onExpStartEffEnterFrame);
				_effectStart.stop();
				
				TweenMax.to(_effectStart,1,{x:_info.endX - 66,y:_info.endY - 72,onComplete:onStartEffectComplect});
			}
		}
		
		/**
		 * 开始播放结束特效
		 * 
		 */		
		private function onStartEffectComplect():void
		{
			if(_effectStart && _effectStart.parent)
			{
				_effectStart.parent.removeChild(_effectStart);
			}
			_effectStart = null;
			
			_effectEnd.x = _info.endX - 62;
			_effectEnd.y = _info.endY - 49;
			_effectEnd.mouseChildren = false;
			_effectEnd.mouseEnabled = false;
			if( _info.parent )
			{
				_info.parent.addChild( _effectEnd );
			}
			else
			{
				LayerManager.msgTipLayer.addChild(_effectEnd);
			}
			_effectEnd.addEventListener(Event.ENTER_FRAME,onExpEndEffEnterFrame);
			_effectEnd.gotoAndPlay(1);
		}
		private function onExpEndEffEnterFrame(e:Event):void
		{
			if(_effectEnd.currentFrame == _effectEnd.totalFrames)
			{
				_effectEnd.removeEventListener(Event.ENTER_FRAME,onExpEndEffEnterFrame);
				_effectEnd.stop();
				if(_effectEnd.parent)
				{
					_effectEnd.parent.removeChild(_effectEnd);
				}
				_effectEnd = null;
				
				if( _info.isFlutterWord )
				{
					startFlutterText();
				}
			}
		}
		
		/**
		 * 开始经验增加飘字
		 * 
		 */		
		private function startFlutterText():void
		{
			attributeText = new AttributeText(new AttributeValue(_info.attributeType,true,_info.value));
			var tf:TextFormat = attributeText.defaultTextFormat;
			tf.align = TextFormatAlign.CENTER;
			attributeText.defaultTextFormat = tf;
			attributeText.width = 200;
			attributeText.scaleX = 0.5;
			attributeText.scaleY = 0.5;
			attributeText.x = _info.endX - 0.5*0.5*attributeText.textWidth;
			attributeText.y = _info.endY + 30;
			LayerManager.msgTipLayer.addChild(attributeText);
			var endX:Number = _info.endX - 0.5*attributeText.textWidth;
			var endY:Number = _info.endY - 100;
			TweenMax.to(attributeText, _info.time, {x:endX, y:endY, scaleX:1, scaleY:1, ease: Circ.easeOut, onComplete:flutterTextComplete});
		}
		private function flutterTextComplete():void
		{
			if(attributeText.parent)
			{
				attributeText.parent.removeChild(attributeText);
			}
			attributeText = null;
		}
		
	}
}