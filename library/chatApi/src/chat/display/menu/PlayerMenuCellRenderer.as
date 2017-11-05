/**
 * @date 2011-3-24 下午02:47:02
 * @author  hexiaoming
 * 
 */ 
package chat.display.menu
{
	import com.mui.core.GlobalClass;
	
	import fl.controls.listClasses.CellRenderer;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	public class PlayerMenuCellRenderer extends CellRenderer
	{
		private var _textFormat:TextFormat = new TextFormat("宋体",12,0xFFFFFF);
		public static var filter:GlowFilter = new GlowFilter(0x001417,1,2,2,10);
		private var skinBitmap:Bitmap = new Bitmap(new PopUpMenuOverSkin(95,19));
		
		public function PlayerMenuCellRenderer()
		{
			super();
			setSize(95,19);
			this.textField.filters = [filter];
			this.setStyle("overSkin",skinBitmap);
			this.setStyle("downSkin",skinBitmap);
			this.setStyle("overSkin",skinBitmap);
			this.setStyle("upSkin",new Bitmap());
			this.setStyle("selectedDownSkin",skinBitmap);
			this.setStyle("selectedOverSkin",skinBitmap);
			this.setStyle("selectedUpSkin",skinBitmap);
			this.setStyle("textFormat",_textFormat);
			
			this.setStyle("disabledSkin",new Bitmap());
			this.setStyle("disabledTextFormat",new TextFormat("宋体",12,0x9f9f9f));
			
			addListeners();
		}
		
		private function addListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,MouseHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,MouseHandler);
		}
		
		private function MouseHandler(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_OVER)
			{
				this.setStyle("textFormat", new TextFormat("宋体",12,0xf0ea3f));
			}else
			{
				this.setStyle("textFormat",_textFormat);
			}
		}

		override public function set data(arg0:Object):void
		{
			super.data = arg0;
			this.enabled = arg0["enabled"];
		}
	}
}