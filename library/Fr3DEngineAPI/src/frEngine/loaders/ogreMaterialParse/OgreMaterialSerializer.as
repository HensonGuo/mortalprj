package frEngine.loaders.ogreMaterialParse
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	
	import frEngine.event.ParamsEvent;
	import frEngine.loaders.OgreMaterialListManager;
	import frEngine.loaders.base.LoaderList;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.math.StringUtils;
	import frEngine.shader.ShaderBase;


	public class OgreMaterialSerializer
	{
		private var _Linelist:Array;
		private var _totalLines:int;
		private var materialList:Dictionary=new Dictionary(false);
		private var batchMaterialList:Dictionary=new Dictionary(false);
		private var _loaderList:LoaderList=new LoaderList();
		private var _folderUrl:String="";
		public function OgreMaterialSerializer()
		{
			_loaderList.addEventListener("ItemLoaded",itemLoaded);
		}
		private function itemLoaded(e:ParamsEvent):void
		{
			var bytes:ByteArray=e.params[0];
			var str:String=bytes.readMultiByte(bytes.length,"gb2312");
			parseData(str);
		}
		public function addMaterialFile(fileName:String):void
		{
			_loaderList.addFile(fileName,null);
			_folderUrl=StringUtils.getFolderUrl(fileName);
		}
		private function parseData(data:String):void
		{      	
			data=data.replace(/\t|    |\r/g,"");
			_Linelist=data.split(/\n/);
			_totalLines=_Linelist.length;
			for(var i:int=0;i<_totalLines;i++)
			{
				var line:String=_Linelist[i];
				var arr:Array=line.split(" ");
				var flag:String=arr[0];
				if(flag=="material")
				{
					var materialObject:Type_Material=get_Type_material(arr[1]);
					if(!materialObject.hasParse)
					{
						i=parserMaterial(i,materialObject);
						materialObject.hasParse=true;
					}
					
				}else if(flag=="BatchMaterial")
				{
					var batchMaterialObject:Type_BatchMaterial=get_Type_BatchMaterial(arr[1]);
					if(!batchMaterialObject.hasParse)
					{
						i=parserMaterial(i,batchMaterialObject);
						batchMaterialObject.hasParse=true;
					}
					
				}
			}
			_Linelist=null;
		}
		public function getMaterial(mesh:Mesh3D,materialName:String):ShaderBase
		{
			var material:ShaderBase;
			material=get_Type_material(materialName).getMaterial(mesh);
			return material;
		}

		public function get_Type_BatchMaterial(materialName:String):Type_BatchMaterial
		{
			var type_material:Type_BatchMaterial=batchMaterialList[materialName]
			if(!type_material)
			{
				type_material=batchMaterialList[materialName]=new Type_BatchMaterial(materialName,this._folderUrl);
			}
			return type_material;
		}
		public function get_Type_material(materialName:String):Type_Material
		{
			var type_material:Type_Material=materialList[materialName]
			if(!type_material)
			{
				type_material=materialList[materialName]=new Type_Material(materialName,this._folderUrl);
			}
			return type_material;
		}
		private function parserMaterial(startIndex:int,materialObject:Type_Material):int
		{
			for(var i:int=startIndex+1;i<_totalLines;i++)
			{
				var line:String=_Linelist[i];

				var arr:Array=line.split(" ");
				var flag:String=arr[0];
				if(flag=="technique")
				{
					var tecchniqueObjct:Type_Technique=new Type_Technique(arr[1]);
					i=parseTechnique(i,tecchniqueObjct);
					materialObject.technique=tecchniqueObjct;
				}else if(flag=="batchInfo")
				{
					var batchInfo:BatchInfo=new BatchInfo(materialObject.name);
					i=parseBatchInfo(i,batchInfo);
					materialObject.batchInfo=batchInfo;
				}else if(line=="}")
				{
					return i;
				}
			}
			return _totalLines;
		}
		private function parseBatchInfo(startIndex:int,batchInfo:BatchInfo):int
		{
			for(var i:int=startIndex+1;i<_totalLines;i++)
			{
				var line:String=_Linelist[i];
				var arr:Array=line.split(" ");
				var flag:String=arr[0];
				if(flag=="w")
				{
					batchInfo.imgW=Number(arr[1]);
				}else if(flag=="h")
				{
					batchInfo.imgH=Number(arr[1]);
				}else if(flag=="batchId")
				{
					var batchMaterialId:String=arr[1];
					batchInfo.targetBatchMaterial=OgreMaterialListManager.instance.getTypeBatchMaterial(batchMaterialId,this._folderUrl);
				}else if(flag=="centerX")
				{
					batchInfo.centerX=Number(arr[1]);
				}else if(flag=="centerY")
				{
					batchInfo.centerY=Number(arr[1]);
				}else if(flag=="useBatch")
				{
					batchInfo.useBatch=arr[1]=="true"?true:false;;
				}else if(flag=="batchType")
				{
					batchInfo.batchType=arr[1];
				}else if(line=="}")
				{
					return i;
				}
			}
			return _totalLines;
		}
		private function parseTechnique(startIndex:int,tecchniqueObjct:Type_Technique):int
		{
			for(var i:int=startIndex+1;i<_totalLines;i++)
			{
				var line:String=_Linelist[i];
				var arr:Array=line.split(" ");
				var flag:String=arr[0];
				if(flag=="pass")
				{
					var passObject:Type_Pass=new Type_Pass(arr[1]);
					i=parsePass(i,passObject);
					tecchniqueObjct.pass=passObject;
				}else if(line=="}")
				{
					return i;
				}
			}
			return _totalLines;
		}
		private function parsePass(startIndex:int,passObject:Type_Pass):int
		{
			for(var i:int=startIndex+1;i<_totalLines;i++)
			{
				var line:String=_Linelist[i];
				var arr:Array=line.split(" ");
				var flag:String=arr[0];
				if(flag=="ambient")
				{
					if(arr[4]==null)
					{
						arr[4]=1;
					}
					passObject.ambient=new Vector3D(arr[1],arr[2],arr[3],arr[4]);
				}
				else if(flag=="diffuse")
				{
					if(arr[4]==null)
					{
						arr[4]=1;
					}
					passObject.diffuse=new Vector3D(arr[1],arr[2],arr[3],arr[4]);
				}
				else if(flag=="specular")
				{
					if(arr[4]==null)
					{
						arr[4]=1;
					}
					passObject.specular=new Vector3D(arr[1],arr[2],arr[3],arr[4])
				}
				else if(flag=="texture_unit")
				{
					var texture_unit_obj:Type_Texture_unit=new Type_Texture_unit(arr[1]);
					i=parseTexture_unit(i,texture_unit_obj);
					passObject.texture_unit=texture_unit_obj;
				}
				else if(flag=="}")
				{
					return i;
				}
			}
			return _totalLines;
		}
		private function parseTexture_unit(startIndex:int,texture_unit_obj:Type_Texture_unit):int
		{
			for(var i:int=startIndex+1;i<_totalLines;i++)
			{
				var line:String=_Linelist[i];
				var arr:Array=line.split(" ");
				var flag:String=arr[0];
				if(flag=="texture")
				{
					if(line.indexOf("\"")!=-1)
					{
						arr=line.split("\"");
					}
					arr.shift();
					var jpgurl:String=arr.join(" ");
					texture_unit_obj.texture=Resource3dManager.instance.getTexture3d(jpgurl,1);
				}else if(flag=="linear")
				{
					texture_unit_obj.linear=arr[1]=="true"?true:false;
				}else if(flag=="miplinear")
				{
					texture_unit_obj.miplinear=arr[1]=="true"?true:false;
				}else if(flag=="repeat")
				{
					texture_unit_obj.repeat=arr[1]=="true"?true:false; 
				}else if(flag=="}")
				{
					return i;
				}
			}
			return _totalLines;
		}
	}
}
