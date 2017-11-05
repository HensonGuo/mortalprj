package mortal.game.model
{
	import flash.display.DisplayObject;

	public class MsgTipInfo
	{
		/**
		 * 提示内容数组，每个元素都是string，需要显示不同颜色的字词用[]括起来
		 */
		public var contentArr:Array=[];
		/**
		 * 提示内容颜色数组，与提示内容数组一一对应，颜色值要用uint类型
		 */
		public var colorArr:Array=[];
		/**
		 * 用[]括起来的字词颜色数组，颜色值要用string类型
		 */
		public var itemColorArr:Array=[];
		/**
		 * 是否可点击文字链接弹出相应的界面，0为无链接，1为有链接且有复选框
		 */
		public var isClick:int;
		/**
		 * 点击链接后发出的事件数组，每个元素是点击每个提示数组内容的链接事件
		 */
		public var clickEventArr:Array=[];
		/**
		 * 点击复选框发出不再提示事件
		 */
		public var notTipEvent:String="";
		/**
		 * 物品itemdata数组，对应于提示内容颜色数组里面要点击链接打开背包选中物品的提示内容
		 */
		public var itemDataArr:Array = [];
		/**
		 * 对于提示内容数组的内容，可分项点击链接
		 */
		public var isMultiLink:Boolean = false;
		/**
		 * 提示内容项是否有链接的数组，元素为boolean类型，与提示内容数组一一对应
		 */
		public var isItemLinkArr:Array = [];
		/**
		 * 提示内容项是否换行,元素为boolean类型，与提示内容数组一一对应
		 */
		public var isItemNewLineArr:Array = [];
		/**
		 * 是否自动消失
		 */
		public var isAutoHide:Boolean = false;
		/**
		 * 类型：0表示为非显示对象，1表示为显示对象
		 */
		public var type:int=0;
		/**
		 * 显示对象
		 */
		public var displayObject:DisplayObject;
		/**
		 * 是否可代替已有内容
		 */
		public var isAllowUpdate:Boolean;
		
		public function MsgTipInfo()
		{
		}
	}
}