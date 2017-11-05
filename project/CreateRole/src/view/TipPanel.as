/**
 * @date	2011-3-31 下午02:36:46
 * @author  宋立坤
 * 
 */	
package view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TipPanel extends Sprite
	{
		private var _txt:TextField;
		private var _bg:Bitmap;
		private var _regExp:RegExp = /\[.*?\]/g;//被[]括起来的任意多个字符
		
		public function TipPanel()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
			init();
		}
		
		private function init():void
		{
			_bg = new Bitmap(new TipsBg());
			_bg.x = -10;
			_bg.y = 0;
			addChild(_bg);
			
//			var g:Graphics = this.graphics;
//			g.beginFill(0x000000,1);
//			g.lineStyle(1,0xff0000);
//			
//			g.moveTo(0,0);
//			g.lineTo(17,27);
//			g.curveTo(20,30,16,30);
//			g.lineTo(5,30);
//			g.curveTo(0,30,0,35);
//			g.lineTo(0,65);
//			g.curveTo(0,70,5,70);
//			g.lineTo(130,70);
//			g.curveTo(135,70,135,65);
//			g.lineTo(135,35);
//			g.curveTo(135,30,130,30);
//			g.lineTo(50,30);
//			g.endFill();
		
			_txt = new TextField();
			_txt.width = 155;
			_txt.height = 60;
			_txt.x = -3;
			_txt.y = 37;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.defaultTextFormat = new TextFormat("宋体",14,0xffffff,null,null,null,null,null,null,null,null,null,6);
			addChild(_txt);
		}
		
		/**
		 * 更新显示 
		 * @param str
		 * 
		 */
		public function updateTips(str:String,colorArr:Array=null):void
		{
			var subStr:String = _regExp.exec(str);
			var i:int=0;
			while(subStr!=null)
			{
				str = str.replace(subStr,"<font color='"+colorArr[i]+"'>"+ subStr.substr(1,subStr.length-2) +"</font>");
				subStr = _regExp.exec(str);
			}
			_txt.htmlText = "<font color='#ffffff'>" + str + "</font>";
		}
	}
}