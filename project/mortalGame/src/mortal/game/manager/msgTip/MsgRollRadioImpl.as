package mortal.game.manager.msgTip
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.Stage;
	
	import mortal.game.Game;
	import mortal.game.model.RollRadioInfo;
	import mortal.game.view.msgbroad.RollRadioItem;
	import mortal.game.manager.LayerManager;

	public class MsgRollRadioImpl
	{
		private var _msgs:Array = [];		//消息池
		private var _timer:FrameTimer;
		private var _item:RollRadioItem;
		
		private var _hideTimer:int;
		private const _hideTotal:int = 60;
		
		private var _countTimer:int;
		private const _countTotal:int = 12;
		
		public function MsgRollRadioImpl()
		{
		}

		/**
		 * 显示飘字 
		 * 
		 */
		private function startRollRadio():void
		{
			if(!_timer)
			{
				_timer = new FrameTimer(1);
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
		private function stopRollRadio():void
		{
			if(_timer && _timer.running)
			{
				_timer.stop();
				_timer.dispose();
				_timer.isDelete = false;
			}
		}
		
		/**
		 * 隐藏飘字 
		 * 
		 */
		private function hideRollRadio():void
		{
			if(_item)
			{
				_item.dispose();
				
				if(_item.parent)
				{
					_item.parent.removeChild(_item);
				}
			}
		}
		
		/**
		 * 显示飘字 
		 * 
		 */
		private function showRollRadio():void
		{
			if(_item)
			{
				LayerManager.msgTipLayer.addChild(_item);
				stageResize();
			}
		}
		
		
		/**
		 * 滚动帧频 
		 * @param time
		 * 
		 */
		private function frameScript(time:FrameTimer):void
		{
			if(_msgs.length > 0)
			{
				_hideTimer = 0;
				
				if(_item)
				{
					if(_item.running)//正在显示...
					{
						_item.frameScript();
					}
					else
					{
						if(_item.hasEnd && _msgs[0] == _item.info)//次数用完了
						{
							_msgs.shift();
							
							if(_msgs.length > 0)
							{
								_item.updateData(_msgs[0]);
								showRollRadio();
							}
						}
						else
						{
							//延迟n帧
							if(_countTimer >= _countTotal)
							{
								_countTimer = 0;
								_item.updateData(_msgs[0]);
								showRollRadio();
							}
							else
							{
								_countTimer++;
							}
						}
					}
				}
				else
				{
					_item = new RollRadioItem();
					_item.updateData(_msgs[0]);
					showRollRadio();
				}
			}
			else
			{
				if(_hideTimer >= _hideTotal)
				{
					hide();
				}
				else
				{
					_hideTimer++;
				}
			}
		}
		
		/**
		 * 添加显示一条横线滚屏飘字 
		 * @param str
		 * @param totalCount
		 * @param speed
		 * 
		 */
		public function showMsg(str:String,totalCount:int,speed:int):void
		{
			var info:RollRadioInfo = ObjectPool.getObject(RollRadioInfo);
			info.str = str;
			info.totalCount = totalCount;
			info.speed = speed;
			
			_msgs.push(info);
			startRollRadio();
		}
		
		/**
		 * 改变舞台大小 
		 * 
		 */
		public function stageResize():void
		{
			if(_item && _item.parent)
			{
				_item.x = (Global.stage.stageWidth - _item.width) / 2;
				_item.y = 55;
			}
		}
		
		/**
		 * 隐藏飘字 
		 * 
		 */
		public function hide():void
		{
			stopRollRadio();
			hideRollRadio();
		}
	}
}