package frEngine.loaders
{
	import baseEngine.materials.Material3D;

	public class EngineConstName
	{
		public static const defaultNullStringFlag:String="未选择";
		
		public static const BLEND_NONE:String = "无";
		public static const BLEND_LIGHT:String = "点亮";
		public static const BLEND_OVERLAYER:String = "叠加";
		public static const BLEND_ADDITIVE:String = "加强";
		public static const BLEND_COLOR:String = "颜色";
		public static const BLEND_SCREEN:String = "场景";
		public static const BLEND_ALPHA0:String = "透明0";
		public static const BLEND_ALPHA1:String = "透明1";
		public static const BLEND_ALPHA2:String = "透明2";
		public static const BLEND_CUSTOM:String = "自定义";
		
		public static const PlayMode_NONE:String = "无";
		public static const PLAYMODE_CIRCLE:String = "首未相接";
		
		public static const FADETOGROWTH:String = "先消亡再增长";
		public static const GROWTHTOFADE:String = "先增长再消亡";
		
		public static const axixType0:String="球形随机";
		public static const axixType1:String="圆形随机";
		public static const axixType2:String="指定方向";
		public static const axixType3:String="指向球心";
		public static const axixType4:String="背向球心";
		
		public static const emmitRate:String="发射率";
		public static const emmitCount:String="发射总数";
		
		public static const particleType0:String="十字面片";
		public static const particleType1:String="立方体";
		public static const particleType2:String="模型";
		public static const particleType3:String="面片";
		
		public static const particleFaceDirection0:String="无";
		public static const particleFaceDirection1:String="面对相机";
		public static const particleFaceDirection2:String="运动方向";
		public static const particleFaceDirection3:String="上";
		public static const particleFaceDirection4:String="下";
		public static const particleFaceDirection5:String="左";
		public static const particleFaceDirection6:String="右";
		public static const particleFaceDirection7:String="前";
		public static const particleFaceDirection8:String="后";
		
		public static const emitTime0:String="只有一次";
		public static const emitTime1:String="有限时间";
		public static const emitTime2:String="始终发射";

		public static const emitterShapeChoose0:String="球形";
		public static const emitterShapeChoose1:String="圆形";
		public static const emitterShapeChoose2:String="半球";
		public static const emitterShapeChoose3:String="锥形";
		public static const emitterShapeChoose4:String="立方体";
		public static const emitterShapeChoose5:String="平面";
		public static const emitterShapeChoose6:String="网格";
		
		public static const emitterPosType0:String="曲面";
		public static const emitterPosType1:String="轴心";
		public static const emitterPosType2:String="顶点";
		public static const emitterPosType3:String="边";
		public static const emitterPosType4:String="体积";
		
		//分布方式
		public static const randomFlag:String="随机";
		public static const linearFlag:String="均匀";

		public static function getMotionType(flag:String):int
		{
			var targetValue:int=0;
			switch(flag)
			{
				case axixType0:					targetValue=1;					break;
				case axixType1:					targetValue=2;					break;
				case axixType2:					targetValue=3;					break;
				case axixType3:					targetValue=4;					break;
				case axixType4:					targetValue=5;					break;
			}
			return targetValue;
		}
		
		public static function getPlayModeByName(playType:String):int
		{
			var playMode:int=0;
			switch (playType)
			{
				case  PlayMode_NONE:
					playMode = 0;
					break;
				case PLAYMODE_CIRCLE:
					playMode = 1;
					break;
			}
			return playMode;
			
		}
		
		public static function getBlendModeByName(blendType:String):int
		{
			var blendMode:int=Material3D.BLEND_NONE;
			switch (blendType)
			{
				case BLEND_NONE:
					blendMode = Material3D.BLEND_NONE;
					break;
				case BLEND_ADDITIVE:
					blendMode = Material3D.BLEND_ADDITIVE;
					break;
				case BLEND_ALPHA0:
					blendMode = Material3D.BLEND_ALPHA0;
					break;
				case BLEND_ALPHA1:
					blendMode = Material3D.BLEND_ALPHA1;
					break;
				case BLEND_ALPHA2:
					blendMode = Material3D.BLEND_ALPHA2;
					break;
				case BLEND_LIGHT:
					blendMode = Material3D.BLEND_LIGHT;
					break;
				case BLEND_COLOR:
					blendMode = Material3D.BLEND_COLOR;
					break;
				case BLEND_OVERLAYER:
					blendMode = Material3D.BLEND_OVERLAYER;
					break;
				case BLEND_SCREEN:
					blendMode = Material3D.BLEND_SCREEN;
					break;
				case BLEND_CUSTOM:
					blendMode = Material3D.BLEND_CUSTOM;
					break;
			}
			return blendMode;
			
		}
	}
}