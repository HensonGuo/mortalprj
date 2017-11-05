/**
 * @date	2011-4-6 下午08:41:26
 * @author  jianglang
 * 
 */	
package mortal.common.swfPlayer.data
{
	import mortal.common.swfPlayer.frames.FrameArray;
	import mortal.game.scene3D.player.info.IModelInfo;
	
	
	public interface IMovieClipData
	{
		function getFrame( frame:Object ):int;
		function set modelInfo( info:IModelInfo ):void;
		function get fireFrame():int;
		function getFrames( action:int , direction:int ):FrameArray;
		function get url():String;
		function set loadPriority(value:int):void;
		function load(url:String,onLoaded:Function):void;
		function get referenceCount():int;
		function addReference():void;
		function get actionConut():int;
		function removeReference():void;
		function dispose():void;
		function get pointY():Number;
		function get modleType():int;
		function get isSouthTop():Boolean;
		function get isNorthTop():Boolean;
		function isClear( value:Boolean ):void;
	}
}