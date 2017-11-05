package frEngine.loaders.ogreMeshSub
{

	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Label3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.materials.Material3D;
	import baseEngine.modifiers.Modifier;
	import baseEngine.system.Device3D;
	
	import frEngine.animateControler.FightObjectControler;
	import frEngine.animateControler.colorControler.AlphaControler;
	import frEngine.animateControler.colorControler.ColorControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.particleControler.ParticleAnimateControler;
	import frEngine.animateControler.transformControler.FaceObjectControler;
	import frEngine.animateControler.uvControler.FrUvStepControler;
	import frEngine.loaders.OgreMaterialListManager;
	import frEngine.loaders.ogreMaterialParse.Type_Material;
	import frEngine.render.layer.Layer3DManager;
	import frEngine.shader.filters.fragmentFilters.AlphaKillFilter;


	public class UserDataSerializer
	{
		private var _materialName:String;

		private var _folderUrl:String;

		private var parserInfo:ParserInfo;

		public static const blendDic:Dictionary = new Dictionary();

		private var _targetScene:Pivot3D;

		private var hasUvOffsetKeyFrameAnimate:Boolean = false;

		private var hasAlphaKeyFrameAnimate:Boolean = false;

		public static const instance:UserDataSerializer = new UserDataSerializer();

		public function UserDataSerializer()
		{

			blendDic["alpha1"] = Material3D.BLEND_ALPHA1;
			blendDic["add"] = Material3D.BLEND_ADDITIVE;
			blendDic["light"] = Material3D.BLEND_LIGHT;
			blendDic["none"] = Material3D.BLEND_NONE;
			blendDic["color"] = Material3D.BLEND_COLOR;
			blendDic["screen"] = Material3D.BLEND_SCREEN;

		}

		public function parser(mesh:Pivot3D, userDataXml:XML, materialName:String, $parseInfo:ParserInfo, folderUrl:String, targetScene:Pivot3D):void
		{
			hasUvOffsetKeyFrameAnimate = false;
			hasAlphaKeyFrameAnimate = false;
			_folderUrl = folderUrl;
			_targetScene = targetScene;
			parserInfo = $parseInfo;
			_materialName = materialName;
			var list:Array;

			if (parserInfo && parserInfo.childenInfo)
			{
				list = parserInfo.childenInfo.list;
				parserDataList(mesh, list);
			}
			if (userDataXml)
			{
				userDataXml = new XML(userDataXml.toString())
				var childList:XMLList = userDataXml.children()
				var len:int = childList.length();
				if (len == 0)
				{
					var str:String = userDataXml.toString();
					str = str.replace(/\r/g, "");
					str = str.replace(/\n/g, "|");
					list = str.split("|");
					if (mesh && mesh.name.search(/pcloud/i) != -1 && list.indexOf("node_ispcloud") == -1)
					{
						list.push("node_ispcloud=true");
					}
					parserDataList(mesh, list);
				}
				else
				{
					var type:String = userDataXml.name();
				}
			}

		}

		private function parserDataList(mesh:Pivot3D, list:Array):void
		{
			var len:int = list.length;

			for (var i:int = 0; i < len; i++)
			{
				var line:String = list[i];
				var arr:Array = line.split("=");
				var headStr:String = arr[0];
				var params:String = arr[1];
				var arr2:Array = headStr.split("_");

				var type0:String = arr2[0];
				var type1:String = arr2[1];
				var type2:String = arr2[2];
				switch (type0)
				{
					case "key":
						parserKey(mesh, type1, type2, params);
						break;
					case "material":
						parserMaterial(mesh, type1, type2, params);
						break;
					case "node":
						parserNode(mesh, type1, type2, params);
						break;
					case "particle":
						parserParticle(mesh, type1, type2, params);
						break;
					case "children":
						parsersubChildrenNode(headStr, params);
						break;
					case "action":
						parserAction(mesh, type1, type2, params);
						break;

				}
			}
			if (hasUvOffsetKeyFrameAnimate)
			{
				var vertexAnimate:Modifier = mesh.getAnimateControlerInstance(AnimateControlerType.UoffsetControler);
				vertexAnimate.setPlayLable("default");
			}
			if (hasAlphaKeyFrameAnimate)
			{
				var vertexAnimate2:ColorControler = mesh.getAnimateControlerInstance(AnimateControlerType.colorAnimateControler) as ColorControler;
				vertexAnimate2.setPlayLable("default");
			}
		}

		private function parserAction(mesh:Pivot3D, subType:String, type3:String, params:String):void
		{
			switch (subType)
			{
				case "fightObject":
					parserFightObject(mesh, type3, params);
					break;

			}
		}

		private function parserFightObject(mesh:Pivot3D, type3:String, params:String):void
		{
			var c:FightObjectControler = mesh.getAnimateControlerInstance(AnimateControlerType.FightObject) as FightObjectControler;
			switch (type3)
			{
				case "name":
					var targetFightObject:Pivot3D = _targetScene.getChildByName(params);
					break;
				case "moveSpeed":
					break;
			}






		}

		private function parserParticle(mesh:Pivot3D, subType:String, type3:String, params:String):void
		{
			var c:ParticleAnimateControler = mesh.getAnimateControlerInstance(AnimateControlerType.ParticleAnimateControler) as ParticleAnimateControler;
			switch (subType)
			{
				case "init":
					parserParticleInit(mesh, type3, params);
					break;
				case "stable":
					parserParticleStable(mesh, type3, params);
					break;
				case "final":
					parserParticleFinal(mesh, type3, params);
					break;
				case "material":
					parserParticleMaterial(mesh, type3, params, c);
					break;
				case "inertiaEnbled":
					//c.inertiaEnbled = params == "true" ? true : false;
					break;
				case "tailEnabled":
					//c.particleParams.tailEnabled = params == "true" ? true : false;
					break;
			}
		}

		private function parserParticleMaterial(mesh:Pivot3D, type3:String, params:String, c:ParticleAnimateControler):void
		{
			switch (type3)
			{
				case "uvStep":
					var arr:Array = params.split(",");
					//c.particleParams.uvStep = new Vector3D(Number(arr[0]), Number(arr[1]), 1);
					break;
				case "faceCamera":
					//c.particleParams.faceCamera = true;
					break;
			}
		}

		private function parserParticleFinal(mesh:Pivot3D, type3:String, params:String):void
		{
			var c:ParticleAnimateControler = mesh.getAnimateControlerInstance(AnimateControlerType.ParticleAnimateControler) as ParticleAnimateControler;
			switch (type3)
			{
				case "alpha":
					//c.finalAlpha = Number(params);
					break;
			}
		}

		private function parserParticleInit(mesh:Pivot3D, type3:String, params:String):void
		{
			var c:ParticleAnimateControler = mesh.getAnimateControlerInstance(AnimateControlerType.ParticleAnimateControler) as ParticleAnimateControler;
			switch (type3)
			{
				case "alpha":
					//c.initAlpha = Number(params);
					break;
				case "period":
					//c.initPeriod = Number(params);
					break;


			}
		}

		private function parserParticleStable(mesh:Pivot3D, type3:String, params:String):void
		{
			var c:ParticleAnimateControler = mesh.getAnimateControlerInstance(AnimateControlerType.ParticleAnimateControler) as ParticleAnimateControler;
			switch (type3)
			{
				case "alpha":
					//c.stableAlpha = Number(params);
					break;
				case "period":
					//c.stablePeriod = Number(params);
					break;

			}
		}

		private function parserNodeSeting(type:String, mesh:Pivot3D, params:String):void
		{

			var __mesh:Mesh3D = mesh as Mesh3D;
			if (!__mesh)
			{
				return;
			}
		/*var isTrue:Boolean = params == "true"
		if (type == "showShapeLine")
		{
			__mesh.showShapeLine = isTrue;
		}*/
		}

		private function parserNode(mesh:Pivot3D, subType:String, type3:String, params:String):void
		{
			switch (subType)
			{

				case "showShapeLine":
				case "pathTransform":
					parserNodeSeting(subType, mesh, params);
					break;
				case "exportAnimate":
					parserInfo.exportAnimate = (params == "true");
					break;
				case "faceCamera":
					parserNodeFaceCamera(mesh, params);
					break;
				case "faceObject":
					parserNodeObject(mesh, type3, params);
					break;
				case "layer":
					parserNodeLayer(mesh, type3, params);
					break;

			}
		}

		private function parserNodeLayer(mesh:Pivot3D, type3:String, params:String):void
		{
			if (type3 == "name")
			{
				mesh.setLayer(Layer3DManager.getLayerByName(params));
			}
			else if (type3 == "value")
			{
				mesh.setLayer(int(params));
			}
		}

		private function parserNodeObject(mesh:Pivot3D, type3:String, params:String):void
		{
			if (type3 == "name")
			{
				var faceObjectControler:FaceObjectControler = mesh.getAnimateControlerInstance(AnimateControlerType.NodeFaceObject) as FaceObjectControler;
				faceObjectControler.setFaceObject(_targetScene.getChildByName(params));
			}

		}

		private function parsersubChildrenNode(headFlag:String, params:String):void
		{
			if (!parserInfo.childenInfo)
			{
				parserInfo.createChildrenInfo();
			}
			var str:String = "children";
			var keyName:String = headFlag.substr(str.length + 1);
			parserInfo.childenInfo.addKey(keyName, params);

		}

		private function parserMaterial(mesh:Pivot3D, subType:String, type3:String, params:String):void
		{
			switch (subType)
			{
				case "doubleFace":
					parserDoubleFace(mesh, params);
					break;
				case "blendMode":
					parserBlendMode(mesh, params);
					break;
				case "writeZ":
					parserWriteZ(mesh, params);
					break;
				case "uvStep":
					parserNodeUvStep(mesh, params);
					break;
				case "alphaKill":
					parserAlphaKill(mesh, params);
					break;
			}
		}

		private function parserAlphaKill(mesh:Pivot3D, params:String):void
		{
			Mesh3D(mesh).materialPrams.addFilte(new AlphaKillFilter(Number(params)));
		}

		private function parserNodeUvStep(mesh:Pivot3D, params:String):void
		{
			var arr:Array = params.split(",");
			var uv:Point = new Point(arr[0], arr[1]);
			var timeStr:String = arr[2];
			var time:Number;
			if (timeStr.indexOf("f") != -1)
			{
				timeStr = timeStr.substr(0, timeStr.length - 1);
				time = Number(timeStr) / Device3D.animateSpeedFrame;
			}
			else
			{
				time = Number(timeStr);
			}
			var uvstepControler:FrUvStepControler = mesh.getAnimateControlerInstance(AnimateControlerType.UvStepControler) as FrUvStepControler;
			uvstepControler.init(uv, time);
		}

		private function parserNodeFaceCamera(mesh:Pivot3D, params:String):void
		{
			if (params == "true")
			{
				var faceObjectControler:FaceObjectControler = mesh.getAnimateControlerInstance(AnimateControlerType.NodeFaceObject) as FaceObjectControler;
				faceObjectControler.setFaceObject(Device3D.camera);
			}

		}

		private function parserWriteZ(mesh:Pivot3D, params:String):void
		{
			var writeBoolean:Boolean = params == "true" ? true : false;
			var typeMaterial:Type_Material = OgreMaterialListManager.instance.getTypeMaterial(_materialName, _folderUrl);
			Mesh3D(mesh).materialPrams.depthWrite = writeBoolean;
		}

		private function parserBlendMode(mesh:Pivot3D, params:String):void
		{
			var blendValue:String = params;
			var typeMaterial:Type_Material = OgreMaterialListManager.instance.getTypeMaterial(_materialName, _folderUrl);

			Mesh3D(mesh).setMateiralBlendMode(blendDic[blendValue]);

		}

		private function parserKey(mesh:Pivot3D, keyFlag:String, subType:String, params:String):void
		{
			var keyIndex:int = Number(keyFlag)
			switch (subType)
			{
				case "uv":
					parserUV(mesh, keyIndex, params);
					break;
				case "alpha":
					parserAlpha(mesh, keyIndex, params);
					break;
			}

		}





		private function parserAlpha(mesh:Pivot3D, keyIndex:int, params:String):void
		{
			var vertexAnimate:AlphaControler = mesh.getAnimateControlerInstance(AnimateControlerType.colorAnimateControler) as AlphaControler;
			var _alphaNum:Number = Number(params);

			vertexAnimate.editKeyFrame("#default#", keyIndex, null, _alphaNum,null);
			hasAlphaKeyFrameAnimate = true;
		}

		private function parserDoubleFace(mesh:Pivot3D, params:String):void
		{
			var doubleface:Boolean = params == "true" ? true : false;
			OgreMaterialListManager.instance.getTypeMaterial(_materialName, _folderUrl).setBothSides(Mesh3D(mesh), doubleface);
		}

		private function parserUV(mesh:Pivot3D, keyIndex:int, params:String):void
		{
			var vertexAnimate:Modifier = mesh.getAnimateControlerInstance(AnimateControlerType.UoffsetControler);
			var uvs:Array = params.split(",");
			var u:Number = Number(uvs[0]);
			var v:Number = Number(uvs[1]);
			var time:Number = keyIndex;
			var track:Label3D = vertexAnimate.getLabel("default");
			vertexAnimate.editKeyFrame(track, time, null, u,null);
			hasUvOffsetKeyFrameAnimate = true;
		}
	}
}
