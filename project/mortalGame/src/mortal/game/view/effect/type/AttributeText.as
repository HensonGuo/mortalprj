package mortal.game.view.effect.type
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	import mortal.component.gconst.FilterConst;

	public class AttributeText extends TextField
	{
		private var _attributeValue:AttributeValue;
		public static const addColor:int = 0x00ff00;
		public static const reduceColor:int = 0xff0000;
		
		public function AttributeText(attributeValue:AttributeValue)
		{
			_attributeValue = attributeValue;
			setStyle();
			setDisable();
			text = _attributeValue.attributeType.typeName + (_attributeValue.isAdd?"+":"-") + _attributeValue.value.toString();
		}
		
		private function setDisable():void
		{
			this.cacheAsBitmap = true;
			this.mouseEnabled = false;
		}
		
		private function setStyle():void
		{
			this.embedFonts = true;
			var textFormat:TextFormat = new GTextFormat("base",30,_attributeValue.isAdd?addColor:reduceColor,false);
			defaultTextFormat = textFormat;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.filters = [FilterConst.glowFilter];
		}
		
		public function setTextColor(color:int):void
		{
			defaultTextFormat.color = color;
			defaultTextFormat = defaultTextFormat;
		}
	}
}