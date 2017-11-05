package frEngine.effectEditTool.lineRoad
{

	import baseEngine.basic.RenderList;
	import baseEngine.core.Pivot3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	
	import frEngine.primitives.FrCube;
	import frEngine.primitives.FrLine3D;
	import frEngine.primitives.FrSphere;

	public class LineCirle extends Pivot3D
	{
		private var _pos:FrCube;
		private var _inCircle:FrSphere;
		private var _outCircle:FrSphere;
		private var _inLine:FrLine3D;
		private var _outLine:FrLine3D;
		public function LineCirle( material:Material3D)
		{
			var renderList:RenderList=Device3D.scene.renderLayerList;
			super("");

			_pos=new FrCube("",renderList,5,5,5,1,material);
			
			
			_inCircle=new FrSphere("",renderList,3,18);
			_inCircle.setMaterial(0x00ff00,0,"green");
			
			_outCircle=new FrSphere("",renderList,3,18);
			_outCircle.setMaterial(0x0000ff,0,"blue");
			
			this.addChild(_pos);
			this.addChild(_inCircle);
			this.addChild(_outCircle);
			
			_inLine=new FrLine3D("",renderList);
			_outLine=new FrLine3D("",renderList);
			
			this.addChild(_inLine);
			this.addChild(_outLine);
			
		}

		public function initParent($parent:Pivot3D,$pos:Object,$in:Object,$out:Object):void
		{
			this.parent=$parent;
			_pos.setPosition($pos.x,$pos.y,$pos.z);
			if($in)
			{
				_inCircle.setPosition($in.x,$in.y,$in.z);
				_inCircle.isHide=_inLine.isHide=false;
				_inLine.clear();
				_inLine.lineStyle(1,0xff0000);
				_inLine.moveTo($pos.x,$pos.y,$pos.z);
				_inLine.lineTo($in.x,$in.y,$in.z);
			}else
			{
				_inCircle.isHide=_inLine.isHide=true;
			}
			
			if($out)
			{
				_outCircle.setPosition($out.x,$out.y,$out.z);
				_outCircle.isHide=_outLine.isHide=false;
				_outLine.clear();
				_outLine.lineStyle(1,0xff0000);
				_outLine.moveTo($pos.x,$pos.y,$pos.z);
				_outLine.lineTo($out.x,$out.y,$out.z);
			}else
			{
				_outCircle.isHide=_outLine.isHide=true;
			}
			
		}
		public function clear():void
		{
			this.parent=null;
		}
	}
}