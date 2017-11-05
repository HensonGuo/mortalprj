/**
 * 2014-1-17
 * @author chenriji
 **/
package mortal.game.view.common.cd
{
	import com.gengine.core.frame.BaseTimer;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.cd.effect.CDEffectTimerType;
	import mortal.mvc.core.Dispatcher;

	
	public class CDDataPublicCD extends CDData
	{
		private var _dic:Dictionary = new Dictionary();
		private var _curList:Array;
		public function CDDataPublicCD()
		{
			super();
		}
		
		/**
		 * 添加受公共CD影响的CDData 
		 * @param key
		 * @param data
		 * 
		 */		
		public function addPublicCD(key:Object, data:ICDData):void
		{
			if(_dic[key] != null)
			{
				return;
			}
			_dic[key] = data;
		}
		
		public function removePublicCD(key:Object):void
		{
			if(_dic[key] == null)
			{
				return;
			}
			delete _dic[key];
		}
		
		///////////////////////////////////////////////////////////////////////////////////
		
		public override function startCoolDown():void
		{
			resetCDDatas();
			super.startCoolDown();
		}
		
		protected override function callPercentage(usedTime:int):void
		{
			_percentage = Math.ceil((usedTime/totalTime*100));
			if(_percentage != _lastPercentage)
			{
				_lastPercentage = _percentage;
				for each(var data:ICDData in _curList)
				{
					data.caller.call(CDEffectTimerType.Percentage, _percentage);
				}
			}
		}
		
		protected override function callFrame(usedTime:int):void
		{
			_lastFrame++;
			for each(var data:ICDData in _curList)
			{
				
				data.caller.call(CDEffectTimerType.Frame, _lastFrame);
			}
		}
		
		protected override function callSecond(usedTime:int):void
		{
			_second = Math.ceil((totalTime - usedTime)/1000);
			if(_second != _lastSecond)
			{
				_lastSecond = _second;
				for each(var data:ICDData in _curList)
				{
					data.caller.call(CDEffectTimerType.Second, _second);
				}
			}
		}
		
		protected override function setViewToEnd():void
		{
			trace("................................................" + (getTimer() - _beginTime));
			for each(var data:ICDData in _curList)
			{
				if(data.caller)
				{
					data.caller.call(CDEffectTimerType.Percentage, 101);
					data.caller.call(CDEffectTimerType.Second, 0);
					data.caller.call(CDEffectTimerType.Frame, 0);
					data.caller.call(CDEffectTimerType.FinishedCallback); // 这里真正的完成了
				}
				data.isCoolDown = false;
			}
			Dispatcher.dispatchEvent(new DataEvent(EventName.CDPublicCDEnd));
		}
		
		/**
		 * 挑选本次执行公共CD时， 符合条件的CDData 
		 * 
		 */		
		private function resetCDDatas():void
		{
			_curList = [];
			for each(var cdData:ICDData in _dic)
			{
				// CDData不在冷却中
				if(!cdData.isCoolDown)
				{
					_curList.push(cdData);
					cdData.isCoolDown = true;
					continue;
				}
				// cdData剩余时间比 本公共CD的时间短
				if(cdData.leftTime < _totalTime)
				{
					cdData.stopCoolDown();
					cdData.isCoolDown = true;
					_curList.push(cdData);
					continue;
				}
				
			}
		}
	}
}