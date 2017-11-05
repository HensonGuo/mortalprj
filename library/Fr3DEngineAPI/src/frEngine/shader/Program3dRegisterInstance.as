package frEngine.shader
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.Dictionary;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.system.Device3D;
	
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	import frEngine.shader.registType.FcParam;
	import frEngine.shader.registType.FsParam;
	import frEngine.shader.registType.FtParam;
	import frEngine.shader.registType.MaxtrixParam;
	import frEngine.shader.registType.VaParam;
	import frEngine.shader.registType.VcParam;
	import frEngine.shader.registType.Vparam;
	import frEngine.shader.registType.VtParam;
	import frEngine.shader.registType.base.RegistParam;

	public class Program3dRegisterInstance
	{
		private var VHasUseNum:int=0;
		private var VCHasUseNum_Vertex:int=0;
		private var VCHasUseNum_Fragment:int=0;
		private var VAHasUseNum:int=0;
		private var VtHasUseNum:int=0;
		private var FtHasUseNum:int=0;
		private var FsHasUseNum:int=0;
		public var program:Program3D;
		public var VparamList:Dictionary=new Dictionary(false);
		public var FparamList:Dictionary=new Dictionary(false);
		public var VcParamsConstList:Vector.<VcParam>=new Vector.<VcParam>;
		public var FcParamsConstList:Vector.<FcParam>=new Vector.<FcParam>;
		public var VaParamsList:Vector.<VaParam>=new Vector.<VaParam>;
		public var paramsMaxtrixList:Vector.<MaxtrixParam>=new Vector.<MaxtrixParam>;
		public var textures:Vector.<FsParam>=new Vector.<FsParam>;
		public var OpType:int=ECalculateOpType.World_And_ViewProj;
		private var vertexBytesAssembler:AGALMiniAssembler=new AGALMiniAssembler(false);
		private var fragmentBytesAssembler:AGALMiniAssembler=new AGALMiniAssembler(false);
		private var _programeId:String;
		public var hasAssembler:Boolean=false;
		public function Program3dRegisterInstance($programeId:String)
		{
			_programeId=$programeId;
		}
		
		
		public function get programeId():String
		{
			return _programeId;
		}
		public function dispose():void
		{
			VparamList=null;
			FparamList=null;
			VaParamsList=null;
			VcParamsConstList=null;
			FcParamsConstList=null;
			paramsMaxtrixList=null;
			textures=null;
		}
		public function upload($scene:Scene3D,vertexCode:String,fragmentCode:String):void
		{
			program = $scene.context.createProgram();
			toBuidResult(vertexCode,fragmentCode);
		}
		public function toBuild(code:String,flag:Array):String
		{
			var len:int=flag.length;
			var registIndex:int;
			var reg:RegExp;
			var paramObject:*;
			for(var i:int=0;i<len;i++)
			{
				var info:ToBuilderInfo=flag[i];
				registParam(info);
				reg=new RegExp(info.oldVarName,"gi");
				code=code.replace(reg,info.paramName);
			}
			return code;
			
		}
		public function getParamByName($name:String,isVertex:Boolean):*
		{
			if($name.indexOf("{")!=0 || $name.indexOf("}")!=$name.length-1)
			{
				throw new Error("名称不合法，请加上{}");
				return;
			}
			if(isVertex)
			{
				return 	VparamList[$name];
			}else
			{
				return 	FparamList[$name];
			}
			
		}

		
		
		private function toBuidResult(vertexCode:String,fragmentCode:String):void
		{
			var reg:RegExp;
			var tempVtNum:int=0;
			var tempFtNum:int=0;
			var registIndexOPparam:Object=getParamByName("{output}",true);
			var registIndexOCparam:Object=getParamByName("{output}",false);
			var registIndexOP:String=registIndexOPparam?registIndexOPparam.registName:"vt"+getFreeVt(1);
			var registIndexOC:String=registIndexOCparam?registIndexOCparam.registName:"ft"+getFreeFt(1);
			for(var i:int=0;i<8;i++)
			{
				var flag:String="vt"+i;
				if(vertexCode.indexOf(flag)!=-1)
				{
					reg=new RegExp(flag,"gi");
					vertexCode=vertexCode.replace(reg,"#"+(VtHasUseNum+tempVtNum));
					tempVtNum++;
				}
				
			}
			vertexCode=vertexCode.replace(/#/gi,"vt");
			
			for(i=0;i<8;i++)
			{
				var flag2:String="ft"+i;
				if(fragmentCode.indexOf(flag2)!=-1)
				{
					reg=new RegExp(flag2,"gi");
					fragmentCode=fragmentCode.replace(reg,"#"+(FtHasUseNum+tempFtNum));
					tempFtNum++;
				}
				
			}
			fragmentCode=fragmentCode.replace(/#/gi,"ft");
			
			if(VtHasUseNum+tempVtNum>8 || FtHasUseNum+tempFtNum>8)
			{
				throw new Error("临时变量个数大于8<FrProgram3D.as>");
			}

			fragmentCode=fragmentCode+"mov           oc,{output}\n";
			
			reg=/\{output\}/gi;
			vertexCode=vertexCode.replace(reg,registIndexOP);
			fragmentCode=fragmentCode.replace(reg,registIndexOC);
			
			for(var p:String in VparamList)
			{
				reg=new RegExp(p,"gi");
				vertexCode=vertexCode.replace(reg,VparamList[p].registName);
			}
			for(p in FparamList)
			{
				reg=new RegExp(p,"gi");
				fragmentCode=fragmentCode.replace(reg,FparamList[p].registName);
			}

			vertexCode=Device3D.replaceVertexCode(vertexCode);
			
			fragmentCode=Device3D.replaceFragmentCode(fragmentCode);

			
			vertexBytesAssembler.assemble(Context3DProgramType.VERTEX,vertexCode);
			fragmentBytesAssembler.assemble(Context3DProgramType.FRAGMENT,fragmentCode);
			
			if(vertexBytesAssembler.hasFinish && fragmentBytesAssembler.hasFinish)
			{
				assemblerFinish();
			}
		}
		public function assemblerGoOn():void
		{
			!vertexBytesAssembler.hasFinish && vertexBytesAssembler.goOn();
			!fragmentBytesAssembler.hasFinish && fragmentBytesAssembler.goOn();
			if(vertexBytesAssembler.hasFinish && fragmentBytesAssembler.hasFinish)
			{
				assemblerFinish();
			}
		}
		private function assemblerFinish():void
		{
			/*trace("**************************************\nvertexCode:");
			trace(vertexBytesAssembler.source);
			trace("\nfragmentCode:");
			trace(fragmentBytesAssembler.source);*/
			try
			{
				program.upload(vertexBytesAssembler.agalcode,fragmentBytesAssembler.agalcode);
				
			}catch(e:Error)
			{
				trace("**************************************\nvertexCode:");
				trace(vertexBytesAssembler.source);
				trace("\nfragmentCode:");
				trace(fragmentBytesAssembler.source);
				throw e;
			}
			hasAssembler=true;
		}
		public function getFreeV(num:int):int
		{
			var old:int=VHasUseNum;
			VHasUseNum+=num;
			return old;
		}
		public function getFreeVc(num:int):int
		{
			var old:int=VCHasUseNum_Vertex;
			VCHasUseNum_Vertex+=num;
			return old;
		}
		public function getFreeFc(num:int):int
		{
			var old:int=VCHasUseNum_Fragment;
			VCHasUseNum_Fragment+=num;
			return old;
		}
		public function getFreeVt(num:int):int
		{
			var old:int=VtHasUseNum;
			VtHasUseNum+=num;
			return old;
		}
		public function getFreeFs(num:int):int
		{
			var old:int=FsHasUseNum;
			FsHasUseNum+=num;
			return old;
		}
		public function getFreeFt(num:int):int
		{
			var old:int=FtHasUseNum;
			FtHasUseNum+=num;
			return old;
		}
		public function getFreeVA(num:int):int
		{
			var old:int=VAHasUseNum;
			VAHasUseNum+=num;
			return old;
		}
		public function registParam(info:ToBuilderInfo):void
		{
			var infoName:String=info.paramName;
			if(getParamByName(infoName,info.isVertex))
			{
				return;
			}
			var registIndex:int;
			var paramObject:RegistParam;
			var isVertex:Boolean=info.isVertex;

			switch(info.type)
			{
				case "va": registIndex=getFreeVA(1);
					paramObject=new VaParam(registIndex,"float"+info.varNum,infoName);
					break;
				case "vc": registIndex=getFreeVc(info.varNum);
					
					paramObject=new VcParam(registIndex,infoName,info.isGlobleVar,info.defaultValue);	
					break;
				case "fc": registIndex=getFreeFc(info.varNum);
					paramObject=new FcParam(registIndex,infoName,info.isGlobleVar,info.defaultValue);	
					break;
				case "fm": 
				case "vm": 
					var t_type:String;
					if(isVertex)
					{
						registIndex=getFreeVc(4);
						t_type=Context3DProgramType.VERTEX;
					}else
					{
						registIndex=getFreeFc(4);
						t_type=Context3DProgramType.FRAGMENT;
					}
					paramObject=new MaxtrixParam(t_type,registIndex,infoName,info.isGlobleVar,info.defaultValue);
					break;
				case "v":	registIndex=getFreeV(1);
					paramObject=new Vparam(infoName,registIndex);
					registParamName(infoName,paramObject,false,"v");
					break;
				case "vt": registIndex=getFreeVt(info.varNum);
					paramObject=new VtParam(infoName,registIndex);
					break;
				case "ft": registIndex=getFreeFt(info.varNum);
					paramObject=new FtParam(infoName,registIndex);
					break;
				case "fs": registIndex=getFreeFs(info.varNum);
					paramObject=new FsParam(registIndex,infoName,info.defaultValue);
					break;
				
			}
			registParamName(infoName,paramObject,isVertex,info.type);
			
		}
		public function cloneFrom(target:Program3dRegisterInstance):void
		{
			this.program=target.program;
			this._programeId=target._programeId;
			this.OpType=target.OpType;
			copyVcParams(target.VcParamsConstList);
			copyFcParams(target.FcParamsConstList);
			copyMaxtrixList(target.paramsMaxtrixList);
			copyTextureList(target.textures);
			copyVaList(target.VaParamsList);
			this.vertexBytesAssembler=target.vertexBytesAssembler;
			this.fragmentBytesAssembler=target.fragmentBytesAssembler;
			this.hasAssembler=target.hasAssembler;
			this.VHasUseNum=target.VHasUseNum;
			this.VCHasUseNum_Vertex=target.VCHasUseNum_Vertex;
			this.VCHasUseNum_Fragment=target.VCHasUseNum_Fragment;
			this.VAHasUseNum=target.VAHasUseNum;
			this.VtHasUseNum=target.VtHasUseNum;
			this.FtHasUseNum=target.FtHasUseNum;
			this.FsHasUseNum=target.FsHasUseNum;
		}

		private function copyVaList(from:Vector.<VaParam>):void
		{
			var len:int=from.length;
			var _newVector:Vector.<VaParam>=this.VaParamsList;
			for(var i:int=0;i<len;i++)
			{
				var _va:VaParam=from[i].clone();
				_newVector.push(_va);
				this.VparamList[_va.paramName]=_va;
			}
		}
		
		private function copyTextureList(from:Vector.<FsParam>):void
		{
			var len:int=from.length;
			var _newFsList:Vector.<FsParam>=this.textures;
			for(var i:int=0;i<len;i++)
			{
				var _fs:FsParam=from[i].clone();
				_newFsList.push(_fs);
				this.FparamList[_fs.paramName]=_fs;
			}
		}
		private function copyMaxtrixList(from:Vector.<MaxtrixParam>):void
		{
			var len:int=from.length;
			var _newList:Vector.<MaxtrixParam>=this.paramsMaxtrixList;
			for(var i:int=0;i<len;i++)
			{
				var _maxtrix:MaxtrixParam=from[i].clone();
				_newList.push(_maxtrix);
				if(_maxtrix.type==Context3DProgramType.FRAGMENT)
				{
					this.FparamList[_maxtrix.paramName]=_maxtrix;
				}else
				{
					this.VparamList[_maxtrix.paramName]=_maxtrix;
				}
				
			}
		}
		
		private function copyFcParams(from:Vector.<FcParam>):void
		{
			var len:int=from.length;
			var _newList:Vector.<FcParam>=this.FcParamsConstList;
			for(var i:int=0;i<len;i++)
			{
				var _fc:FcParam=from[i].clone();
				_newList.push(_fc);
				this.FparamList[_fc.paramName]=_fc;
			}
		}
		private function copyVcParams(from:Vector.<VcParam>):void
		{
			var len:int=from.length;
			var _newList:Vector.<VcParam>=this.VcParamsConstList;
			for(var i:int=0;i<len;i++)
			{
				var _vc:VcParam=from[i].clone();
				_newList.push(_vc);
				this.VparamList[_vc.paramName]=_vc;
			}
		}
		


		private function registParamName($name:String,param:RegistParam,isVertex:Boolean,registerType:String):void		
		{
			if(isVertex)
			{
				if(VparamList[$name])
				{
					throw new Error("已注册顶点寄存器名称："+$name);
				}
				VparamList[$name]=param;
			}else
			{
				if(FparamList[$name])
				{
					throw new Error("已注册片段寄存器名称："+$name);
				}
				FparamList[$name]=param;
			}
			switch(registerType)
			{
				case "va": VaParamsList.push(param);				break;
				case "vc": VcParamsConstList.push(param);			break;
				case "fc": FcParamsConstList.push(param);			break;
				case "fm": 
				case "vm": paramsMaxtrixList.push(param);			break;
				case "fs": textures.push(param);					break;
			}
			
		}
	}
}