package mortal.game.scene3D.map3D
{
	
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ImageInfo;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.core.BufferVo;
	import frEngine.core.FrSurface3D;
	import frEngine.primitives.FrQuad;
	import frEngine.shader.FrProgram3D;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.registType.FcParam;
	import frEngine.shader.registType.FsParam;
	import frEngine.shader.registType.MaxtrixParam;
	import frEngine.shader.registType.VaParam;
	import frEngine.shader.registType.VcParam;
	import frEngine.shader.registType.base.ConstParamBase;
	
	import mortal.game.Game;
	import mortal.game.scene3D.layer3D.BottomMapLayer;
	import mortal.game.scene3D.map3D.mapShader.MapFragmentFilter;
	import mortal.game.scene3D.map3D.mapShader.MapVertexFilter;
	
	public class MapBitmap3DRender
	{
		private static var  _instance:MapBitmap3DRender
		private var _brickMat0:ShaderBase;
		private var _brickMat1:ShaderBase;
		private var _brickMat2:ShaderBase;
		private var _textureRegister:FsParam;
		private var _vmConst0Register:MaxtrixParam;
		private var _materialParams:MaterialParams;
		private var _bgOffsetRegister:FcParam;
		private var _bgMapWidth:Number=2000;
		private var _bgMapHeight:Number=2000;
		private var _emptyTexture:Texture3D;
		private var _transform:Matrix3D=new Matrix3D();
		private var _tempVector3d:Vector3D=new Vector3D(0,0,0,1);
		private var cullFace:String=Context3DTriangleFace.NONE;
		private var depthWrite:Boolean=false;
		private var sourceFactor:String=Context3DBlendFactor.ONE
		private var destFactor:String=Context3DBlendFactor.ZERO
		private var depthCompare:String=Context3DCompareMode.ALWAYS;
		
		public function MapBitmap3DRender()
		{
			_emptyTexture=new Texture3D(new BitmapData(1,1,true,0x0),0);
			_emptyTexture.upload(Device3D.scene,false);
			
			_materialParams=new MaterialParams();
			_materialParams.uvRepeat=false;
			
			/*_brickMat0=new ShaderBase("_brickMat0",new MapVertexFilter(),new MapFragmentFilter(new Texture3D(null,0,Texture3D.FORMAT_COMPRESSED_ALPHA)),_materialParams);
			_brickMat0.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander0);
			_brickMat0.upload(Device3D.scene);
			
			_brickMat1=new ShaderBase("_brickMat1",new MapVertexFilter(),new MapFragmentFilter(new Texture3D(null,0,Texture3D.FORMAT_COMPRESSED_ALPHA)),_materialParams);
			_brickMat1.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander1);
			_brickMat1.upload(Device3D.scene);*/
			
			
			
			_brickMat2=new ShaderBase("_brickMat2",new MapVertexFilter(),new MapFragmentFilter(BottomMapLayer.instance.texture),_materialParams);
			_brickMat2.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander2);
			_brickMat2.upload(Device3D.scene);
		}
		public static function get instance():MapBitmap3DRender
		{
			if(!_instance)
			{
				_instance=new MapBitmap3DRender();
			}
			return _instance;
		}
		
		public function resetBgMapInfo():void
		{
			if(Game.mapInfo)
			{
				_bgMapWidth=Game.mapInfo.bgMapWidth;
				_bgMapHeight=Game.mapInfo.bgMapHeight;
				var _scalex:Number=MapConst.pieceWidth/_bgMapWidth;
				var _scaley:Number=MapConst.pieceHeight/_bgMapHeight;
				if(_bgOffsetRegister)
				{
					_bgOffsetRegister.value[2]=_scalex
					_bgOffsetRegister.value[3]=_scaley;
				}
				BottomMapLayer.instance.setMapWH(_bgMapWidth,_bgMapHeight);
			}
			
		}
		private function reBuildHander0(e:Event):void
		{
			_textureRegister=_brickMat0.getParam("{texture1}",false);
			_bgOffsetRegister=_brickMat0.getParam("{F_const}",false);
			_vmConst0Register=_brickMat0.getParam("{transform}",true);
			
			resetBgMapInfo();
			this._brickMat0.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander0);
		}
		private function reBuildHander1(e:Event):void
		{
			_textureRegister=_brickMat1.getParam("{texture1}",false);
			_bgOffsetRegister=_brickMat1.getParam("{F_const}",false);
			_vmConst0Register=_brickMat1.getParam("{transform}",true);
			resetBgMapInfo();
			this._brickMat1.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander1);
		}
		private function reBuildHander2(e:Event):void
		{
			_textureRegister=_brickMat2.getParam("{texture1}",false);
			_bgOffsetRegister=_brickMat2.getParam("{F_const}",false);
			_vmConst0Register=_brickMat2.getParam("{transform}",true);
			resetBgMapInfo();
			this._brickMat2.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander2);
		}
		public function draw(map3dList:Vector.<MapBitmap3D>,offsetX:Number,offsetY:Number):void
		{
			var surf:FrSurface3D=FrQuad.surf;
			var len:int=map3dList.length;
			if(len==0)
			{
				return;
			}
			var mapBitmap3D:MapBitmap3D = map3dList[0];
			var targetMaterial:ShaderBase;
			/*if(!mapBitmap3D || !mapBitmap3D.cellTexture)
			{
				return;
			}
			
			if(mapBitmap3D.cellTexture.format==Texture3D.FORMAT_COMPRESSED)
			{
				targetRegister=_textureRegister0;
				targetMaterial=_brickMat0;
			}else if(mapBitmap3D.cellTexture.format==Texture3D.FORMAT_COMPRESSED_ALPHA)
			{
				targetRegister=_textureRegister1;
				targetMaterial=_brickMat1;
			}else
			{
				targetRegister=_textureRegister2;
				targetMaterial=_brickMat2;
			}*/
			targetMaterial=_brickMat2;
			
			if(!_textureRegister)
			{
				Device3D.drawCalls2d=0;
				return;
			}
			
			var bgOffx:Number=-SceneRange.displayInt.x + SceneRange.bitmapFarXY.x + SceneRange.bitmapSelfMoveX;
			var bgOffy:Number=-SceneRange.displayInt.y + SceneRange.bitmapFarXY.y;
			
			if(!targetMaterial.hasPrepared(null,surf))
			{
				return;
			}
			drawImp(surf,targetMaterial.program);
			var context:Context3D = Device3D.scene.context;

			var viewPortW:Number=Device3D.viewPortW;
			var viewPortH:Number=Device3D.viewPortH;
			var _W:Number = 256 / viewPortW;
			var _H:Number = 256 / viewPortH;
			_transform.identity();
			_transform.appendScale(_W, _H, 1);
			
			for(var i:int=0;i<len;i++)
			{
				mapBitmap3D = map3dList[i]

				if(mapBitmap3D.cellTexture)
				{ 
					_textureRegister.value=mapBitmap3D.cellTexture;
				}else
				{
					_textureRegister.value=_emptyTexture
				}
				
				if(_textureRegister.value.texture==null)
				{
					_textureRegister.upload(Device3D.scene,true);
				}
				
				
				context.setTextureAt(_textureRegister.index, _textureRegister.value.texture);
				
				var paramValue:Vector.<Number>=_bgOffsetRegister.value;
				
				paramValue[0]=(bgOffx+mapBitmap3D.x)/_bgMapWidth;
				paramValue[1]=(bgOffy+mapBitmap3D.y)/_bgMapHeight;
				
				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, _bgOffsetRegister.index, paramValue,1);

				_tempVector3d.x = -1 + _W + (offsetX+mapBitmap3D.x) / viewPortW * 2;
				_tempVector3d.y = 1 - _H - (offsetY+mapBitmap3D.y) / viewPortH * 2;

				_transform.copyColumnFrom(3,_tempVector3d);
				
				context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, _vmConst0Register.index, _transform,true);

				context.drawTriangles(surf.indexBufferFr.indexBuffer, 0, -1);

				Device3D.drawCalls2d++;	
				
			}
			
		}
		
		public function drawImp(frSurface:FrSurface3D, program:FrProgram3D):void
		{ 
			if(!program)
			{
				return;
			}
			var context:Context3D = Device3D.scene.context;
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
					_sample.upload(Device3D.scene,false);
				}
				var index:int=_sample.index;
				context.setTextureAt(index, _sample.value.texture);
				_texture[index]=_sample.value.texture
				i++;
			};

			Device3D.usedSamples = len;

			context.setProgram(program.program);
			ShaderBase.pro=program.program;
		
		
		
			context.setCulling(cullFace);
			ShaderBase.cullFace =cullFace;
		
		
		
			context.setDepthTest(depthWrite, depthCompare);
			ShaderBase.depthWrite=depthWrite;
			ShaderBase.depthCompare=depthCompare;
		
		
		
			context.setBlendFactors(sourceFactor, destFactor);
			ShaderBase.sourceFactor=sourceFactor;
			ShaderBase.destFactor=destFactor;

			i = 0;
			var vertextsList:Vector.<VaParam>=program.VaParamsList
			len = vertextsList.length;
			var _buffers:Array=ShaderBase.buffers;
			while (i < len)
			{
				var vertext:VaParam = vertextsList[i];
				var bufferNameId:uint=vertext.vertexNameId;
				var bufferIndex:int=vertext.index
				var vo:BufferVo=frSurface.bufferVoMap[bufferNameId]
				var vertexBuffer3d:VertexBuffer3D=vo.buffer.vertexBuffer;
				context.setVertexBufferAt(bufferIndex, vertexBuffer3d, vo.offset,vo.format);
				_buffers[bufferIndex]=vertexBuffer3d;

				i++;
			};
			
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
				if(paramValue)
				{
					len2=(paramValue.length/4)>>0; 
					context.setProgramConstantsFromVector(type, param.index, paramValue,len2);
				}
				
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
				if(paramValue)
				{
					len2=(paramValue.length/4)>>0;
					context.setProgramConstantsFromVector(type, param.index, paramValue,len2);
				}
				
				i++
			}
			
			var matrix:Vector.<MaxtrixParam>=program.paramsMaxtrixList;
			i = 0;
			len = matrix.length;
			while (i < len)
			{
				m = matrix[i];
				if(m.value)
				{
					context.setProgramConstantsFromMatrix(m.type, m.index, m.value, true);
				}
				i++;
			};

		}
		
	}
}