package mortal.game.view.common.item
{
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.text.TextFieldAutoSize;
	
	import mortal.component.gconst.ResourceConst;
	
	public class ComboboxItemCellRender extends GCellRenderer
	{
		private var _bg:ScaleBitmap;
		private var _across:ScaleBitmap;
		protected var _nameText:GTextFiled;
		public function ComboboxItemCellRender()
		{
			super();
			init();
//			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
//			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		
		public function init():void
		{
//			_bg = ResouceConst.getScaleBitmap("WindowCenterB");
//			_bg.width = 100;
//			_bg.height = 20;
//			this.addChild(_bg);
			
			_across = ResourceConst.getScaleBitmap("PopUpMenuOverSkin");
//			_across.visible = false;
//			this.addChild(_across);
			
//			_nameText = new GTextFiled();
//			_nameText.selectable = false;
//			_nameText.autoSize = TextFieldAutoSize.CENTER;
//			_nameText.textColor = 0xB1F0FF;
//			this.addChild(_nameText);
			
			setStyle("downSkin",_across);
			setStyle("overSkin",_across);
			setStyle("upSkin",new Bitmap());
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
//			_nameText.width = value;
			_across.width = value;
		}
		
//		override public function set data(arg0:Object):void
//		{
//			var friendName:String = arg0['label'] as String;
//			_nameText.text = friendName;
//		}
		
//		private function onMouseMove(event:MouseEvent):void
//		{
//			_across.visible = true;
//			_nameText.textColor = 0xF4FE00;
//		}
//		
//		private function onMouseOut(event:MouseEvent):void
//		{
//			_across.visible = false;
//			_nameText.textColor = 0xB1F0FF;
//		}
	}
}