package mortal.game.view.common.tooltip.tooltips
{
	import Message.DB.Tables.TBuff;
	
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.SecTimerView;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.tooltip.tooltips.base.ToolTipScaleBg;
	import mortal.game.view.mainUI.roleAvatar.BuffData;
	
	public class ToolTipBuff extends ToolTipScaleBg
	{
		private var _buffName:GTextFiled;
		
		private var _buffEffectTxt:GTextFiled;
		
		private var _leftTime:SecTimerView;
		
		
		//数据
		private var _buffData:BuffData;
		
		protected var _currentY:int;//当前Y坐标，用于定位
		protected var _needY:int = 0;//需要等级的Y坐标
		
		public function ToolTipBuff()
		{
			super();
			init();
		}
		
		public function init():void
		{
			setBg(ImagesConst.ToolTipBg);
			
			var textFormat:GTextFormat = new GTextFormat(FontUtil.songtiName,12,0xfffffff)
			textFormat.align = TextFormatAlign.CENTER;
			
			_buffName = new GTextFiled();
			_buffName.width = 75;
			_buffName.autoSize = TextFieldAutoSize.CENTER;
			_buffName.defaultTextFormat = textFormat;
			_buffName.y = 0;
			contentContainer2D.addChild(_buffName);
			
			_buffEffectTxt = new GTextFiled();
			_buffEffectTxt.width = 75;
			_buffEffectTxt.wordWrap = true;
			_buffEffectTxt.multiline = true;
			_buffEffectTxt.autoSize = TextFieldAutoSize.CENTER;
			_buffEffectTxt.defaultTextFormat = textFormat;
			_buffEffectTxt.y = 20;
			contentContainer2D.addChild(_buffEffectTxt);
			
			_leftTime = new SecTimerView();
			_leftTime.width = 75;
			_leftTime.autoSize = TextFieldAutoSize.CENTER;
			_leftTime.mouseEnabled = false;
			_leftTime.defaultTextFormat = textFormat;
			_leftTime.filters = [FilterConst.glowFilter];
			_leftTime.setParse(Language.getString(30055));//mm分ss秒50068
			_leftTime.configEventListener(EventName.SecViewTimeChange,onSecViewTimeChangeHandler);
			_leftTime.y = 40;
			//			contentContainer.addChild(_leftTime);
		}
		
		/**
		 *剩余时间改变 
		 * @param e
		 * 
		 */		
		private function onSecViewTimeChangeHandler(e:DataEvent):void
		{
			var leftTime:int = e.data as int;
			if(_buffData && _buffData.isSelfBuff)  //如果不是自己的buff就不显示时间
			{
				if(leftTime == 0)
				{
					if(contentContainer2D.contains(_leftTime))
					{
						contentContainer2D.removeChild(_leftTime);
					}
				}
			}
			else
			{
				_scaleBg.height = 60;
			}
			
		}
		
		public override function set data(value:*):void
		{
			_buffData = value as BuffData;
			resort();

			super.data = value;
		}
		
		private function updateLeftTime():void
		{
			var cdData:CDData;
			
			var tstate:TBuff;
			var leftSeconds:int;
			if(_buffData && _buffData.isSelfBuff)   //判断是否有剩余时间
			{
				tstate = _buffData.tbuff;
				cdData = Cache.instance.cd.getCDData(_buffData.tbuff.buffId,CDDataType.backPackLock) as CDData;
				if(cdData)
				{
					leftSeconds = cdData.leftTime/1000;
				}
				else
				{
					if(contentContainer2D.contains(_leftTime))
					{
						contentContainer2D.removeChild(_leftTime);
						_leftTime.stop();
					}
					return;
				}
			}
			else
			{
				if(contentContainer2D.contains(_leftTime))
				{
					contentContainer2D.removeChild(_leftTime);
					_leftTime.stop();
				}
				
				return;
			}
			
			if(_buffData.tbuff)
			{          
				//处理是否需计时。1 按时间 2按次数  3按值叠加
				if(tstate.lastTime != -1)
				{
					if(!contentContainer2D.contains(_leftTime))
					{
						contentContainer2D.addChild(_leftTime);
					}
					if(leftSeconds > 3600)
					{
						_leftTime.setParse(Language.getString(30055));//hh时mm分ss秒50068
					}
					else
					{
						_leftTime.setParse(Language.getString(30056));//mm分ss秒
					}
					_leftTime.setLeftTime(leftSeconds);
				}
				else
				{
					if(contentContainer2D.contains(_leftTime))
					{
						contentContainer2D.removeChild(_leftTime);
					}
				}
			}
		}
		
		/**
		 * 根据新的数据重新排列
		 */		
		private function resort():void
		{
			_currentY = 0;
			_needY = 0;
			
			updateNameText();
			updateEffectText();
			updateLeftTime();
			
			_leftTime.y = _buffEffectTxt.height + _buffEffectTxt.y;
		}
		
		private function updateNameText():void
		{
			_buffName.htmlText = _buffData.tbuff.name;
		}
		
		private function updateEffectText():void
		{
			_buffEffectTxt.htmlText = _buffData.tbuff.description;
		}
		
		public function get buffData():BuffData
		{
			return _buffData;
		}
		
		public function set buffData(value:BuffData):void
		{
			_buffData = value;
		}
	}
}