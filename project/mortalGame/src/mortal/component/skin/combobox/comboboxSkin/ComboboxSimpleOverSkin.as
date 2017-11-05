package mortal.component.skin.combobox.comboboxSkin
{
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	
	public class ComboboxSimpleOverSkin extends Sprite
	{
		private var _scaleBg:ScaleBitmap;
		public function ComboboxSimpleOverSkin()
		{
			createChildren();
		}
		
		private function createChildren():void
		{
			var _bg:ScaleBitmap = ResourceConst.getScaleBitmap(ImagesConst.WindowCenterB);
			
			var _button:Bitmap = GlobalClass.getBitmap(ImagesConst.ComboButtonS_over);
			_bg.height = _button.height + 5;
			
			var _bgBitmapData:BitmapData = new BitmapData(_bg.width,_bg.height,true, 0x00FFFFFF);
			_bgBitmapData.draw(_bg);
			var _buttonBitmapData:BitmapData = _button.bitmapData;
			
			var vBitmapData:BitmapData = new BitmapData(_bg.width, _bgBitmapData.height,true, 0x00FFFFFF);
			vBitmapData.merge(_bgBitmapData,new Rectangle(0,0,_bgBitmapData.width, _bgBitmapData.height),new Point(0,0),0xFF,0xFF,0xFF,0xFF);
			vBitmapData.merge(_buttonBitmapData,new Rectangle(0,0,_button.width, _button.height),new Point(_bg.width - _button.width - 2,5),0xFF,0xFF,0xFF,0xFF);
			
			_scaleBg = new ScaleBitmap(vBitmapData);
			_scaleBg.scale9Grid = new Rectangle(4,4,10,16);
			this.addChild(_scaleBg);
		}
		
		override public function set width(value:Number):void
		{
			_scaleBg.width = value;
		}
		
		override public function set height(value:Number):void
		{
			_scaleBg.height = value;
		}
	}
}