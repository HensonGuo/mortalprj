/**
 * @date	2011-4-20 上午10:16:46
 * @author  jianglang
 * 
 * 
 * <skill code="1",skillType="1" src="100101.swf",hit_point="1",scale_x="1",scale_y="1",pos_x="0",pos_y="0",sound="",dir="0",duration="",depth="1",blend_mode="",mode="1",rotation="0"/>
 */	

package mortal.game.resource.info
{
	import mortal.game.scene.player.info.ModelInfo;

	public class SkillModelInfo extends ModelInfo
	{
		public var code:int;
		public var skillType:int;
		public var src:String;
		public var hit_point:int;
		public var scale_x:int;
		public var scale_y:int;
		public var pos_x:int;
		public var pos_y:int;
		public var sound:String;
		public var dir:int;
		public var duration:int;
		public var depth:int;
		public var blend_mode:int;
		public var mode:int;
		public var rotation:int;
		public var isThrow:int;
		public var isCopy:int;
		public var isNeedShotAction:int = 1;
		public var param1:String;//一些需要特殊处理的参数 ，比如用于存储闪电链中途的链接效果
		
		public function SkillModelInfo()
		{
			
		}
		
		override public function get modelId():String
		{
			return ""+code;
		}
	}
}
