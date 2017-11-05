package frEngine.core.mesh
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.loaders.resource.info.MeshInfo;
	import frEngine.shader.ShaderBase;
	
	public class NormalMesh3D extends Mesh3D
	{
		protected var _meshUrl:String;
		private var _useAlpha:Boolean;
		public function NormalMesh3D(meshName:String,$meshUrl:String, useColorAnimate:Boolean, $renderList:RenderList)
		{
			super(meshName, useColorAnimate, $renderList);
			if($meshUrl)
			{
				meshUrl=$meshUrl;
			}
		}
		public function set meshUrl(value:String):void
		{
			if(_meshUrl && _meshUrl!=value)
			{
				Resource3dManager.instance.unLoad(_meshUrl,parseHasLoadedBytes);
			}
			_meshUrl=value;
			if(value)
			{
				Resource3dManager.instance.load(value,parseHasLoadedBytes,loadPriority);
			}
			
		}
		protected override function setShaderBase(materaial:ShaderBase):void
		{
			super.setShaderBase(materaial);
			setUseAlpha();
		}
		
		private function setUseAlpha():void
		{
			if(this.material.vertexFilter.useAlpha!=_useAlpha)
			{
				this.material.vertexFilter.useAlpha=_useAlpha;
				this.material.toReBuiderProgram=true;
			}
			
		}
		private function parseHasLoadedBytes(info:MeshInfo):void
		{
			
			this.addSurface(info.surface3d);
			_useAlpha=info.useAlpha;
			if(!this.material)
			{
				this.setMaterial(Device3D.nullBitmapData,Texture3D.MIP_NONE,"nullBitmapData");
			}else
			{
				setUseAlpha();
			}
			this.dispatchEvent(new Event(Engine3dEventName.PARSEFINISH));
		}
		
		public override function dispose(isReuse:Boolean=true):void
		{
			Resource3dManager.instance.unLoad(_meshUrl,parseHasLoadedBytes);
			super.dispose(isReuse);
			_meshUrl=null;
		}
		/*public override function draw(_arg1:Boolean=true, _arg2:ShaderBase=null):void
		{
			super.draw(_arg1,_arg2);
		}*/
		private function getMatrix(_arg1:Array):Matrix3D
		{
			var v1:Vector3D=new Vector3D(_arg1[0], _arg1[2], 	_arg1[1], 0);
			var v2:Vector3D=new Vector3D(_arg1[3], _arg1[5],	_arg1[4], 0)
			var v3:Vector3D=new Vector3D(_arg1[6], _arg1[8], 	_arg1[7], 0)
			var v4:Vector3D=new Vector3D(_arg1[9], _arg1[11], 	_arg1[10],1)
			
			var _local2:Matrix3D = new Matrix3D();
			_local2.copyColumnFrom(0, v1);
			_local2.copyColumnFrom(2, v2);
			_local2.copyColumnFrom(1, v3);
			_local2.copyColumnFrom(3, v4);
			
			return (_local2);
		}
	}
}