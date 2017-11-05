/**
 * @date 2011-5-3 上午10:41:24
 * @author  宋立坤
 * 
 */  
package mortal.game.view.effect
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.utils.ObjectParser;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.UIFactory;

	public class GlowFilterEffect
	{
		private var _targetDic:Dictionary;//已注册的滤镜键值对 [target]={xxx}
		private var _frame:FrameTimer;//帧频
		private var _effectNum:int;//targetDic长度
		private var _tempFilters:Array;
		
		public function GlowFilterEffect()
		{
			_targetDic = new Dictionary();
			_effectNum = 0;
				
			_frame = new FrameTimer();
			_frame.addListener(TimerType.ENTERFRAME,onEnterFrameHandler);
		}
		
		/**
		 * 帧频 
		 * @param timer
		 * 
		 */
		private function onEnterFrameHandler(timer:FrameTimer):void
		{
			var target:*;
			var effect:Object;
			var filters:Array;
			var filter:GlowFilter;
			for(target in _targetDic)
			{
				if(target == "null")
				{
					continue;
				}
				
				effect = _targetDic[target];
				if(effect["repeat"] != 0)
				{
					if(effect["count"] >= effect["repeat"])
					{
						unRegist(target);
						continue;
					}
				}
				if(effect.hasOwnProperty("filters"))
				{
					filters = effect["filters"];
					for each(filter in filters)
					{
						if(filter.blurX <= effect["min"])
						{
							filter.blurX = effect["min"];
							filter.blurY = effect["min"];
							if(effect["step"] < 0)
							{
								effect["step"] *= -1;
							}
							effect["count"] += 0.5;
						}
						else if(filter.blurX >= effect["max"])
						{
							filter.blurX = effect["max"];
							filter.blurY = effect["max"];
							if(effect["step"] > 0)
							{
								effect["step"] *= -1;
							}
							effect["count"] += 0.5;
						}
						filter.blurX += effect["step"];
						filter.blurY += effect["step"];
					}
				}
				if(target && target != "null" && filters)
				{
					target.filters = filters;
				}
			}
		}
		
		/**
		 * 注册  
		 * @param target 目标
		 * @param filters 滤镜数组
		 * @param step 偏移步长
		 * @param max XY最大偏移量
		 * @param min XY最小偏移量
		 * @param repeat 重复次数 0=无限
		 * 
		 */
		public function regist(target:DisplayObject,filters:Array,step:Number=1,max:int=20,min:int=3,repeat:int=0):void
		{
			if(target == null || filters == null)
			{
				return;
			}
			
			if(_targetDic[target] != null)
			{
				disposeTarget(target);
				_effectNum--;
			}
			
			_tempFilters = [];
			var glowFilter:GlowFilter;
			for each(var filter:GlowFilter in filters)
			{
				glowFilter = ObjectPool.getObject(GlowFilter);
				glowFilter.color = filter.color;
				glowFilter.alpha = filter.alpha;
				glowFilter.blurX = filter.blurX;
				glowFilter.blurY = filter.blurY;
				glowFilter.strength = filter.strength;
				glowFilter.quality = filter.quality;
				glowFilter.inner = filter.inner;
				glowFilter.knockout = filter.knockout;
				_tempFilters.push(glowFilter);
			}
			
			filters.splice();
			
			_targetDic[target] = {filters:_tempFilters,step:step,max:max,min:min,repeat:repeat,count:0};
			_effectNum++;
			if(!_frame.running)
			{
				_frame.start();
			}
		}
		
		/**
		 * 返回滤镜 
		 * @param target
		 * @return 
		 * 
		 */
		public function getFilters(target:DisplayObject):Array
		{
			if(_targetDic[target] != null)
			{
				return _targetDic[target]["filters"];
			}
			return null;
		}
		
		/**
		 * 卸载 
		 * @param target 
		 * 
		 */
		public function unRegist(target:DisplayObject):void
		{
			if(_targetDic[target] != null)
			{
				disposeTarget(target);
				_effectNum--;
			}
			else
			{
				return;
			}
			
			if(_effectNum <= 0)
			{
				if(_frame.running)
				{
					_frame.stop();
				}
			}
		}
		
		/**
		 * 释放 
		 * 
		 */
		private function disposeTarget(target:DisplayObject):void
		{
			var effect:Object = _targetDic[target];
			var filters:Array;
			if(effect && effect.hasOwnProperty("filters"))
			{
				filters = effect["filters"];
				
				for each(var glowFilter:GlowFilter in filters)
				{
					ObjectPool.disposeObject(glowFilter,GlowFilter);
				}
			}
			
			delete _targetDic[target];
			target.filters = null;
		}
		
		/**
		 * 全部卸载 
		 * 
		 */
		public function unRegistAll():void
		{
			var target:*;
			for(target in _targetDic)
			{
				disposeTarget(target as DisplayObject);
			}
			_effectNum = 0;
			if(_frame.running)
			{
				_frame.stop();
			}
		}
	}
}