package mortal.game.view.common.cd
{
	import com.gengine.core.call.Caller;
	
	import mortal.game.view.common.cd.effect.CDEffectTimerType;
	import mortal.game.view.common.cd.effect.ICDEffect;

	public interface ICDData
	{
		/**
		 * 添加显示效果， 可以同时添加多个ICDEffect 
		 * @param effect 显示效果
		 * @param timerType 计时器的类型：帧、秒、百分之， 参考CDEffectTimerType
		 * 
		 */			
		function addEffect(effect:ICDEffect):void;
		/**
		 * 删除显示效果 
		 * @param effect
		 * 
		 */
		function removeEffect(effect:ICDEffect):void;
		/**
		 * 是否正在CD中 
		 * @return 
		 * 
		 */		
		function get isCoolDown():Boolean;
		function set isCoolDown(value:Boolean):void;
		/**
		 * 开始CD 
		 * 
		 */		
		function startCoolDown():void;
		/**
		 * 停止CD 
		 * 
		 */		
		function stopCoolDown():void;

		/**
		 * 设置是从什么时候开始的， 不设置的话默认是startCoolDown的那刻 
		 * @param value
		 * 
		 */		
		function set beginTime(value:Number):void;
		function get beginTime():Number;
		
		/**
		 * CD的总时间 ， 单位毫秒
		 * @return 
		 * 
		 */		
		function get totalTime():Number;
		function set totalTime(value:Number):void;
		
		
		function addFinishCallback(value:Function):void;
		function removeFinishCallback(value:Function):void;
		
		function addStartCallback(value:Function):void;
		function removeStartCallback(value:Function):void;
		
		function addFrameUpdate(value:Function):void;
		function removeFrameUpdate(value:Function):void;
		
		function get caller():Caller;
		function get leftTime():int;
		function get usedTime():int;
	}
}