/**
 * @date	2011-4-18 上午09:50:06
 * @author  jianglang
 * 
 */	

package mortal.common.swfPlayer.data
{
	

	public class ModelType
	{
		public static var Attack:ModelType = new ModelType( "attack",MovieClipData );//"玩家";
		public static var SwimSwf:ModelType = new ModelType("swim",MovieClipData); //游泳
		public static var Stall:ModelType = new ModelType("stall",MovieClipData);//摆摊
		public static var SunBath:ModelType = new ModelType("sunBath",MovieClipData);//摆摊
		public static var NPCStatus:ModelType = new ModelType("npcStatus",SWFMovieClipData);//任务状态
		public static var LevelUp:ModelType = new ModelType("level",SWFMovieClipData);//任务状态
		public static var NormalSwf:ModelType = new ModelType("normalSwf",SWFMovieClipData);
		public static var DirSkill:ModelType = new ModelType("dirSkill",MovieClipData);
		public static var GuidePath:ModelType = new ModelType("guidePath",MovieClipData);//路径指引
		public static var Fly:ModelType = new ModelType("fly",MovieClipData);//路径指引
		public static var WXSkillEffect:ModelType = new ModelType("wxSkillEffect",MovieClipData);//五行技能图标效果
		public static var WXPlayer:ModelType = new ModelType("wxPlayer",SWFMovieClipData);//五行珠子
		public static var FabaoPlayer:ModelType = new ModelType("fabaoPlayer",SWFMovieClipData);//五行珠子
		
		public var type:String;
		public var dataClass:Class;
		
		public function ModelType( type:String , dataClass:Class )
		{
			this.type = type;
			this.dataClass = dataClass;
		}
		
		public function getMovieClipData():IMovieClipData
		{
			return new dataClass(type);
		}
	}
}
