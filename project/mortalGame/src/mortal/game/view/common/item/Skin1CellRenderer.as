package mortal.game.view.common.item
{
	import flash.display.Sprite;

	public class Skin1CellRenderer extends NoSkinCellRenderer
	{
		public function Skin1CellRenderer()
		{
			super();
		}
		
		override protected function initStyle():void
		{
			super.initStyle();
			this.setStyle("overSkin",new overSkin());
			var skinsp:Sprite=new clickSkin()
			this.setStyle("selectedDownSkin",skinsp );
			this.setStyle("selectedOverSkin", skinsp);
			this.setStyle("selectedUpSkin", skinsp);
		}
	}
}

import com.mui.core.GlobalClass;

import flash.display.Bitmap;
import flash.display.Sprite;

import mortal.game.resource.ImagesConst;
import mortal.game.view.common.UIFactory;

class clickSkin extends Sprite
{
	private var _innerWidth:Number	= 0;
	
	private var _innerHeight:Number = 0;
	
	public function clickSkin()
	{
		this.mouseChildren = false;
		this.mouseEnabled = false;
		
	}
	
	override public function set width(value:Number):void
	{
		_innerWidth = value;
		draw();
	}
	
	override public function set height(value:Number):void
	{
		_innerHeight = value;
		draw();
	}
	
	public function draw():void
	{
		this.graphics.clear();
		this.graphics.beginFill(0x0d7079,1);
		this.graphics.drawRoundRect(1,0,_innerWidth,_innerHeight - 1,6,6);
		this.graphics.endFill(); 
	}
	
}

class overSkin extends Sprite
{
	private var _innerWidth:Number	= 0;
	
	private var _innerHeight:Number = 0;
	
	public function overSkin()
	{
		this.mouseChildren = false;
		this.mouseEnabled = false;
	}
	
	override public function set width(value:Number):void
	{
		_innerWidth = value;
		draw();
	}
	
	override public function set height(value:Number):void
	{
		_innerHeight = value;
		draw();
	}
	
	public function draw():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(2,0x00ff7f,1);
		this.graphics.drawRoundRect(1,0,_innerWidth,_innerHeight - 1,6,6);
		this.graphics.endFill();
	}
	
}
