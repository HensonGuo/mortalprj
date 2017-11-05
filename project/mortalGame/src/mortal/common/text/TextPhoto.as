package mortal.common.text
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 图文混排基类 
	 * @author jianglang
	 * 
	 */	
	public class TextPhoto extends Sprite
	{
		private var _content:String;
		public function TextPhoto()
		{
			
		}

		public function get content():String
		{
			return _content;
		}

		/**
		 * 设置 text 
		 * @param value
		 * 
		 */		
		public function set content( value:String ):void
		{
			content = value;
		}
		/**
		 * 解析text 
		 * 
		 */		
		protected function parseText():void
		{
			
		}
		
		/**
		 * 添加一张图片 
		 * @param displayObject
		 * 
		 */		
		public function addImage( displayObject:DisplayObject ):void
		{
			
		}
		
		/**
		 * 添加一个连接 
		 * @param value
		 * 
		 */		
		public function addlink( value:String ):void
		{
			
		}
		
		/**
		 * 添加一个文本 
		 * @param value
		 * 
		 */		
		public function addText( value:String ):void
		{
			
		}
		
		/**
		 * 显示text 最后一定要调用此方法 
		 * 
		 */		
		public function drawNow():void
		{
			parseText();
		}
		
		public function dispose():void
		{
			
		}
	}
}