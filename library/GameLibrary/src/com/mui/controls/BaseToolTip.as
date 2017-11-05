package com.mui.controls
{
	import com.mui.core.GlobalClass;
	import com.mui.manager.IToolTip;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class BaseToolTip extends Sprite implements IToolTip
	{
		protected var paddingTop:Number = 5;
		protected var paddingBottom:Number = 5;
		protected var paddingLeft:Number = 5;
		protected var paddingRight:Number = 5;
		
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _contentContainer2D:Sprite;

		public function BaseToolTip() 
		{
			_contentContainer2D = new Sprite();
			super();
		}
		
		public function get contentContainer2D():Sprite
		{
			return _contentContainer2D;
		}

		public function set contentContainer2D(value:Sprite):void
		{
			_contentContainer2D = value;
		}

		protected function updateSize( w:Number , h:Number):void
		{
//				this.graphics.beginFill(0,.5);
//				this.graphics.drawRect(0,0,w,h);
		}
		
		public function set data(value:*):void
		{
			_width = contentContainer2D.width + paddingLeft + paddingRight;
			_height = contentContainer2D.height + paddingTop + paddingBottom;
			contentContainer2D.y = paddingTop;
			contentContainer2D.x = paddingLeft;
			updateSize(_width,_height);
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function get height():Number
		{
			return _height;
		}
	}
}