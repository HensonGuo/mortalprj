package frEngine.effectEditTool.temple
{
	public interface ITemple
	{
		function parsersParams(params:*):void;
		function unHangAll():void;
		function setTempleParams(params:*):void;
		function checkAndPlay():void;
		function dispose():void;
		
	}
	
}