/**
 * 2014-2-14
 * @author chenriji
 **/
package mortal.component.GCatogeryList
{
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	
	import mortal.game.view.common.interfaces.IDisplayObject;

	public interface ICatogeryListHead extends IDisplayObject
	{
		function get index():int;
		function set index(value:int):void;
		function set dataProvider(value:DataProvider):void;
		function get dataProvider():DataProvider;
		function set cellRender(value:Class):void;
		function get cellRender():Class;
		function get cellHeight():int;
		function set cellHeight(value:int):void;
		function expand():void;
		function unexpand():void;
		function updateData(obj:Object):void;
		function setSize($width:Number, $height:Number):void;
		function get isExpanding():Boolean;
	}
}