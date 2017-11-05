/**
 * @date	2011-3-10 下午04:23:06
 * @author  宋立坤
 * 
 */	
package mortal.game.resource.info
{
	import mortal.game.scene3D.player.info.ModelInfo;

	public class DefInfo extends ModelInfo
	{
		public var type:String;
		public var id:int;
		public var text:String;
		public var text1:String;
		public var text2:String;
		public var text3:String;
		public var value:int=0;
		
		public function DefInfo()
		{
		}
		
		override public function get modelId():String
		{
			return text;
		}
	}
}