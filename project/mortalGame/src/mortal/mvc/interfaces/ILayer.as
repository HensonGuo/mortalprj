/**
 * @date	2011-3-4 下午06:27:07
 * @author  jianglang
 *
 */	

package mortal.mvc.interfaces
{
	import flash.display.DisplayObject;

	public interface ILayer
	{
		function addPopUp( displayObject:DisplayObject , modal:Boolean = false ):void

		function centerPopup( displayObject:DisplayObject ):void;

		function setPosition( displayObject:DisplayObject,x:int,y:int ):void;

		function isTop( displayObject:DisplayObject ):Boolean;

		function removePopup( displayObject:DisplayObject,tweenable:Boolean=true):void;

		function isPopup( displayObject:DisplayObject  ):Boolean;

		function setTop( displayObject:DisplayObject ):void;

		function get width():Number;
		function get height():Number;

	}
}

