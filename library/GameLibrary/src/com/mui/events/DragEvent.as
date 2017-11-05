package com.mui.events
{
	import com.mui.manager.IDragDrop;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	
	public class DragEvent extends Event
	{
		
		public static const Event_Start_Drag:String = "开始拖动";
		public static const Event_Move_To:String = "物品拖动到新位置";
		public static const Event_Move_In:String = "有物品拖进此位置";
		public static const Event_Move_Over:String = "物品拖动时经过新的物品";
		public static const Event_Be_Drag_over:String = "被拖动物体经过";//用于检测拖物体动背包的翻页按钮
		public static const Event_Throw_goods:String = "丢弃物品";//在检测到拖动到非dropable的物品上面时触发
		public static const Event_Be_Drag_out:String = "物品拖动时滑出旧的物品";
		
		
		public var dragItem:IDragDrop;
		public var dropItem:IDragDrop;
		public var dragSouce:Object;
		
		public function DragEvent(type:String,dragItem:IDragDrop,dropItem:IDragDrop,dragSource:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.dragItem = dragItem;
			this.dropItem = dropItem;
			this.dragSouce = dragSource;
			super(type, bubbles, cancelable);
		}
	}
}