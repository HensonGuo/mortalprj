package mortal.game.view.common.tooltip.tooltips.base
{
	import com.mui.controls.GTextFiled;
	
	import flash.text.TextFieldAutoSize;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	

	
	public class ToolTipLabel extends ToolTipScaleBg
	{		
		protected var _txt:GTextFiled;
		protected var _str:String;
		
		public function ToolTipLabel()
		{
			super();
//			paddingLeft = 6;
//			paddingTop = 4;
//			paddingRight = 4;
//			paddingBottom = 4;
			createChildren();
		}
		
		public override function set data(value:*):void
		{
			_str = value;
			_txt.htmlText = "<textFormat leading='4'>"+ _str +"</textFormat>";
			_width = _txt.width + paddingLeft + paddingRight;
			_height = _txt.height + paddingBottom + paddingTop;
			if(_txt.numLines == 1)
			{
				_height = 20 + paddingBottom + paddingTop;
			}
			_scaleBg.setSize(_width, _height);
			return;
		}
		
		protected function createChildren():void
		{
			setBg(ImagesConst.ToolTipBg);
			
			_txt = new GTextFiled();
			_txt.defaultTextFormat = GlobalStyle.textFormatPutong;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.multiline = true;
			_txt.height = 20;
			contentContainer2D.x = paddingLeft;
			contentContainer2D.y = paddingTop;
			contentContainer2D.addChild(_txt);
		}
		
		public function dispose():void
		{
			while(this.numChildren)
			{
				removeChildAt(0);
			}
		}
	}
}