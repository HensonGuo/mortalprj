package frEngine.shader.filters.fragmentFilters
{
	import baseEngine.core.Texture3D;
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FcParam;
	import frEngine.shader.registType.Vparam;

	public class UVMaskFilter extends FilterBase
	{
		// maskU ,maskV,maskRotation
		public var uvOffsetAndRotateParams:Vector.<Number> = Vector.<Number>([0 , 0 , 1 , 0]);
		//xy 代表坐标中心点，zw 存放10
		public var uvCenterAndConst:Vector.<Number> = Vector.<Number>([0.5 , 0.5 , 0.33 , -1]);
		private var _maskTexture3D:Texture3D;
		private var _showMaskEnabled:Boolean=false;

		public function UVMaskFilter()
		{
			super(FilterType.UVMask , FilterPriority.UVMaskFilter);
		}
		
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			var _fc0:FcParam = program.getParamByName("{uvCenterAndConst}",false)
			if(!_fc0)
			{
				return;
			}
			_fc0.value=uvCenterAndConst;
			program.getParamByName("{uvOffsetAndRotateParams}",false).value=uvOffsetAndRotateParams;
			program.getParamByName("{UVMaskTexture}",false).value=maskTexture3D;
		}
		
		public override function get programeId():String
		{
			
			return "uvMask0"+FilterBase.ATLFormat[_maskTexture3D.format]+",mask:"+_showMaskEnabled;

		}
		public function set showMaskEnabled(value:Boolean):void
		{
			_showMaskEnabled=value;
		}
		public function get showMaskEnabled():Boolean
		{
			return _showMaskEnabled;
		}
//		public function getRotateAngleVector(angle:Number):void
//		{
//			var sinA:Number = Math.sin(angle);
//			var cosA:Number = Math.cos(angle);
//			uvRotateMatrix[0] = cosA;
//			uvRotateMatrix[1] = -sinA;
//			uvRotateMatrix[2] = 0;
//			uvRotateMatrix[3] = 0;
//			uvRotateMatrix[4] = sinA;
//			uvRotateMatrix[5] = cosA;
//			uvRotateMatrix[6] = 0;
//			uvRotateMatrix[7] = 0;
//			uvRotateMatrix[8] = 0;
//			uvRotateMatrix[9] = 0;
//			uvRotateMatrix[10] = 1;
//			uvRotateMatrix[11] = 0;
//		}
		
		public function changeUVMaskValue(maskU:Number , maskV:Number , maskRotation:Number):void
		{
			uvOffsetAndRotateParams[0] = maskU;
			uvOffsetAndRotateParams[1] = maskV;

			var angle:Number = maskRotation * Math.PI / 180;
			uvOffsetAndRotateParams[2] = Math.cos(angle);
			uvOffsetAndRotateParams[3] = Math.sin(angle);
//			getRotateAngleVector(maskRotation * Math.PI / 180);
		}

		public function set maskTexture3D(value:Texture3D):void
		{
			_maskTexture3D = value;
			
		}
		
		public override function dispose():void
		{
			if(_maskTexture3D)
			{
				_maskTexture3D.dispose();
			}
			super.dispose()
			_maskTexture3D=null;
		}
		public function get maskTexture3D():Texture3D
		{
			return _maskTexture3D;
		}
		
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			//无贴图不处理
			if (!maskTexture3D)
			{
				return "";
			}
			var code:String = "";
			var uvCoord:Vparam = frprogram.getParamByName(FilterName.V_UvOriginalPos,true);
			if(uvCoord)
			{
				var buildinfos:Array = new Array();
				var uvcoordFlag:String = uvCoord.paramName;
				buildinfos.push(new ToBuilderInfo("fc0", "{uvCenterAndConst}", false, 1, uvCenterAndConst));
				buildinfos.push(new ToBuilderInfo("fc1" , "{uvOffsetAndRotateParams}" , false , 1  , uvOffsetAndRotateParams));
				buildinfos.push(new ToBuilderInfo("fs0" , "{UVMaskTexture}" , false , 1  , maskTexture3D));

				//坐标系定位到中心点
				code += "sub	ft0.xy	" + uvcoordFlag + ".xy	fc0.xy	\n"; 
				//坐标系平移UVMask位置
				code += "sub	ft0.xy	ft0.xy	fc1.xy	\n";

				//坐标系旋转
				code += "mul	ft1.xyzw	ft0.xyyx	fc1.zwzw	\n";
				code += "sub	ft2.x	ft1.x	ft1.y	\n";
				code += "add	ft2.y	ft1.z	ft1.w	\n";
				
				//坐标系回到00 点
				code += "add	ft2.xy	fc0.xy	ft2.xy	\n";
				
				if(!uvRepeat)
				{
					//计算出界
					code += "sge	ft3.xy 	ft2.xy	{fcConst1}.xx	\n";
					code += "slt	ft3.zw	ft2.xy	{fcConst1}.zz	\n";
					
					code += "mul	ft3.xy	ft3.xy	ft3.zw	\n";
					code += "mul	ft3.x	ft3.x	ft3.y	\n";
					//遮罩采样  * 是否出界
					code += "tex	ft4		ft2.xy		"+getSmapleString("fs0",maskTexture3D.format,uvRepeat,0)+"	\n";
					code += "mul	ft4		ft4		ft3.x \n";
				}else
				{
					//遮罩采样 
					code += "tex	ft4		ft2.xy		"+getSmapleString("fs0",maskTexture3D.format,uvRepeat,0)+"	\n";
				}
				if(_showMaskEnabled)
				{
					code += "mov	{output}	ft4		\n";
				}else
				{
					code += "dp3	ft4.w		ft4			fc0.z 	\n";
					code += "mul	{output}	{output}	ft4.w 	\n";
				}
				
				code = frprogram.toBuild(code , buildinfos);
			}
			
			return code;
		}
	}
}


