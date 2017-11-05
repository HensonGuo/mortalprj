package frEngine.effectEditTool.manager
{
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ResourceInfo;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.modifiers.PlayMode;
	
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.core.mesh.NormalMesh3D;
	import frEngine.loaders.EngineConstName;
	import frEngine.loaders.away3dMd5.MD5AnimByteArrayParser;
	import frEngine.loaders.away3dMd5.MD5MeshByteArrayParser;
	import frEngine.loaders.away3dMd5.Skeleton;
	import frEngine.loaders.away3dMd5.SkeletonJoint;
	import frEngine.loaders.away3dMd5.md5Data.HeadJoins;
	import frEngine.loaders.away3dMd5.md5Data.HierarchyData;
	import frEngine.loaders.away3dMd5.md5Data.TrackInfo;

	public class MeshLoaderManager
	{
		public function MeshLoaderManager()
		{
			
		}
		
		public static function isMd5Mesh($meshUrl:String):Boolean
		{
			var str:String=$meshUrl.toUpperCase();
			if (str.indexOf(".MD5MESH")!=-1)
			{
				return true;
			}
			else
			{
				return false;
			}
			
		}
		
		public static function getMesh3dByUrl($meshUrl:String, $material:*, $boneUrl:String, $playLable:String,playModeIsCircle:Boolean, $renderList:RenderList):Mesh3D
		{
			var _isMd5Mesh:Boolean=isMd5Mesh($meshUrl);
			var _modle3d:Mesh3D;
			if (_isMd5Mesh)
			{
				var md5mesh:Md5Mesh = new Md5Mesh("",$meshUrl, false, $renderList);
				_modle3d = md5mesh;
				if ($material)
				{
					md5mesh.setMaterial($material, Texture3D.MIP_NONE,$material);//
				}
				if ($boneUrl)
				{
					md5mesh.initAnimate($boneUrl,$playLable);
				}
				
				md5mesh.targetMd5Controler.animationMode=playModeIsCircle?PlayMode.ANIMATION_LOOP_MODE:PlayMode.ANIMATION_STOP_MODE;
			}
			else 
			{
				_modle3d = new NormalMesh3D("",$meshUrl, false, $renderList);
				if($material)
				{
					_modle3d.setMaterial($material,Texture3D.MIP_NONE,$material);
				}
				
			}
			return _modle3d;
		}
		
		
		public static function getBonesTree(meshUrl:String):SkeletonJoint
		{
			if (meshUrl == null || meshUrl==EngineConstName.defaultNullStringFlag)
			{
				return null;
			}
			var bytes1:ByteArray = getFileBytes2(meshUrl);
			var skeleton:Skeleton = MD5MeshByteArrayParser.parseHeadAndJoints(bytes1,-1);
			if (!skeleton)
			{
				return null;
			}
			return skeleton.joinRoot;
		}
		
		public static function checkMeshAndBoneIsMatch(meshUrl:String, boneUrl:String):Vector.<TrackInfo>
		{
			if (!meshUrl || meshUrl.length == 0 || meshUrl==EngineConstName.defaultNullStringFlag
				|| !boneUrl || boneUrl.length == 0 || boneUrl==EngineConstName.defaultNullStringFlag)
			{
				return null;
			}
			var bytes1:ByteArray = getFileBytes2(meshUrl);
			var bytes2:ByteArray = getFileBytes2(boneUrl);
			if(!bytes1 || !bytes2)
			{
				return null;
			}
			var skeleton:Skeleton = MD5MeshByteArrayParser.parseHeadAndJoints(bytes1,-1);
			if (!skeleton)
			{
				return null;
			}
			var animJoins:HeadJoins = MD5AnimByteArrayParser.parseHeadAndJoints(bytes2);
			if (!animJoins)
			{
				return null;
			}
			var meshJoins:Vector.<SkeletonJoint> = skeleton.inherits;
			var animJoinsList:Vector.<HierarchyData> = animJoins.joinsList;
			
			var len:int = Math.min(meshJoins.length,animJoinsList.length);
			for (var i:int = 0; i < len; i++)
			{
				if (meshJoins[i].name != animJoinsList[i].name)
				{
					return null;
				}
			}
			
			return animJoins.tracksList;
		}
		
		public static function getFileBytes2($url:String):ByteArray
		{
			var info:ResourceInfo = ResourceManager.getInfoByName($url);
			if(!info)
			{
				return null;
			}
			var fileClass:Class=getDefinitionByName("flash.filesystem.File") as Class
			var file:Object = new fileClass(info.soPath);
			var fileStreamClass:Class=getDefinitionByName("flash.filesystem.FileStream") as Class;
			var filestream:Object = new fileStreamClass();
			filestream.open(file, "read");
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			filestream.readBytes(bytes);
			return bytes;
		}
	}
}