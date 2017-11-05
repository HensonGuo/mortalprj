/**
 *数字增加特效 
 */
package mortal.game.view.effect
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.mui.controls.GTextFiled;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.game.manager.LayerManager;
	import mortal.game.scene.player.AttributeText;
	import mortal.game.scene.player.AttributeValue;
	import mortal.game.scene.player.type.AttributeTextType;

	public class NumAddEffect
	{
		public function NumAddEffect()
		{
			
		}
		
		public static function playAddNum(num:int,x:Number,y:Number):void
		{
			var attributeTextType:AttributeTextType = new AttributeTextType("");;
			var attributeText:AttributeText = new AttributeText(new AttributeValue(attributeTextType,true,num));
			attributeText.width = 200;
			attributeText.scaleX = 0.5;
			attributeText.scaleY = 0.5;
			attributeText.x = x - 0.5*0.5*attributeText.textWidth;
			attributeText.y = y + 30;
			LayerManager.msgTipLayer.addChild(attributeText);
			var endX:Number = x - 0.5*attributeText.textWidth;
			var endY:Number = y - 100;
			TweenMax.to(attributeText, 1, {x:endX, y:endY, scaleX:1, scaleY:1, ease: Circ.easeOut, onComplete:tweenComplete});
			
			function tweenComplete():void
			{
				if(attributeText)
				{
					attributeText.parent.removeChild(attributeText);
				}
			}
		}
	}
}