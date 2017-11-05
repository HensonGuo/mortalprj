package mortal.game.manager.msgTip
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.Sprite;
	
	import mortal.game.view.msgbroad.RollRadioItem;
	import mortal.game.view.msgbroad.RollTipsItem;
	import mortal.game.manager.LayerManager;

	/**
	 * 白色滚动飘字 
	 * @author 宋立坤
	 * 
	 */
	public class MsgRollTipsImpl extends Sprite
	{
		private var _msgs:Array = [];			//信息池
		private var _shows:Array = [];			//正在飘的信息池
		private var _timer:FrameTimer; 
		
		private var _periodCount:int;
		private var _periodTotal:int = 12;	//保护期 帧
		
		public function MsgRollTipsImpl()
		{
			super();
		
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		/**
		 * 开始飘字 
		 * 
		 */
		private function startShowTips():void
		{
			if(!_timer)
			{
				_timer = new FrameTimer();
			}
			
			_timer.addListener(TimerType.ENTERFRAME,frameScript);
		
			if(!_timer.running)
			{
				_timer.reset();
				_timer.start();
			}
		}
		
		/**
		 * 停止飘字 
		 * 
		 */
		private function stopShowTips():void
		{
			if(_timer && _timer.running)
			{
				_timer.stop();
				_timer.dispose();
				_timer.isDelete = false;
			}
		}
		
		/**
		 * 添加显示列表 
		 * @param item
		 * 
		 */
		private function showRollTips(item:RollTipsItem):void
		{
			if(!this.parent)
			{
				LayerManager.msgTipLayer.addChild(this);
				stageResize();
			}
			this.addChild(item);
		}
		
		/**
		 * 从显示列表移出 
		 * 
		 */
		private function hideRollTips():void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		/**
		 * 等待显示的消息数量 
		 */
		public function get msgLength():int
		{
			return _msgs.length + _shows.length;
		}
		
		/**
		 * 帧频 
		 * @param timer
		 * 
		 */
		private function frameScript(timer:FrameTimer):void
		{
			if(_shows.length > 0 && inPeriod)//正在显示保护期内
			{
				_periodCount++;
				return;
			}
			
			_periodCount = 0;
			
			if(_msgs.length > 0)
			{
				clearTimeOut();
				
				var str:String = _msgs.shift();
				var item:RollTipsItem = ObjectPool.getObject(RollTipsItem);
				item.updateData(str,onInEnd);
				showRollTips(item);
				_shows.push(str);
			}
			else
			{
				stopShowTips();
			}
		}
		
		private var _childIndex:int;
		private var _childLength:int;
		
		/**
		 * 清除停留时间 
		 * 
		 */
		private function clearTimeOut():void
		{
			_childIndex = 0;
			_childLength = numChildren;
			while(_childIndex < _childLength)
			{
				(getChildAt(_childIndex) as RollTipsItem).clearTimeOut();
				_childIndex++;
			}
		}
		
		/**
		 * 飘字完毕回调函数 
		 * @param item
		 * 
		 */
		private function onInEnd(item:RollTipsItem):void
		{
			_shows.shift();

			if(item.parent)
			{
				item.parent.removeChild(item);
			}
			
			item.dispose();
			ObjectPool.disposeObject(item,RollTipsItem);
		}
		
		/**
		 * 显示飘字 
		 * @param str
		 * 
		 */
		public function showMsg(str:String):void
		{
			_periodTotal = 12;
			
			if(_msgs.length > 0)
			{
				var lastStr:String = _msgs[0];
				
				if(lastStr == str)
				{
					return;
				}
				else
				{
					if(_shows.length > 0)
					{
						lastStr = _shows[0];
						
						if(lastStr == str && inPeriod)
						{
							return;
						}
					}
					
					if(msgLength > 8)//信息太多
					{
						_periodTotal = 6;
					}
					_msgs.push(str);
				}
			}
			else
			{
				_msgs.push(str);
			}
			
			startShowTips();
		}
		
		/**
		 * 屏幕大小改变 
		 * 
		 */
		public function stageResize():void
		{
			if(this.parent)
			{
				x = Global.stage.stageWidth / 2 + 120;
				y = Global.stage.stageHeight / 2 + 150;
			}
		}
		
		/**
		 * 隐藏 
		 * 
		 */
		public function hide():void
		{
			stopShowTips();
			hideRollTips();
		}
		
		/**
		 * 还在保护期内 
		 * @return 
		 * 
		 */
		private function get inPeriod():Boolean
		{
			return _periodCount < _periodTotal;
		}
	}
}