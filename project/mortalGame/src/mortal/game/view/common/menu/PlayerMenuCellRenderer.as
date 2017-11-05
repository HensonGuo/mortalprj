/**
 * @date 2011-3-24 下午02:47:02
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.common.menu
{
	import com.mui.core.GlobalClass;
	
	import fl.controls.listClasses.CellRenderer;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	
	public class PlayerMenuCellRenderer extends CellRenderer
	{
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
		public function PlayerMenuCellRenderer()
		{
			super();
			var across:Bitmap = ResourceConst.getScaleBitmap(ImagesConst.Menu_overSkin);
			
			setSize(95,19);
			//			this.filters = [FilterConst.glowFilter];
			this.setStyle("downSkin",new Bitmap());
			this.setStyle("overSkin",across);
			this.setStyle("upSkin",new Bitmap());
			this.setStyle("selectedDownSkin",new Bitmap());
			this.setStyle("selectedOverSkin",across);
			this.setStyle("selectedUpSkin",new Bitmap());
			this.setStyle("textFormat",new GTextFormat(null,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER));
			this.setStyle("disabledTextFormat",new GTextFormat(null,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER));
			
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
				this.setStyle("textFormat",GlobalStyle.textFormatHuang.center());
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