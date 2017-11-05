package frEngine.shader
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Surface3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.core.BufferVo;
	import frEngine.core.FrSurface3D;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	import frEngine.shader.filters.vertexFilters.VertexFilter;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	import frEngine.shader.registType.FcParam;
	import frEngine.shader.registType.FsParam;
	import frEngine.shader.registType.MaxtrixParam;
	import frEngine.shader.registType.VaParam;
	import frEngine.shader.registType.VcParam;
	import frEngine.shader.registType.Vparam;
	import frEngine.shader.registType.base.ConstParamBase;


	public class ShaderBase extends Material3D
	{
		public var program:FrProgram3D;
		public var isBatchMaterial:Boolean=false;
		public var ignoreStates:Boolean=false;
		public var colorMask:Vector.<Number>;
		public var scissor:Rectangle;
		public var vertexConstants:Vector.<Number>=new Vector.<Number>();
		public var fragmentConstants:Vector.<Number>=new Vector.<Number>();
		
		private var _materialParams:MaterialParams;
		
		private var _vertexFilter:VertexFilter;
		private var _fragmentFilter:FragmentFilter;
		
		public var toReBuiderProgram:Boolean=true;
		private static const defaultEmptyArray:Array=[];

		public function ShaderBase($name:String,$vertexFilter:VertexFilter,$fragmentFilter:FragmentFilter,$materialParams:MaterialParams)
		{
			super($name);
			
			setVertexFilter($vertexFilter);
			setFragmentFilter($fragmentFilter);
			
			this.materialParams=$materialParams;
		}
		
		public function set materialParams(value:MaterialParams):void
		{
			if(_materialParams)
			{
				_materialParams.removeEventListener(Engine3dEventName.FILTER_CHANGE,filterChangeHander);
			}
			_materialParams=value;
			if(value)
			{
				_materialParams.addEventListener(Engine3dEventName.FILTER_CHANGE,filterChangeHander);
			}
		}
		private function filterChangeHander(e:Event):void
		{
			toReBuiderProgram=true;
		}
		public function get materialParams():MaterialParams
		{
			return _materialParams;
		}
		public function setVertexFilter(value:VertexFilter):void
		{
			if(_vertexFilter==value)
			{
				return;
			}
			_vertexFilter=value;
			toReBuiderProgram=true;
		}
		public function get vertexFilter():VertexFilter
		{
			return _vertexFilter;
		}
		public function get vertexFilterType():int
		{
			if(_vertexFilter)
			{
				return _vertexFilter.type;
			}
			return -1;
		}
		
		public function setFragmentFilter(value:FragmentFilter):void
		{
			/*if(_fragmentFilter && setingParams)
			{
				this.cullFace=_fragmentFilter.cullFace;
				this.depthWrite=_fragmentFilter.enableDepthWrite;
				this.depthCompare=_fragmentFilter.depthCompare;
				this.destFactor=_fragmentFilter.destBlend;
				this.sourceFactor=_fragmentFilter.srcBlend;
			}*/
			
			if(_fragmentFilter!=value)
			{
				_fragmentFilter=value;
				toReBuiderProgram=true;
			}
			
		}
		public function get fragmentFilter():FragmentFilter
		{
			return _fragmentFilter;
		}

		public function getParam(paramName:String,isVertex:Boolean):*
		{
			if(program)
			{
				return program.getParamByName(paramName,isVertex);
			}
			return null;
		}
		protected override function context3DEvent(e:Event=null):void
		{
			if(!_scene )return;
			if(toReBuiderProgram)
			{
				toReBuiderProgram=!this.buildBytes();
				
			}
			if(toReBuiderProgram)
			{
				return;
			}

			var texturesList:Vector.<FsParam>=program.textures
			var len:int=texturesList.length;
			for(var i:int=0;i<len;i++)
			{
				var sample:FsParam=texturesList[i];
				sample.upload(_scene);
			};
			_scene.removeEventListener(Event.CONTEXT3D_CREATE, this.context3DEvent);
			
		}

		public override function clone():Material3D
		{
			
			//var drawingParams:ShaderDrawingParams=new ShaderDrawingParams(this.cullFace,this.depthCompare,this.depthWrite,this.sourceFactor,this.destFactor);
			var newMaterial3D:ShaderBase=new ShaderBase(this.name+"_clone",VertexFilter(vertexFilter.clone()),FragmentFilter(fragmentFilter.clone()),this._materialParams);
			return newMaterial3D;
		}
		public override function upload($scene:Scene3D):void
		{
			if (!($scene))
			{
				throw (new Error("Parameter scene can not be null."));
			};
			if (!this._scene)
			{
				this.scene = $scene;
				_scene.addEventListener(Event.CONTEXT3D_CREATE, this.context3DEvent, false, 0, true);
			};
			if (_scene.context)
			{ 
				this.context3DEvent();
			};
		}
		[inline]
		final public function hasPrepared(pivot:Pivot3D, surf:Surface3D):Boolean
		{
			var hasPrepared:Boolean=true;
			if(toReBuiderProgram)
			{
				upload(Device3D.scene);
				hasPrepared = (!toReBuiderProgram && program && program.instanceRegister.hasAssembler);
			}else
			{
				if(program && program.instanceRegister.hasAssembler==false)
				{
					program.instanceRegister.assemblerGoOn();
					hasPrepared=program.instanceRegister.hasAssembler
				}
			}

			if (!surf.hasUpload)
			{
				surf.upload(_scene);
			}
			
			return hasPrepared;
		}
		public function drawLeftNums(pivot:Pivot3D,surf:Surface3D):void
		{
			
		}
		
		public static var pro:Program3D;
		public static var cullFace:String;
		public static var depthWrite:Boolean;
		public static var depthCompare:String;
		public static var sourceFactor:String;
		public static var destFactor:String;
		public static var textures:Array=new Array(8);;
		public static var buffers:Array=new Array(8);

		override public function draw(pivot:Pivot3D, surf:Surface3D, depthCompare:String ,cullFace:String,depthWrite:Boolean,sourceFactor:String,destFactor:String,firstIndex:int=0, count:int=-1):void
		{ 
			if(!program)
			{
				return;
			}
			var frSurface:FrSurface3D=FrSurface3D(surf);
			var context:Context3D = _scene.context;
			var i:int,len:int
			i = 0;
			var texturesList:Vector.<FsParam>=program.textures;
			len = texturesList.length;
			var _texture:Array=ShaderBase.textures;
			while (i < len)
			{
				var _sample:FsParam=texturesList[i];
				if(!_sample.value || !_sample.value.texture)
				{
					_sample.upload(_scene);
					return;
				}
				var index:int=_sample.index;
				if(_texture[index]!=_sample.value.texture)
				{
					context.setTextureAt(index, _sample.value.texture);
					_texture[index]=_sample.value.texture
				}
				
				i++;
			};
			while (i < Device3D.usedSamples)
			{
				context.setTextureAt(i, null);
				_texture[i]=null;
				i++;
			};

			Device3D.usedSamples = len;
			
			if(ShaderBase.pro!=program.program)
			{
				context.setProgram(program.program);
				ShaderBase.pro=program.program;
			}
			

			/*if (ignoreStates==false)
			{
				if (colorMask)
				{
					context.setColorMask(colorMask[0], colorMask[1], colorMask[2], colorMask[3]);
				};
				if (scissor)
				{
					context.setScissorRectangle(scissor);
				};
				context.setCulling(cullFace);
				context.setDepthTest(depthWrite, depthCompare);
				context.setBlendFactors(sourceFactor, destFactor);
			}else
			{
				if (colorMask)
				{
					context.setColorMask(colorMask[0], colorMask[1], colorMask[2], colorMask[3]);
				};
			}*/
			if(ShaderBase.cullFace !=cullFace)
			{
				context.setCulling(cullFace);
				ShaderBase.cullFace =cullFace;
			}
			
			if(ShaderBase.depthWrite!=depthWrite || ShaderBase.depthCompare!=depthCompare)
			{
				context.setDepthTest(depthWrite, depthCompare);
				ShaderBase.depthWrite=depthWrite;
				ShaderBase.depthCompare=depthCompare;
			}
			
			if(ShaderBase.sourceFactor!=sourceFactor || ShaderBase.destFactor!=destFactor)
			{
				context.setBlendFactors(sourceFactor, destFactor);
				ShaderBase.sourceFactor=sourceFactor;
				ShaderBase.destFactor=destFactor;
			}
			
			
			i = 0;
			var vertextsList:Vector.<VaParam>=program.VaParamsList
			len = vertextsList.length;
			var _buffers:Array=ShaderBase.buffers;
			while (i < len)
			{
				var vertext:VaParam = vertextsList[i];
				var bufferNameId:uint=vertext.vertexNameId;
				var bufferIndex:int=vertext.index;
				var vo:BufferVo=frSurface.bufferVoMap[bufferNameId]
				if(!vo)
				{
					return;
				}
				var vertexBuffer3d:VertexBuffer3D=vo.buffer.vertexBuffer
				if(_buffers[bufferIndex]!=vertexBuffer3d)
				{
					context.setVertexBufferAt(bufferIndex, vertexBuffer3d, vo.offset,vo.format);
					_buffers[bufferIndex]=vertexBuffer3d;
				}
				
				i++;
			};
			while (i < Device3D.usedBuffers)
			{
				context.setVertexBufferAt(i, null);
				_buffers[i]=null;
				i++;
			}
			
			Device3D.usedBuffers = len;
			
			var m:MaxtrixParam
			var param:ConstParamBase;
			var len2:uint;
			var paramList:Vector.<VcParam>=program.VcParamsConstList
			len = paramList.length;
			var type:String=Context3DProgramType.VERTEX;
			i = 0;
			var paramValue:Vector.<Number>;
			while (i < len)
			{
				param = paramList[i];
				paramValue=param.value;
				len2=(paramValue.length/4)>>0; 
				context.setProgramConstantsFromVector(type, param.index, paramValue,len2);
				i++
			}
			
			paramList=null;
			var paramList2:Vector.<FcParam>=program.FcParamsConstList
			len = paramList2.length;
			type=Context3DProgramType.FRAGMENT;
			i = 0;
			while (i < len)
			{
				param = paramList2[i];
				paramValue=param.value;
				len2=(paramValue.length/4)>>0;
				context.setProgramConstantsFromVector(type, param.index, paramValue,len2);
				i++
			}

			var matrix:Vector.<MaxtrixParam>=program.paramsMaxtrixList;
			i = 0;
			len = matrix.length;
			while (i < len)
			{
				m = matrix[i];
				context.setProgramConstantsFromMatrix(m.type, m.index, m.value, true);
				i++;
			};
			
			context.drawTriangles(frSurface.indexBufferFr.indexBuffer, firstIndex, count);
			Device3D.drawCalls3d++;
			if (colorMask)
			{
				context.setColorMask(true, true, true, true);
			};
			
		}

		public override function dispose():void
		{
			materialParams && materialParams.dispose();
			if(vertexFilter)
			{
				vertexFilter.dispose();
			}
			if(fragmentFilter)
			{
				fragmentFilter.dispose();
			}
			
			setVertexFilter(null);
			setFragmentFilter(null);

			materialParams=null;
			program && program.dispose()
			program=null;
			toReBuiderProgram=true;
		}
		protected function buildBytes():Boolean
		{

			if (!(_scene) || !_vertexFilter || !_fragmentFilter)
			{
				return false;
			};
			
			if(program)
			{
				program.dispose();
				program=null;
			}
			var _filterList:Array;
			var repeat:Boolean=true;
			var len:int,i:int;
			var filter:FilterBase;
			if(_materialParams){
				_filterList=_materialParams.filterList;
				len=_filterList.length;
				_filterList.sortOn("priority",Array.NUMERIC);
				repeat=materialParams.uvRepeat;
			}else
			{
				_filterList=defaultEmptyArray;
				len=0;
			}
			
			var pArray:Array=[vertexFilter.programeId,fragmentFilter.programeId];
			for(i=0;i<len;i++)
			{
				filter=_filterList[i];
				pArray.push(filter.programeId);
			}
			
			var _programeId:String=pArray.join(",");

			var hasRegister:Boolean=Resource3dManager.instance.hasRegisterProgram3D(_programeId,repeat);
			var _program3DInstance:Program3dRegisterInstance;
			if(!hasRegister)
			{
				_program3DInstance=createAndRegister(_programeId,vertexFilter,fragmentFilter,_filterList,repeat);
				program=new FrProgram3D(repeat,_programeId,_program3DInstance);
			}else
			{
				_program3DInstance = Resource3dManager.instance.getProgram3DInstance(_programeId,repeat);
				program =new FrProgram3D(repeat,_programeId,_program3DInstance);
				setRegisterParams(_program3DInstance,_filterList);
			}

			this.dispatchEvent(new Event(Engine3dEventName.MATERIAL_REBUILDER));
			return true;

		}
		private function setRegisterParams(program3DInstance:Program3dRegisterInstance,_filterList:Array):void
		{
			vertexFilter.setRegisterParams(program3DInstance);
			fragmentFilter.setRegisterParams(program3DInstance);
			var i:int=0,len:int=_filterList.length;
			var filter:FilterBase;
			for(i=0;i<len;i++)
			{
				filter=_filterList[i];
				filter.setRegisterParams(program3DInstance);
			}
		}
		private static function createAndRegister(_pid:String,vertexFilter:VertexFilter,fragmentFilter:FragmentFilter,_filterList:Array,repeat:Boolean):Program3dRegisterInstance
		{
			
			var _program3DInstance:Program3dRegisterInstance=new Program3dRegisterInstance(_pid);
			var vertexCode:String="";
			var fragmentCode:String="";
			
			vertexCode=vertexFilter.createVertexCode(_program3DInstance);
			vertexCode+=fragmentFilter.createVertexCode(_program3DInstance);
			var i:int=0,len:int=_filterList.length;
			var filter:FilterBase;
			for(i=0;i<len;i++)
			{
				filter=_filterList[i];
				vertexCode+=filter.createVertexCode(_program3DInstance);
			}

			vertexCode+=completeCode(_program3DInstance);
			
			fragmentCode=fragmentFilter.createFragmentUvCoord(_program3DInstance);
			fragmentCode+=vertexFilter.createFragmentUvCoord(_program3DInstance);
			
			for(i=0;i<len;i++)
			{
				filter=_filterList[i];
				fragmentCode+=filter.createFragmentUvCoord(_program3DInstance);
			}
			
			fragmentCode+=fragmentFilter.createFragmentColor(_program3DInstance,repeat);
			fragmentCode+=vertexFilter.createFragmentColor(_program3DInstance,repeat);
			
			for(i=0;i<len;i++)
			{
				filter=_filterList[i];
				fragmentCode+=filter.createFragmentColor(_program3DInstance,repeat);
			}
			
			_program3DInstance.upload(Device3D.scene,vertexCode,fragmentCode);
			
			Resource3dManager.instance.registerPrograme(_program3DInstance,repeat);
				
			return _program3DInstance;
			
		}
		private static function completeCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[ ]
			var vertexCode:String="";
			var v_globle:Vparam=frprogram.getParamByName(FilterName.V_GloblePos,true);
			var v_Screen:Vparam=frprogram.getParamByName(FilterName.V_Screen,true);
			var OpType:int=frprogram.OpType;
			if(OpType==ECalculateOpType.None)
			{

			}
			else if(OpType==ECalculateOpType.Proj)
			{
				if(v_globle)
				{
					vertexCode +="mov         {V_GloblePos}     {output}         			\n";
				}
				toReplace.push(new ToBuilderInfo("vm1",FilterName.proj,true,4));
				vertexCode +="m44         	 {output}     {output}           vm1			\n";
			}
			else if(OpType==ECalculateOpType.ViewProj)
			{
				if(v_globle)
				{
					vertexCode +="mov         {V_GloblePos}     {output}         				\n";
				}
				
				vertexCode +="m44         	 {output}     {output}           {viewProj}		\n";
			}
			else if(OpType==ECalculateOpType.WorldViewProj)
			{
				if(v_globle)
				{
					vertexCode +="mov         {V_GloblePos}     {output}         					\n";
				}
				toReplace.push(new ToBuilderInfo("vm1",FilterName.worldViewProj,true,4));
				vertexCode +="m44         	 {output}     {output}            vm1			\n";
			}
			else if(OpType==ECalculateOpType.World_And_ViewProj)
			{
				toReplace.push(new ToBuilderInfo("vm1",FilterName.global,true,4));
				vertexCode +="m44         	 {output}      		{output}           vm1			\n";
				if(v_globle)
				{
					vertexCode +="mov         {V_GloblePos}     {output}         					\n";
				}
				
				vertexCode +="m44         	 {output}     {output}            {viewProj}		\n";
			}
			
			if(v_Screen)
			{
				vertexCode +="div         	 {V_Screen} 	{output}       {output}.w    		\n";
			}
			

			vertexCode +="mov         	 op      		{output}           						\n";
			 
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			
			return vertexCode;
		}
	}
}