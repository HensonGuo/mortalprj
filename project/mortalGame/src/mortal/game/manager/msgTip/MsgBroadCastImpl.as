/**
 * @date	2011-3-18 下午06:38:42
 * @author  宋立坤
 * 
 */	
package mortal.game.manager.msgTip
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.Sprite;
	
	import mortal.game.view.msgbroad.NoticeItem;
	import mortal.mvc.interfaces.ILayer;
	import mortal.game.manager.LayerManager;
	
	public class MsgBroadCastImpl extends Sprite
	{
		private var _needRedraw:Boolean;	//是否需要重绘
		private var _timer:FrameTimer;		//重绘帧频
		private var _pushing:Boolean;		//锁住列表
		private var _inDis:int = 70;
		private var _gad:int = 0;			//间隔
		
		private var _layer:ILayer;
		
		public function MsgBroadCastImpl()
		{
			super();
			
			layer = LayerManager.windowLayer;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			var maskSprite:Sprite = new Sprite();
			maskSprite.graphics.lineStyle(2,0xff0000,1);
			maskSprite.graphics.beginFill(0xff0000,1);
			maskSprite.graphics.drawRect(0,0,width,height+_inDis);
			maskSprite.graphics.endFill();
			addChild(maskSprite);
			this.mask = maskSprite;
			this.cacheAsBitmap = true;
			
			_timer = new FrameTimer();
			_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			_timer.start();
		}
		
		public function set layer(value:ILayer):void
		{
			_layer = value;
			_layer.addPopUp(this);
		}
		
		/**
		 * 淡出完成 
		 * @param item
		 * 
		 */
		private function onNoticeHide(item:NoticeItem):void
		{
			if(item.parent)
			{
				removeChild(item);
			}
			item.dispose();
			ObjectPool.disposeObject(item,NoticeItem);
		}
		
		/**
		 * 消失完成 
		 * @param item
		 *  
		 */
		private function onLastItemHide(item:NoticeItem):void
		{
			if(contains(item))
			{
				removeChild(item);
			}
			item.dispose();
			ObjectPool.disposeObject(item,NoticeItem);
		}
		
		/**
		 * 显示消息 
		 * @param str
		 * 
		 */
		public function showNotice(str:String):void
		{
			if(!str || str == "")
			{
				return;
			}
			if(_layer)
			{
				_layer.setTop(this);
			}
			
			var easeIn:Boolean;
			var item:NoticeItem;
			
			if(numChildren > 1)
			{
				var lastItem:NoticeItem;
				if(numChildren >= 4)//满了
				{
					_pushing = true;
					lastItem = getChildAt(1) as NoticeItem;
					lastItem.easeHide(onLastItemHide);
					_pushing = false;
				}
				(getChildAt(numChildren-1) as NoticeItem).killInEase();
				easeIn = false;
			}
			else
			{
				easeIn = false;
			}
			
			item = ObjectPool.getObject(NoticeItem);
			addChild(item);
//			item.visible = false;
			item.updateData(str,onNoticeHide,_inDis,easeIn);
			_needRedraw = true;
		}
		
		/**
		 * 重绘帧频 
		 * @param timer
		 * 
		 */
		private function onEnterFrame(timer:FrameTimer):void
		{
			if(_needRedraw && !_pushing)
			{
				_needRedraw = false;
				updatePxy();
			}
		}
		
		/**
		 * 更新xy坐标 
		 * 
		 */
		public function updatePxy():void
		{
			var index:int = 0;
			var length:int = numChildren-1;
			var item:NoticeItem;
			var lastHeight:int;//上一条的高度
			while(length > index)//反向遍历
			{
				item = getChildAt(length) as NoticeItem;
				
				if(item.hideIng)//正在消失
				{
					length--;
					continue;
				}
				
				if(item.disposed)
				{
					if(item.parent)
					{
						removeChild(item);
					}
					length--;
					continue;
				}
				
//				item.visible = true;
				item.x = (width - item.width) / 2;//居中
				
				if(length != numChildren - 1)//不是最新的一条
				{
//					item.easeUp(height - item.height - lastHeight,length);
					item.updatePosY(height - item.height - lastHeight);
				}
				else
				{
					item.updatePosY(height - item.height - lastHeight);
				}
				
				lastHeight += item.height;
				lastHeight += _gad;
				
				length--;
			}
		}
		
		/**
		 * 舞台改变大小 
		 * 
		 */
		public function stageResize():void
		{
			x = (Global.stage.stageWidth - width) / 2;
			y = 85;
		}
		
		override public function get height():Number
		{
			return 60;
		}
		
		override public function get width():Number
		{
			return 810;
		}
	}
}