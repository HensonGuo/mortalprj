package frEngine.shader.filters.vertexFilters
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Texture3D;
	
	import frEngine.animateControler.particleControler.ParticleParams;
	import frEngine.effectEditTool.parser.def.ELineType;
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	import frEngine.shader.registType.FcParam;
	import frEngine.shader.registType.FtParam;
	public class ParticleVertexFilter extends VertexFilter
	{
		public var particleParams:ParticleParams;
		public static const maxConstRegistNum:uint=90;
		private var time_perCircleTime_maxDuring_curHeadIndex:Vector.<Number>=Vector.<Number>([0, 1, 100, 0]);
		private var frictionSize:Vector.<Number>=Vector.<Number>([0,0,0,0]);
		private var lineForce:Vector.<Number>=Vector.<Number>([0,0,0,0]);
		private var globlePosition:Vector.<Number>=Vector.<Number>([0,0,0,0]);
		
		public function ParticleVertexFilter($particleParams:ParticleParams=null)
		{
			particleParams = $particleParams;
			super(FilterType.particleAnimate);
		}

		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			/*vc0,vc3,vc7还没有定义*/
			
			//vc2
			program.getParamByName("{const}",true).value=Vector.<Number>([particleParams.perParticleEmitterTime, particleParams.total_number, particleParams.rotateAxisYSpeed, particleParams.lixinForceSize]);

			//vc3
			program.getParamByName("{const2}",true).value=Vector.<Number>([particleParams.growth_time, particleParams.fade_time, particleParams.inertiaValue, particleParams.emitterTimeEffectPeriod-particleParams.perParticleEmitterTime*1.01]);
			
			
			//vc1
			program.getParamByName("{time_perCircleTime_maxDuring_curHeadIndex}",true).value=time_perCircleTime_maxDuring_curHeadIndex;
			
			if(particleParams.useFriction && particleParams.useSpeed)
			{
				//vc5
				program.getParamByName("{frictionSize}",true).value = frictionSize;
			}
			
			if (particleParams.useLineForce  )
			{
				//vc8
				program.getParamByName("{lineForce}",true).value = lineForce;
			}
			if(!particleParams.distanceBirth && !particleParams.tailEnabled && !particleParams.multyEmitterEnabled)
			{
				//vc4
				program.getParamByName("{globlePosition}",true).value = globlePosition;
			}

			if(particleParams.uvStep)
			{
				//fc0
				var uvStep:Vector3D = particleParams.uvStep;
				var uvSpeed:Number= isNaN(uvStep.z)?1:uvStep.z;
				var fc:FcParam= program.getParamByName("{UVdata}",false);
				if(fc)
				{
					fc.value = Vector.<Number>([1 / uvStep.x, 1 / uvStep.y, uvStep.w, 1 / uvSpeed]);
				}
			}
			
			if(particleParams.useColor || particleParams.useAlpha)
			{
				//fc1
				program.getParamByName("{dateaTexture}",false).value = particleParams.dateaTexture;
				program.getParamByName("{fconst0}",false).value = Vector.<Number>([0,0.8, 0, 0]);
			}

			
		}
		
		public override function getParams():XML
		{
			var xml:XML = <params/>;
			/*var param0:XML=new XML("<param paramIndex='0' classType='Number' value='"+skinNum+"'/>");
			xml.appendChild(param0);*/
			return xml;
		}

		public override function get programeId():String
		{
			var _id:String="pc:";
			particleParams.distanceBirth && (_id+="0")
			particleParams.useTimeGrowth && (_id+="1")
			particleParams.useColor && (_id+="2")
			particleParams.useGrowthAndFadeType && (_id+=("F"+particleParams.useGrowthAndFadeType))
			particleParams.autoRotaionInfo && (_id+="3")
			particleParams.faceCamera && (_id+="4")
			particleParams.useSpeed && (_id+="5")
			particleParams.useFriction && (_id+="6")
			particleParams.useLineForce && (_id+="7")
			particleParams.uvStep && (_id+="8")
			particleParams.useAlpha && (_id+="9")
			particleParams.useLiXinForce && (_id+="#0")
			particleParams.useRotateAxisY && (_id+="#1")
			particleParams.tailEnabled && (_id+="#2")
			particleParams.useRotation && (_id+="#3")
			particleParams.useScale && (_id+="#4");
			
			if(particleParams.multyEmitterEnabled)
			{
				_id+="#5";
				_id+="#"+particleParams.multyEmmiterLineType;
			}
			
			(particleParams.tailEnabled || particleParams.distanceBirth) && particleParams.inertiaValue && (_id+="#6")
			
			return _id;
		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			frprogram.OpType=ECalculateOpType.ViewProj;
			//vc0,vc7还没有定义
			var toReplace:Array = [];
			var rotationOffset:int = 0;

			if (particleParams.distanceBirth || particleParams.tailEnabled || particleParams.multyEmitterEnabled)
			{
				var num:int=particleParams.multyEmitterEnabled?2:1;
				toReplace.push(new ToBuilderInfo("vc0-60", "{vc0-60}", false, maxConstRegistNum)); //位移
				toReplace.push(new ToBuilderInfo("va4", FilterName.SKIN_INDICES, false, num));//Cindex
			}
			
			//toReplace.push(new ToBuilderInfo("vm2", "emitterTransform", false, 4, false, new Matrix3D));
			toReplace.push(new ToBuilderInfo("vc1", "{time_perCircleTime_maxDuring_curHeadIndex}", false, 1, time_perCircleTime_maxDuring_curHeadIndex));
			
			toReplace.push(new ToBuilderInfo("vc2", "{const}", false, 1, [particleParams.perParticleEmitterTime, particleParams.total_number, particleParams.rotateAxisYSpeed, particleParams.lixinForceSize]));
			
			toReplace.push(new ToBuilderInfo("vc7", "{const2}", false, 1, [particleParams.growth_time, particleParams.fade_time,particleParams.inertiaValue,particleParams.emitterTimeEffectPeriod-particleParams.perParticleEmitterTime*1.01]));
			
			
			if(particleParams.useRotation)
			{
				toReplace.push(new ToBuilderInfo("vm0", "{globleRotation}", false, 4, null));
			}
			
			
			toReplace.push(new ToBuilderInfo("va0", FilterName.POSITION, true, 3));
			
			toReplace.push(new ToBuilderInfo("va1", FilterName.PARAM0, false, 3));//"index_animtelife_random"

			
			toReplace.push(new ToBuilderInfo("va3", FilterName.PARAM1, false, 4));//"postionOffset"

			var vertexCode:String = "";

			//将粒子所在段数，进行位置插值
			if (particleParams.distanceBirth)
			{
				if(particleParams.multyEmitterEnabled)
				{
					vertexCode += "mov           vt5      	 	 vc[va4.y]           							\n";
					vertexCode += "mul           vt0.y      		 va4.x				vt5.y           			\n"; 
					vertexCode += "sub           vt2.w      		 vc1.x				vt0.y           			\n";  //当前粒子第n个距离发射器的开始时间
					vertexCode += "mul           vt0.x      		 vc2.x				va1.x           			\n"; //当前粒子的播放起初时间。
					vertexCode += "sub           vt0.x      		 vt2.w				vt0.x           			\n"; //当前粒子的播放时间。
				}
				else
				{
					vertexCode += "mov           vt0      	 	 vc[va4.x]           							\n";
					vertexCode += "sub           vt0.y      	 	 vc1.x				vt0.w           			\n";
					vertexCode += "mul           vt0.x      		 vc2.x				va1.x           			\n"; //当前粒子的播放起初时间。
					vertexCode += "sub           vt0.x      		 vt0.y				vt0.x           			\n"; //当前粒子的播放时间。
				}
				
			}
			else
			{
				vertexCode += "mul           vt0.x      		 vc2.x				va1.x           			\n"; //当前粒子的播放起初时间。
				vertexCode += "sub           vt0.x      		 vc1.x				vt0.x           			\n"; //当前粒子的播放时间。
			}
			
			
			vertexCode += "div           vt0.y      		 vt0.x				vc1.y           			\n"; //当前粒子的播放时间,小数部分和整数部分
			vertexCode += "frc           vt0.z      		 vt0.y				           				\n"; //当前粒子的播放时间,小数部分(即生命的百分比)
			vertexCode += "sub           vt0.w      		 vt0.y				vt0.z           			\n"; //当前粒子的播放时间,整数部分
			vertexCode += "mul           vt2.x      		 vt0.z				vc1.y           			\n"; //当前动画在一个周期内的时间


			vertexCode += "div           vt2.z       		 vt2.x  		  	va1.y						\n"; //计算动画生命百分比

			if(particleParams.useTimeGrowth)
			{
				//判断播放时间是否大于0
				vertexCode += "sge           vt2.y      		 vt0.x				{vcConst1}.x           	\n"; //当前是否停止播放
				//最大值为粒子的生命值
				vertexCode += "slt           vt4.x       	 vt2.z  		  	{vcConst1}.z				\n";
				vertexCode += "min           vt2.y      		 vt4.x				vt2.y           			\n";
			}else
			{
				//最大值为粒子的生命值
				vertexCode += "slt           vt2.y       	 vt2.z  		  	{vcConst1}.z				\n";
			}

			//判断播放周期

			if(!particleParams.multyEmitterEnabled)
			{
				vertexCode += "sge           vt3.x      		 vt0.w				vc1.z           			\n";
				vertexCode += "sub           vt3.x      		 {vcConst1}.z		vt3.x           			\n"; 
				vertexCode += "min           vt2.y      		 vt3.x				vt2.y           			\n";
			}
			
			
			if (particleParams.useGrowthAndFadeType)
			{
				particleParams.useGrowthAndFadeType==1 && (vertexCode+=getGrowthAndFade());
				particleParams.useGrowthAndFadeType==2 && (vertexCode+=getFadeAndGrowth());
			}
			else
			{
				vertexCode += "mov 		 	 vt1 			 	 va0 											\n";
			}

			if(particleParams.useScale)
			{
				toReplace.push(new ToBuilderInfo("vc3", "{localScale}", false, 1, null));
				vertexCode += "mul           vt1      	 	 vt1				vc3           				\n";
			}

			if (particleParams.autoRotaionInfo)
			{
				toReplace.push(new ToBuilderInfo("va6", FilterName.PARAM3, false, 2));//autoRotationAngle
				vertexCode += "mul 		vt4.x				vt2.z				va6.x			\n";
				vertexCode += "add 		vt4.x				vt4.x				va6.y			\n";
				
				if(particleParams.faceCamera)
				{
					vertexCode += "cos				vt3.z				vt4.x									\n"; 
					vertexCode += "sin				vt3.w				vt4.x									\n";
					vertexCode += "mul				vt4.xyzw			vt3.zwwz			vt1.xyxy			\n";
					vertexCode += "sub				vt1.x				vt4.x				vt4.y				\n";
					vertexCode += "add				vt1.y				vt4.z				vt4.w				\n";
				}else
				{
					toReplace.push(new ToBuilderInfo("va5", FilterName.PARAM4, false, 3));//autoRotationAxis
					
					//将旋转轴转为四元数
					vertexCode += "mov 		vt6					va5									\n";
					vertexCode += "sin 		vt6.w				vt4.x								\n";
					vertexCode += "mul 		vt6.xyz				vt6.w				vt6.xyz			\n";
					vertexCode += "cos 		vt6.w				vt4.x								\n";
					
					//四元数单位化
					vertexCode += "dp4 		vt3.x 				vt6					vt6				\n";
					vertexCode += "rsq 		vt3.x 				vt3.x								\n";
					vertexCode += "mul 		vt6					vt3.x				vt6				\n";
					
					//用四元数进行旋转，具体可以参考Quaterniton.as
					vertexCode += "mov 		vt3.xyzw			vt6.wzyx							\n";
					vertexCode += "mov 		vt4.xyzw			vt6.zwxy							\n";
					vertexCode += "mov 		vt5.xyzw			vt6.yxwz							\n";
					
					vertexCode += "neg 		vt3.y				vt3.y								\n";
					vertexCode += "neg 		vt4.z				vt4.z								\n";
					vertexCode += "neg 		vt5.x				vt5.x								\n";
					
					vertexCode += "mov 		vt1.w				{vcConst1}.x						\n";
					vertexCode += "m44 		{output}			vt1					vt3				\n";
					vertexCode += "m44 		vt1 				{output}			vt3				\n";
				}
			}

			//以下几行是否面对相机
			if (particleParams.faceCamera)
			{
				toReplace.push(new ToBuilderInfo("vm3", "{rotationMatrixRegister}", false, 3, new Matrix3D));
				vertexCode += "m33 		 vt1.xyz 			 vt1.xyz 			vm3							\n";
			}
			else if(particleParams.useRotation)
			{
				vertexCode += "m33 		 	 vt1.xyz 			 	vt1.xyz					vm0 				\n";
			}
			
			//算出速度位移
			if (particleParams.useSpeed)
			{
				toReplace.push(new ToBuilderInfo("va2", FilterName.PARAM2, false, 3));
				if (particleParams.useFriction)
				{
					toReplace.push(new ToBuilderInfo("vc5", "{frictionSize}", false, 1, frictionSize));
					
					vertexCode += "min           vt5.xyz      		vt2.xxx				vc5.xyz           \n";//vc5表示速度为0时的时间
					vertexCode += "mul           vt3      			vt5.xyz				va2					\n";
					vertexCode += "mul           vt5.xyz      		vt5.xyz				vt5.xyz           \n";//时间t的平方
					vertexCode += "div           vt4      		 	va2					vc5.xyz           \n";//求得加速度a
					vertexCode += "mul           vt4      		 	vt4					{vcConst1}.y      \n";//0.5*a
					vertexCode += "mul           vt4      		 	vt5.xyz				vt4           		\n";//0.5*a*t的平方
					vertexCode += "sub           vt3      		 	vt3					vt4           		\n";
				}else
				{
					vertexCode += "mul           vt3      		 	 vt2.x				va2					\n";
				}
				
				vertexCode += "add           vt3      	 		 va3				vt3           			\n";
				
			}else
			{
				vertexCode += "mov           vt3      	 		 va3				           			\n";
			}

			//vt3,单个粒子位置偏移
			
			if (particleParams.hasForce)
			{
				vertexCode += "mul           vt4.w      		 		vt2.x				vt2.x           	\n";
			}
			
			if (particleParams.useLineForce )
			{
				toReplace.push(new ToBuilderInfo("vc8", "{lineForce}", false, 1, lineForce ));
				vertexCode += "mul           vt5      		 		vc8					vt4.w           	\n";
				vertexCode += "mul           vt5      		 		vt5					{vcConst1}.y           	\n";
				vertexCode += "add           vt3      	 		 	vt3					vt5           		\n";
			}
			if (particleParams.useRotateAxisY || particleParams.useLiXinForce)
			{
				//算出到Y轴的距离
				vertexCode += "mov				vt5						vt3										\n";
				vertexCode += "mov				vt5.y					{vcConst1}.x							\n";
				vertexCode += "dp3           	vt4.y					vt5.xyz				vt5.xyz           \n";
				vertexCode += "sqt           	vt4.y					vt4.y					       			\n";
				
				if(particleParams.useLiXinForce)
				{
					//重新计算Y轴距离
					vertexCode += "mul           	vt4.z					vt4.w				vc2.w           	\n";
					vertexCode += "mul           	vt4.z      		 	vt4.z				{vcConst1}.y      \n";
					vertexCode += "sub           	vt4.y					vt4.y				vt4.z           	\n";
					vertexCode += "max           	vt4.y					vt4.y				{vcConst1}.x      \n";
				}
				
				if (particleParams.useRotateAxisY )
				{
					vertexCode += "mul           	vt4.z      		 		vc2.z				vt2.x           	\n";
					vertexCode += "add           	vt4.z      		 		vt4.z				va3.w           	\n";
					vertexCode += "cos				vt4.x						vt4.z									\n";
					vertexCode += "sin				vt4.z						vt4.z									\n";
					vertexCode += "mul           	vt3.xz						vt4.xyz				vt4.y           	\n";
				}else 
				{
					//计算离心力的最终位移
					vertexCode += "nrm           	vt5.xyz					vt5.xyz					       			\n";
					vertexCode += "mul           	vt3.xz      		 	vt5.xyz					vt4.y          \n";
					
				}
			}
			
			
			if(particleParams.useRotation)
			{
				vertexCode += "m33 		 	 vt3.xyz 			 	vt3.xyz					vm0 				\n";
			}
			
			
			if(particleParams.multyEmitterEnabled)
			{
				
				if(particleParams.multyEmmiterLineType==ELineType.point)
				{
					vertexCode += "add           vt3      	 		 vt3				vc[va4.y]         \n";
				}else
				{
					vertexCode +=getMultyEmmiterCodeLinear();
				}
				
				
			}
			else if(particleParams.distanceBirth || particleParams.tailEnabled)
			{
				
				if(particleParams.inertiaValue)
				{
					vertexCode += "sub           vt3.w      	 		 va4.x				{vcConst1}.z         \n";
					if(particleParams.distanceBirth)
					{
						vertexCode += "max           vt3.w      	 		 vt3.w				{vcConst1}.x         \n";
					}else
					{
						vertexCode += "slt           vt2.w      	 		 vt3.w				{vcConst1}.x         	\n";
						vertexCode += "mul           vt2.w      	 		 vt2.w				vc2.y         			\n";
						vertexCode += "add           vt3.w      	 		 vt2.w				vt3.w         			\n";
						
						//因为是循环数组，所以并头部应该设为不可见，否则效果不对
						vertexCode += "sge           vt2.w      	 		 vc7.w				vt2.x         			\n";
						vertexCode += "min           vt2.y      	 		 vt2.y				vt2.w         			\n";
					}
					
					vertexCode += "mov           vt4      	 		 vc[va4.x]           						\n";
					vertexCode += "sub           vt5      	 		 vt4           	vc[vt3.w]				\n";
					vertexCode += "mul           vt5      	 		 vt5				vc7.z           		\n";
					vertexCode += "mul           vt5      		 	 vt5				vt2.x					\n";
					vertexCode += "add           vt3      	 		 vt3				vt4           			\n";
					vertexCode += "add           vt3      	 		 vt3				vt5           			\n";
				}else
				{
					vertexCode += "add           vt3      	 		 vt3				vc[va4.x]           	\n";
				}
			}
			else
			{
				toReplace.push(new ToBuilderInfo("vc4", "{globlePosition}", false, 1, globlePosition));
				vertexCode += "add           vt3      	 		 vt3				vc4           			\n";
			}

			
			
			
			
			vertexCode += "add           vt1      	 		 vt1					vt3           		\n";

			
			
			//计算位置最终结果

			vertexCode += "mul           {output}      	 vt2.y				 vt1.xyz          \n";
			vertexCode += "mov           {output}.w      {vcConst1}.z           				\n";


			toReplace.push(new ToBuilderInfo("vf3", "{V_ParticleLife}", false, 1));

			vertexCode += "mov           vf3      			vt2.xyzz  		 	 			\n"; //xy位置
			vertexCode += "mov           vf3.w      			va1.z  		 	 				\n"; //random随机值
			//vertexCode += "div           vt3.w      	 		 va1.x					vc2.y         \n";
			//vertexCode += "mov           vf3.w      	 		 vt3.w					         		\n";
			
			vertexCode = frprogram.toBuild(vertexCode, toReplace);

			return vertexCode;
		}

		private function getGrowthAndFade():String
		{
			
			var vertexCode:String="";
			//vt4.xyz分别表示第一段，中间段，未段 是0，还是1.
			//vt3.xyz分别表示第一段，中间段，未段 的比值
			
			vertexCode += "sub           vt3.w      	 	 va1.y					vc7.y           		\n";//vt3.w未段与中间段的分隔帧数
			vertexCode += "slt           vt4.x      		 vt2.x					vc7.x           		\n";
			vertexCode += "sge           vt4.z      		 vt2.x					vt3.w           		\n";
			vertexCode += "max           vt4.y      		 vt4.x					vt4.z           		\n";
			vertexCode += "sub           vt4.y      	 	 {vcConst1}.z			vt4.y           		\n";
			
			vertexCode += "sub           vt4.w      	 	 va1.y					vt2.x           		\n";//<未段的未帧>与当前帧的差值
			vertexCode += "div           vt3.x      	 	 vt2.x					vc7.x           		\n";//第一段距0点的比什
			vertexCode += "div           vt3.z      	 	 vt4.w					vc7.y           		\n";//<未段的未帧>与当前帧的差值的比值
			
			vertexCode += "mov           vt3.y      	 	 {vcConst1}.z					           	\n";
			vertexCode += "dp3           vt1.w      	 	 vt3.xyz				vt4.xyz           	\n";
			vertexCode += "mul           vt1      	 	 va0					vt1.w           		\n";
			return vertexCode;
		}
		private function getFadeAndGrowth():String
		{
			
			var vertexCode:String="";
			//vt4.xz分别表示第一段，未段 是0，还是1.
			//vt3.xz分别表示第一段，未段 的比值
			
			vertexCode += "sub           vt3.w      	 	 va1.y					vc7.y           		\n";//vt3.w未段与中间段的分隔帧数
			vertexCode += "slt           vt4.x      		 vt2.x					vc7.x           		\n";
			vertexCode += "sge           vt4.z      		 vt2.x					vt3.w           		\n";
			
			vertexCode += "sub           vt4.y      	 	 vt2.x					vt3.w           		\n";//当前帧与<未段与中间段的分隔帧>的差值
			vertexCode += "div           vt3.x      	 	 vt2.x					vc7.x           		\n";//第一段距0点的比什
			vertexCode += "sub           vt3.x      	 	 {vcConst1}.z			vt3.x           		\n";
			vertexCode += "div           vt3.z      	 	 vt4.y					vc7.y           		\n";//当前帧与<未段与中间段的分隔帧>的差值的比值
			
			vertexCode += "mov           vt3.y      	 	 {vcConst1}.x					           	\n";
			vertexCode += "dp3           vt1.w      	 	 vt3.xyz				vt4.xyz           	\n";
			vertexCode += "mul           vt1      	 	 va0					vt1.w           		\n";
			return vertexCode;
		}
		private function getMultyEmmiterCodeLinear():String
		{
			var vertexCode:String="";
			if(particleParams.tailEnabled)
			{
				vertexCode += "mov           vt5      			 vc[va4.y]  		 	 			\n"; 
				vertexCode += "mul           vt4.z      	 		 vc1.x				vt5.x         \n";
				vertexCode += "mul           vt4.w      	 		 vt2.z				vt5.y         \n";
				vertexCode += "sub           vt4.z      	 		 vt4.z				vt4.w         \n";
				
			}
			else if(particleParams.distanceBirth)
			{
				vertexCode += "mov           vt5      			 vc[va4.y]  		 	 			\n"; 
				vertexCode += "mul           vt4.z      	 		 vt0.w				vt5.z         \n";
				vertexCode += "add           vt4.z      	 		 vt4.z				va4.x         \n";//算出第几个距离发射
				vertexCode += "mul           vt4.z      	 		 vt4.z				vt5.x         \n";
				vertexCode += "slt           vt4.x      		 	 vt4.z				{vcConst1}.z  \n";
				vertexCode += "min           vt2.y      		 	 vt4.x				vt2.y         \n";
			}
			else
			{
				vertexCode += "mov           vt5      			 vc[va4.y]  		 	 			\n"; 
				vertexCode += "mul           vt4.z      	 	 	 vc1.x				vt5.x     		\n";
			}
			
			vertexCode += "slt           vt4.x      		 vt4.z				{vcConst1}.z           	\n";
			vertexCode += "sge           vt4.y      		 vt4.z				{vcConst1}.x           	\n";
			vertexCode += "min           vt4.x      		 vt4.x				vt4.y           			\n"; 
			vertexCode += "min           vt2.y      		 vt4.x				vt2.y           			\n";
			
			//vertexCode += "sat           vt4.z      	 		 vt4.z						           	\n";
			if(particleParams.multyEmmiterLineType==ELineType.curveLine)
			{
				vertexCode += "mul           vt4.w      	 		 vt4.z				vt4.z           		\n";
				vertexCode += "sub           vt4.x      	 		 {vcConst1}.z		vt4.z           		\n";
				vertexCode += "mul           vt4.y      	 		 vt4.x				vt4.x           		\n";
				vertexCode += "mul           vt4.x      	 		 vt4.x				vt4.z           		\n";
				vertexCode += "mul           vt4.x      	 		 vt4.x				{vcConst1}.w         \n";
				
				vertexCode += "mul           vt5      	 		 vc[va4.y+1]			vt4.y           		\n";
				vertexCode += "mul           vt6      	 		 vc[va4.y+2]		vt4.x           		\n";
				vertexCode += "add           vt5      	 		 vt5				vt6           			\n";
				vertexCode += "mul           vt6      	 		 vc[va4.y+3]		vt4.w           		\n";
				vertexCode += "add           vt5      	 		 vt5				vt6           			\n";
				vertexCode += "add           vt3      	 		 vt3				vt5           			\n";
			}else if(particleParams.multyEmmiterLineType==ELineType.linear)
			{
				vertexCode += "mul           vt4.x      			 vt5.w  		 	vt4.z					\n"; 
				vertexCode += "mul           vt5      			 vt4.x  			vc[va4.y+2] 	 		\n"; 
				vertexCode += "add           vt5      	 		 vt5				vc[va4.y+1]           \n";
				vertexCode += "add           vt3      	 		 vt3				vt5           			\n";
				
			}
			return vertexCode;
		}
		/*public override function completeCode(frprogram:Program3dRegisterInstance):String
		{
			var v_globle:Vparam=frprogram.getParamByName(FilterName.V_GloblePos,true);
			var vertexCode:String="";
			if(v_globle)
			{
				vertexCode +="mov         {V_GloblePos}  {output}         					\n";
			}
			vertexCode += "m44         	 op      		{output}           {viewProj}	\n";
			return vertexCode;
		}*/

		public override function createFragmentUvCoord(frprogram:Program3dRegisterInstance):String
		{
			var framentCode:String = "";
			var uvCoord:FtParam = frprogram.getParamByName(FilterName.F_UVPostion, false);
			if (particleParams.uvStep && uvCoord)
			{
				var toReplace:Array = [];
				var uvStep:Vector3D = particleParams.uvStep;
				var uvSpeed:Number= isNaN(uvStep.z)?1:uvStep.z;
				var uvOffset:int=uvStep.w;
				toReplace.push(new ToBuilderInfo("fc0", "{UVdata}", false, 1, [1 / uvStep.x, 1 / uvStep.y, uvOffset, 1 / uvSpeed]));//uvStep.z播放速度
				
				var uvcoordFlag:String = uvCoord.paramName;

				framentCode += "sub           ft0.y				{V_ParticleLife}.y 	{fcConst1}.x  \n";
				framentCode += "kil           ft0.y														\n";
				framentCode += "mul           ft0.y        		{V_ParticleLife}.x  	fc0.w			\n";
				
				//帧偏移值
				framentCode += "mul           ft0.w        		{V_ParticleLife}.w  	fc0.z			\n";
				framentCode += "add           ft0.y        		ft0.w  					ft0.y			\n";
				
				//ft0.z算出最终是第几个格子
				framentCode += "frc           ft0.x        		ft0.y									\n";
				framentCode += "sub           ft0.z        		ft0.y  		  			ft0.x			\n";

				framentCode += "mul           ft0.z        		ft0.z  		  			fc0.x			\n";
				framentCode += "frc           ft0.x      		ft0.z				           		\n";
				framentCode += "sub           ft0.y        		ft0.z  		  			ft0.x			\n";
				framentCode += "mul           ft0.y        		ft0.y  		  			fc0.y			\n";


				framentCode += "mul           " + uvcoordFlag + ".xy        " + uvcoordFlag + ".xy      fc0.xy   \n";
				framentCode += "add           " + uvcoordFlag + ".xy        " + uvcoordFlag + ".xy      ft0.xy   \n";

				framentCode = frprogram.toBuild(framentCode, toReplace);
			}
			return framentCode;
		}

		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var framentCode:String = "";
			var toReplace:Array = [];

			if (particleParams.useColor || particleParams.useAlpha)
			{
				var texture:Texture3D=particleParams.dateaTexture
				toReplace.push(new ToBuilderInfo("fs0", "{dateaTexture}", false, 1, texture));
				var bmpH:int = ParticleParams.bitmapHeight;
				toReplace.push(new ToBuilderInfo("fc1", "{fconst0}", false, 1, [0, 0.8, 0, 0]));
				framentCode += "mov           ft0.x        		{V_ParticleLife}.z  		  									\n";
				if (particleParams.useColor)
				{
					framentCode += "mov           ft0.y        		fc1.x  		  												\n";
					framentCode += "tex           ft1           		ft0.xy    				"+getSmapleString("fs0",texture.format,false,texture.mipMode)+"	\n";
					framentCode += "mul           {output}.xyz      ft1  		  			{output}.xyz						\n";
				}
				if(particleParams.useAlpha)
				{
					framentCode += "mov           ft0.y        		fc1.y  		  												\n";
					framentCode += "tex           ft1           		ft0.xy    				"+getSmapleString("fs0",texture.format,false,texture.mipMode)+"	\n";
					framentCode += "mul           {output}      		ft1.x  		  			{output}							\n";
				}
			}
			
			//framentCode += "mov           {output}.xyz        		{V_ParticleLife}.w \n"
			framentCode = frprogram.toBuild(framentCode, toReplace);
			
			return framentCode;
		}
		public override function dispose():void
		{
			particleParams=null;
			super.dispose();
		}
	}
}
