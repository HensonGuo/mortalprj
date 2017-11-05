package frEngine.shader.filters
{
	public class FilterName
	{
		public static const SKIN_WEIGHTS:String = "{SKIN_WEIGHTS}";
		public static const SKIN_INDICES:String = "{SKIN_INDICES}";//ParticleCindex,swordCIndex
		public static const NORMAL:String = "{NORMAL}";
		public static const COLOR:String = "{COLOR}";	
		public static const UV:String = "{UV}";
		public static const POSITION:String = "{POSITION}";
		public static const PARAM0:String = "{PARAM0}";//VES_DIFFUSE,linePosition2,startTime_animtelife,swordTime
		public static const PARAM1:String = "{PARAM1}";//VES_SPECULAR,lineThickness,"postionOffset"
		public static const PARAM2:String = "{PARAM2}";//VES_BINORMAL,"lineColorOffset",particleSpeed
		public static const PARAM3:String = "{PARAM3}";//VES_TANGENT,autoRotationAngle,
		public static const PARAM4:String = "{PARAM4}";//autoRotationAxis,
		public static const PARAM5:String = "{PARAM5}";//
		public static const PARAM6:String = "{PARAM6}";//
		public static const PARAM7:String = "{PARAM7}";//
		public static const PARAM8:String = "{PARAM8}";//
		
		public static const vcConst1:String="\{vcConst1\}";
		public static const viewPortRect:String="\{viewPortRect\}";
		public static const viewProj:String="\{viewProj\}";
		
		public static const fcConst1:String="\{fcConst1\}";
		public static const dirLight:String = "\{dirLight\}";			//直线光的方向
		public static const dirColor:String = "\{dirColor\}";			//直线光的颜色
		public static const ambientColor:String = "\{ambientColor\}";	//环境光
		
		
		public static const worldViewProj:String = "{worldViewProj}";//物体最终矩阵
		public static const worldView:String = "{worldView}";//物体在相机中的矩阵
		public static const proj:String = "{proj}";//透视矩阵
		
		public static const global:String = "{global}";				//单个物体的世界做标
		public static const bones:String = "{bones}";					//骨骼
		
		
		public static const F_UVPostion:String = "{F_UVPostion}";		//uv最终值
		public static const V_ColorOffset:String = "{V_ColorOffset}";
		public static const V_UvOriginalPos:String = "{V_UvOriginalPos}";		//uv初始值
		public static const V_GloblePos:String = "{V_GloblePos}";		//世界坐标Z值
		public static const V_Screen:String = "{V_Screen}";		//屏幕坐标Z值
		
	}
}