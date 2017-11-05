package view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class IntroTipPanel extends Sprite
	{
		private var _textField:TextField;
		private var _bgMc:ToolTipBgMc;
		
		public function IntroTipPanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_bgMc = new ToolTipBgMc();
			_bgMc.width = 200;
			_bgMc.height = 70;
			_bgMc.x = 0;
			_bgMc.y = 0;
			addChild(_bgMc);
			
			_textField = new TextField();
			_textField.width = 200;
			_textField.height = 20;
			_textField.wordWrap = true;
			_textField.multiline = true;
			_textField.selectable = false;
			_textField.x = 5;
			_textField.y = 5;
			_textField.defaultTextFormat = new TextFormat("",13,0xffffff);
			addChild(_textField);
		}
		
		public function updateIntro(camp:int):void
		{
			var str:String = "";
			switch(camp)
			{
				case 1:
					str = "逍遥古国：崇尚修身养性，以心证道，传统修仙者。";
					break;
				case 2:
					str = "星辰古国：崇尚战斗，以战证道，性格狂野好战。";
					break;
				case 3:
					str = "苍穹古国：崇尚自然，骁勇善战，无拘无束，性格豪迈随意。";
					break;
			}
			_textField.text = str;
			_textField.height = _textField.textHeight + 10;
			_bgMc.height = _textField.textHeight + 15;
		}
	}
}