package mortal.game.view.effect
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.view.effect.type.AttributeText;
	import mortal.game.view.effect.type.AttributeTextType;
	import mortal.game.view.effect.type.AttributeValue;

	public class AttriAddEffect
	{
		public function AttriAddEffect()
		{
			
		}
		
		/**
		 * 添加飘字
		 * 
		 */
		public static function addToFly(attribValue:AttributeValue, orgPoint:Point, destPoint:Point):void
		{
			var attributeText:AttributeText = new AttributeText(attribValue);
			attributeText.textColor = getShowColor(attribValue.attributeType);
			attributeText.width = 200;
			attributeText.scaleX = 0.5;
			attributeText.scaleY = 0.5;
			attributeText.x = orgPoint.x;
			attributeText.y = orgPoint.y;
			LayerManager.msgTipLayer.addChild(attributeText);
			var endX:Number = destPoint.x;
			var endY:Number = destPoint.y;
			TweenMax.to(attributeText, 1, {x:endX, y:endY, scaleX:1, scaleY:1, ease: Circ.easeOut, onComplete:tweenComplete});
		
			function tweenComplete():void
			{
				if(attributeText)
				{
					attributeText.parent.removeChild(attributeText);
				}
			}
		}
		
		
		/**
		 * 随机飘
		 * 
		 */
		public static function randomFly(attribList:Vector.<AttributeValue>, randomRect:Rectangle):void
		{
			for (var i:int = 0; i < attribList.length; i++)
			{
				var randomOrgX:int = randomRect.x + Math.random() * randomRect.width;
				var randomOrgY:int = randomRect.y + Math.random() * randomRect.height;
				var randomOrgPoint:Point = new Point(randomOrgX, randomOrgY);
				var randomDestX:int = randomRect.x + Math.random() * randomRect.width;
				var randomDestY:int = randomRect.y + Math.random() * randomRect.height;
				var randomDestPoint:Point = new Point(randomDestX, randomDestY);
				addToFly(attribList[i], randomOrgPoint, randomDestPoint);
			}
		}
		
		
		/**
		 * 依次飘
		 * 
		 */
		private static var _timerID:int = 0;
		
		public static function flyInTurn(attribList:Vector.<AttributeValue>, orgPointList:Vector.<Point>, destPointList:Vector.<Point>, delay:int = 500):void
		{
			if (_timerID != 0)
			{
				clearInterval(_timerID);
				_timerID = 0;
			}
			_timerID = setInterval(delayFly, delay, attribList, orgPointList, destPointList);
		}
		
		
		private static function delayFly(attribList:Vector.<AttributeValue>, orgPointList:Vector.<Point>, destPointList:Vector.<Point>):void
		{
			if (attribList.length == 0)
			{
				clearInterval(_timerID);
				_timerID = 0;
				return;
			}
			var attribValue:AttributeValue = attribList.shift();
			var orgPoint:Point = orgPointList.shift();
			var destPoint:Point = destPointList.shift();
			addToFly(attribValue, orgPoint, destPoint);
		}
		
		/**
		 * 根据属性获取飘字颜色
		 * 
		 */
		private static function getShowColor(attributeType:AttributeTextType):uint
		{
			var showColor:uint = 0xff00ff;
			switch(attributeType)
			{
				case AttributeTextType.attack:
					showColor = 0x00ff00;
					break;
				case AttributeTextType.life:
					showColor = 0xff0000;
					break;
				case AttributeTextType.physDefense:
					showColor = 0xed00ab;
					break;
				case AttributeTextType.magicDefense:
					showColor = 0x00ff00;
					break;
				case AttributeTextType.penetration:
					showColor = 0xFF33FF
					break;
				case AttributeTextType.jouk:
					showColor = 0x99FF00
					break;
				case AttributeTextType.hit:
					showColor = 0x00FF00
					break;
				case AttributeTextType.crit:
					showColor =0x99CC33
					break;
				case AttributeTextType.toughness:
					showColor = 0x0066FF
					break;
				case AttributeTextType.block:
					showColor = 0xFF00FF;
					break;
				case AttributeTextType.expertise:
					showColor = 0xFFFF00
					break;
				case AttributeTextType.damageReduce:
					showColor = 0x3300FF
					break;
			}
			return showColor;
		}
	}
}