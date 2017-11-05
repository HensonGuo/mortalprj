package mortal.common
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontName;
	import mortal.common.font.FontUtil;


	public class GTextFormat extends TextFormat
	{
		protected var outSize:int = 12;
		
		public function GTextFormat(font:String = null, size:Object = null, color:Object = null, bold:Object = null, italic:Object = null, underline:Object = null, url:String = null, target:String = null, align:String = null, leftMargin:Object = null, rightMargin:Object = null, indent:Object = null, leading:Object = null)
		{
			super(font,size,color,bold,italic,underline,url,target,align,leftMargin,rightMargin,indent,leading);
			if(font)
			{
				this.font = font;
			}
			else
			{
				this.font = FontUtil.defaultFont.fontName;
			}
			
			if(size)
			{
				this.size = size;
			}
			else
			{
				this.size = 12;
			}
		}
		
		override public function set font(value:String):void
		{
			if(value)
			{
				super.font = value;
			}
			else
			{
				super.font = FontUtil.defaultFont.fontName;
			}
			updateSize();
		}
		
		override public function set size(value:Object):void
		{
			if(value)
			{
				outSize = int(value);
			}
			else
			{
				outSize = 12;
			}
			updateSize();
		}
		
		override public function get size():Object
		{
			return outSize;
		}
		
		protected function updateSize():void
		{
			var fontName:FontName = FontName.getFontByName(this.font);
			if(fontName)
			{
				super.size = fontName.getFontSize(outSize);
			}
			else
			{
				super.size = outSize;
			}
		}
		
		public function setFont(value:String):GTextFormat
		{
			this.font = value;
			return this;
		}
		
		public function setSize(value:int):GTextFormat
		{
			this.size = value;
			return this;
		}
		
		public function setBold(value:Boolean):GTextFormat
		{
			this.bold = value;
			return this;
		}
		
		public function setLeading(value:int):GTextFormat
		{
			this.leading = value;
			return this;
		}
		
		public function center():GTextFormat
		{
			this.align = TextFormatAlign.CENTER;
			return this;
		}
		
		public function left():GTextFormat
		{
			this.align = TextFormatAlign.LEFT;
			return this;
		}
		
		public function clone():GTextFormat
		{
			var textFormatNew:GTextFormat = new GTextFormat();
			textFormatNew.align = this.align;
			textFormatNew.blockIndent = this.blockIndent;
			textFormatNew.bold = this.bold;
			textFormatNew.bullet = this.bullet;
			textFormatNew.color = this.color;
			textFormatNew.display = this.display;
			textFormatNew.font = this.font;
			textFormatNew.indent = this.indent;
			textFormatNew.italic = this.italic;
			textFormatNew.kerning = this.kerning;
			textFormatNew.leading = this.leading;
			textFormatNew.leftMargin = this.leftMargin;
			textFormatNew.letterSpacing = this.letterSpacing;
			textFormatNew.rightMargin = this.rightMargin;
			textFormatNew.size = this.size;
			textFormatNew.tabStops = this.tabStops;
			textFormatNew.target = this.target;
			textFormatNew.underline = this.underline;
			textFormatNew.url = this.url;
			return textFormatNew;
//			var byteArray:ByteArray = new ByteArray();
//			byteArray.writeObject(this);
//			byteArray.position = 0;
//			return byteArray.readObject() as GTextFormat;
		}
	}
}