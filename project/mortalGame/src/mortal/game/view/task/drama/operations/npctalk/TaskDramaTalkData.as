package mortal.game.view.task.drama.operations.npctalk
{
	

	/**
	 * Npc聊天类数据， 先算popupTime， 再算speed，后+showTime
	 */
	public class TaskDramaTalkData
	{
		/**
		 * 聊天的内容
		 */
		public var talk:String;
		/**
		 * 聊天的字体大小
		 */
		public var talkFontSize:int;
		/**
		 * 聊天段落文字间隔
		 */
		public var talkFontLeading:int;
		/**
		 * 字幕滚动的速度，单位是每一帧移动的像素点
		 */
		public var speed:int;
		/**
		 * 左边的npc的Avatar
		 */
		public var leftAvatar:*;
		/**
		 * 右边的Avatar
		 */
		public var rightAvatar:*;
		/**
		 * 字幕完全显示后，停留的时间, 单位为毫秒
		 */
		public var showTime:Number;
		/**
		 * pupop的时间， 单位为秒
		 */
		public var popupTime:Number;
		/**
		 * 每一行的宽度
		 */
		public var rowWidth:int;
		
		public function TaskDramaTalkData()
		{
		}
	}
}