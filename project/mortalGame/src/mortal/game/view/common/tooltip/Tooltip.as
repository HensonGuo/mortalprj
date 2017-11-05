/**
 * @date 2011-3-24 上午09:44:42
 * @author  wangyang
 * 
 */  
package mortal.game.view.common.tooltip
{
	import com.mui.manager.ItoolTip3D;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mortal.common.DisplayUtil;
	import mortal.game.manager.window3d.IWindow3D;
	import mortal.game.view.common.tooltip.tooltips.ToolTipBaseItem3D;
	
	
	public class Tooltip extends Sprite implements ItoolTip3D
	{
		public var left:DisplayObject;
		public var right:DisplayObject;
		
		
		public function Tooltip()
		{
			super();
		}
		
		public function set data(value:*):void
		{
			clear();
			
			var tips:Array = TooltipFactory.instance.createToolTip(value);
			if(tips == null)
			{
				return;
			}
			if(tips.length >= 1)
			{
				left = tips[0] as DisplayObject;
				this.addChild(left);
			}
			if(tips.length >= 2)
			{
				right = tips[1] as DisplayObject;
				this.addChild(right);
				right.x = left.width + 10;
			}
		}
		
		public function positionChanged():void
		{
			if(left != null && (left is ToolTipBaseItem3D) && left.parent != null)
			{
				(left as ToolTipBaseItem3D).updatePosition();
			}
			if(right != null && (right is ToolTipBaseItem3D) && right.parent != null)
			{
				(right as ToolTipBaseItem3D).updatePosition();
			}
		}
		
		private function clear():void
		{
			DisplayUtil.removeMe(left);
			DisplayUtil.removeMe(right);
		}
		
		public function dispose():void
		{
		}
		
		override public function get width():Number
		{
			var result:Number = 0;
			
			if(left && left.parent)
			{
				result += left.width;
			}
			
			if(right && right.parent)
			{
				result += right.width;
			}
			if(result == 0)
			{
				result = super.width;
			}
			
			return result;
		}
		
		override public function get height():Number
		{
			var hLeft:Number = 0;
			var hRight:Number = 0;
			if(left && left.parent)
			{
				hLeft = left.height;
			}
			
			if(right && right.parent)
			{
				hRight = right.height;
			}
			
			hLeft = Math.max(hLeft, hRight);
			if(hLeft == 0)
			{
				hLeft = super.height;
			}
			return hLeft;
		}
	}
}