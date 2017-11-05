package com.mui.manager
{
	import com.gengine.global.Global;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.mui.events.DragEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;

	//import gs.TweenMax;
	//import gs.easing.*;


	public class DragManager
	{
		public var currentDragItem:IDragDrop; //当前拖动的物品
		public var currentDrogItem:IDragDrop; //放置的位置

		private var dragLayer:DisplayObjectContainer;
		private var tempDragItem:DisplayObject;
		private var thumItem:Sprite; //用于在拖动过程种显示拖动物体的假影
		private var oldMoveOverItem:IDragDrop;
		private var tempCurrentDragItem:IDragDrop; //用于记录当前的对象(因为currentDragItem在放下后不能马上清空）
		private var currentDragSource:Object;
		private var dragBitMapData:BitmapData;
		private static var _instance:DragManager;

		public function DragManager(base:DisplayObjectContainer)
		{
			if (_instance != null)
			{
				throw new Error(" DragManager 单例 ");
			}
			dragLayer=base;
			_instance=this;
		}

		public static function get instance():DragManager
		{
			if (!_instance)
			{
				throw new Error("DragManager 尚未初始化");
			}
			return _instance;
		}

		public static function init(base:DisplayObjectContainer):void
		{
			if (_instance == null)
			{
				_instance=new DragManager(base);
			}
		}

		/**
		 * 开始拖动某物体，不是真正的拖动
		 * @param	itemDrag 需要drag的物体
		 */
		public function startDragItem(itemDrag:IDragDrop, _bitMapData:BitmapData=null):void
		{
			if (!itemDrag.isDragAble)
			{
				return;
			}
			dragBitMapData=_bitMapData;

			currentDragSource=itemDrag.dragSource;
			var dragObject:DisplayObject=itemDrag as DisplayObject;
			if (DragManager.instance.tempCurrentDragItem == null)
			{
				var rect:Rectangle=dragObject.getBounds((itemDrag as DisplayObject).parent);
				var mouse_x:Number=dragObject.parent.mouseX;
				var mouse_y:Number=dragObject.parent.mouseY;
				//检测点击的位置是否在些物件上面
				if (mouse_x > rect.left && mouse_x < rect.right && mouse_y > rect.top && mouse_y < rect.bottom)
				{
					doDragItem(dragObject);
				}
			}
		}

		private function doDragItem(itemDrag:DisplayObject):void
		{
			clearThum();
			tempDragItem=itemDrag;
			currentDragItem=itemDrag as IDragDrop;
			itemDrag.addEventListener(MouseEvent.MOUSE_MOVE, onDragItemMove);
			itemDrag.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
		}

		/**
		 *如果还没开始拖动就放手
		 */
		private function onStopDrag(e:MouseEvent):void
		{
			tempDragItem.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			tempDragItem.removeEventListener(MouseEvent.MOUSE_MOVE, onDragItemMove);
		}

		/**
		 * 拖动过程中检测移在哪个可以drop的diplayObject上面
		 *
		 * 需要注意的是，droptarget可能是某显示元素的子元素，检测时需要判断是否是目标物品的子元素
		 */
		private function onDragItemMove(e:Event):void
		{
			tempDragItem.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			tempDragItem.removeEventListener(MouseEvent.MOUSE_MOVE, onDragItemMove);
			if (thumItem == null)
			{
				tempDragItem.dispatchEvent(new DragEvent(DragEvent.Event_Start_Drag, currentDragItem, currentDrogItem, currentDragSource, true));
				thumItem=new Sprite();

				var thumBimapData:BitmapData;
				if (dragBitMapData)
				{
					thumBimapData=dragBitMapData;
				}
				else
				{
					if (tempDragItem.width > 0 && tempDragItem.height > 0)
					{
						var rect:Rectangle=tempDragItem.getRect(dragLayer);
						thumBimapData=new BitmapData(rect.width, rect.height, true, 0x00000000);
					}
					else
					{
						thumBimapData=new BitmapData(1, 1, true, 0x00000000);
					}
					thumBimapData.draw(tempDragItem);
				}
				var thumBitmap:Bitmap=new Bitmap(thumBimapData);
				thumItem.addChild(thumBitmap);
				dragLayer.addChild(thumItem);

				thumItem.x=dragLayer.mouseX - tempDragItem.mouseX;
				thumItem.y=dragLayer.mouseY - tempDragItem.mouseY;

				thumItem.mouseEnabled=false;
				thumItem.mouseChildren=false;
				thumItem.startDrag();

				currentDragItem=tempDragItem as IDragDrop;
				tempCurrentDragItem=currentDragItem;
				thumItem.stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragItemMove);
				thumItem.stage.addEventListener(MouseEvent.MOUSE_UP, onDragItemDrop);
			}

			var moveOverTarget:DisplayObject=getMainContainer(thumItem.dropTarget);
			if (moveOverTarget != oldMoveOverItem)
			{
				tempCurrentDragItem.dispatchEvent(new DragEvent(DragEvent.Event_Move_Over, currentDragItem, currentDrogItem, currentDragSource, true));
				if (oldMoveOverItem)
				{
					oldMoveOverItem.dispatchEvent(new DragEvent(DragEvent.Event_Be_Drag_out, currentDragItem, currentDrogItem, currentDragSource, true));
				}
				if (moveOverTarget)
				{
					currentDrogItem=moveOverTarget as IDragDrop;
					moveOverTarget.dispatchEvent(new DragEvent(DragEvent.Event_Be_Drag_over, currentDragItem, currentDrogItem, currentDragSource, true));
					oldMoveOverItem=currentDrogItem;
				}
			}
		}

		/**
		 *  放下时检测碰到哪个可以drop的diplayObject
		 */
		private function onDragItemDrop(e:MouseEvent):void
		{
			if (tempDragItem.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				tempDragItem.removeEventListener(MouseEvent.MOUSE_MOVE, onDragItemMove);
			}
			if (thumItem && thumItem.stage.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				thumItem.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragItemMove);
			}

			//Global.stage.focus = Global.stage;
			if (tempCurrentDragItem != null)
			{
				//currentDragItem.locked = false;
				var dragTarget:DisplayObject=thumItem.dropTarget;
				var vContainer:IDragDrop=getMainContainer(dragTarget) as IDragDrop;
				if (vContainer is IDragDrop)
				{
					//如果是可以放进去的格子，那么把物品放到目标方格，否则本次移动操作取消
					if (canPutIn(currentDragItem, vContainer))
					{
						currentDrogItem=vContainer;
						currentDragItem.dispatchEvent(new DragEvent(DragEvent.Event_Move_To, currentDragItem, currentDrogItem, currentDragSource, true));
						vContainer.dispatchEvent(new DragEvent(DragEvent.Event_Move_In, currentDragItem, currentDrogItem, currentDragSource, true));
						thumItem.stopDrag();
						clearThum();
						tempCurrentDragItem=null;
					}
					else
					{
						thumItem.stopDrag();
						moveBack();
					}
				}
				else
				{
					currentDrogItem=null;
					if (!tempCurrentDragItem.isThrowAble)
					{
						thumItem.stopDrag();
						moveBack();
						tempCurrentDragItem=null;
					}
					else
					{
						thumItem.stopDrag();
						clearThum();
						tempCurrentDragItem.dispatchEvent(new DragEvent(DragEvent.Event_Throw_goods, currentDragItem, currentDrogItem, currentDragSource, true));
						tempCurrentDragItem=null;
					}
				}
			}
			else
			{
				//thumItem.stopDrag();
				clearThum();

				return;
			}
		}

		private function moveBack():void
		{
			if (currentDragItem)
			{
				var rect:Rectangle=(currentDragItem as DisplayObject).getBounds(dragLayer);
				TweenMax.to(thumItem, 0.2, {x: rect.left, y: rect.top, onComplete: moveBackEnd, ease: Quint.easeOut});
			}
			else
			{
				moveBackEnd();
			}
		}

		private function moveBackEnd():void
		{
			tempCurrentDragItem=null;
			clearThum();
		}

		/**
		 * 清除已有的缩略图
		 */
		private function clearThum():void
		{
			if (thumItem)
			{
				if (thumItem.hasEventListener(MouseEvent.MOUSE_MOVE))
				{
					thumItem.removeEventListener(MouseEvent.MOUSE_MOVE, onDragItemMove);
				}
				if (thumItem.hasEventListener(MouseEvent.MOUSE_UP))
				{
					thumItem.removeEventListener(MouseEvent.MOUSE_UP, onDragItemDrop);
				}
				if (dragLayer.contains(thumItem))
				{
					dragLayer.removeChild(thumItem);
				}
				thumItem=null;
			}
		}

		/**
		 * 这里去检测是否可以把物品拖动到新的位置
		 */
		private function canPutIn(vGridFrom:IDragDrop, vGridTo:IDragDrop):Boolean
		{
			return vGridTo.canDrop(vGridFrom, vGridTo);
		}

		/**
		 * 因为拖动物件的droptarget有可能是IDragDrop组件里面的内容，这里一直向上层检测，直到是IDragDrop类型或者是主场景为止
		 */
		private function getMainContainer(vItem:DisplayObject):DisplayObject
		{
			if (!vItem)
			{
				return null;
			}
			if (vItem is IDragDrop && (vItem as IDragDrop).isDropAble)
			{
				return vItem;
			}
			else if (vItem.parent is IDragDrop && (vItem.parent as IDragDrop).isDropAble)
			{
				return vItem.parent;
			}
			else if (vItem.parent == Global.stage)
			{
				return null;
			}
			else
			{
				return getMainContainer(vItem.parent);
			}
		}
	}
}
