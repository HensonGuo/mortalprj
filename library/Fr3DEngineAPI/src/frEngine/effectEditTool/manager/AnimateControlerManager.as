package frEngine.effectEditTool.manager
{


	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.effectEditTool.parser.def.EAttributeType;

	public class AnimateControlerManager
	{

		public static function getAnimateTypeByFlag(flag:String):int
		{
			var targetType:int;
			switch(flag)
			{
				case EAttributeType.X:				targetType=AnimateControlerType.PosX;			break;
				case EAttributeType.Y:				targetType=AnimateControlerType.PosY;			break;
				case EAttributeType.Z:				targetType=AnimateControlerType.PosZ;			break;
				case EAttributeType.ScaleX:			targetType=AnimateControlerType.ScaleX;			break;
				case EAttributeType.ScaleY:			targetType=AnimateControlerType.ScaleY;			break;
				case EAttributeType.ScaleZ:			targetType=AnimateControlerType.ScaleZ;			break;
				case EAttributeType.ScaleXYZ:		targetType=AnimateControlerType.ScaleXYZ;		break;
				case EAttributeType.RotationX:		targetType=AnimateControlerType.RotationX;		break;
				case EAttributeType.RotationY:		targetType=AnimateControlerType.RotationY;		break;
				case EAttributeType.RotationZ:		targetType=AnimateControlerType.RotationZ;		break;
				case EAttributeType.U:				targetType=AnimateControlerType.UoffsetControler;				break;
				case EAttributeType.V:				targetType=AnimateControlerType.VoffsetControler;				break;
				case EAttributeType.UV:				targetType=AnimateControlerType.UvStepControler;				break;
				case EAttributeType.Alpha:			targetType=AnimateControlerType.alphaAnimateControler;			break;
				case EAttributeType.UpRadius:		targetType=AnimateControlerType.CylinderUpRadiusControler;		break;
				case EAttributeType.DownRadius:		targetType=AnimateControlerType.CylinderDownRadiusControler;	break;
				case EAttributeType.UVRotate:		targetType=AnimateControlerType.UVRotateAnimationController;	break;
				case EAttributeType.Color:			targetType=AnimateControlerType.colorAnimateControler;			break;
				case EAttributeType.SwordShut:		targetType=AnimateControlerType.swordLight_Bone;				break;
				case EAttributeType.UVCenterScale:	targetType=AnimateControlerType.UVCenterScaleController;		break;
				case EAttributeType.SelectLineRoad:	targetType=AnimateControlerType.LineRoadControler;				break;
			}
			return targetType;
		}

		public static function changeBaseFlagToProperty(flag:String):String
		{
			var targetProperty:String;
			switch(flag)
			{
				case EAttributeType.X:				targetProperty="x";					break;
				case EAttributeType.Y:				targetProperty="y";					break;
				case EAttributeType.Z:				targetProperty="z";					break;
				case EAttributeType.ScaleX:			targetProperty="scaleX";			break;
				case EAttributeType.ScaleY:			targetProperty="scaleY";			break;
				case EAttributeType.ScaleZ:			targetProperty="scaleZ";			break;
				case EAttributeType.RotationX:		targetProperty="rotationX";		break;
				case EAttributeType.RotationY:		targetProperty="rotationY";		break;
				case EAttributeType.RotationZ:		targetProperty="rotationZ";		break;
				case EAttributeType.Alpha:			targetProperty="alpha";				break;
				
			}
			return targetProperty;
		}
	}
}