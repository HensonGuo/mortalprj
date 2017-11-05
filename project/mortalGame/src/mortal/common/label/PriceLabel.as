/**
 * @date 2012-6-30 下午01:33:04
 * @author cjx
 */
package mortal.common.label
{
	import com.mui.controls.GLabel;
	
	import flash.display.Sprite;
	
	public class PriceLabel extends GLabel
	{
		
		private var _redLine:Sprite;
		
		public function PriceLabel()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_redLine = new Sprite();
			this.addChild(_redLine);
		}
		
		public function drawRedLine():void
		{
			_redLine.graphics.clear();
			_redLine.graphics.moveTo(0,this.height/2);
			_redLine.graphics.lineStyle(2,0xFF0000,0.75);
			_redLine.graphics.lineTo(this.textField.textWidth,this.height/2);
		}
		
		public function clearRedLine():void
		{
			_redLine.graphics.clear();
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			clearRedLine();
			super.dispose(isReuse);
		}
	}
}