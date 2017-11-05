package mortal.game.scene3D.display3d.shadow
{
	import baseEngine.core.Pivot3D;

	public class Shadow3D extends Pivot3D
	{
		private var _targetVector:Vector.<Number>;
		private var _ix:int;
		private var _iy:int;
		private var _iz:int;
		private var _iw:int;
		private var _isShowing:Boolean=false;

		public function Shadow3D()
		{
			super("",false);
			
		}

		public function reInit(targetVector:Vector.<Number>):void
		{
			_targetVector=targetVector;
			_ix=targetVector.length;
			_iy=_ix+1;
			_iz=_ix+2;
			_iw=_ix+3;
			_targetVector[_ix]=this.globleX;
			_targetVector[_iy]=this.globleY;
			_targetVector[_iz]=this.globleZ;
			_targetVector[_iw]=1;
			_isShowing=true;
			if(_targetVector.length>400)
			{
				throw new Error("超出范围");
			}
		}
		
		public function show():void
		{
			_targetVector[_iw]=1;
			_isShowing=true;
		}
		public function hide():void
		{
			_targetVector[_iw]=-1;
			_isShowing=false;
		}

		public override function updateChildrenTransform():void
		{
			_targetVector[_ix]=this.globleX;
			_targetVector[_iy]=this.globleY;
			_targetVector[_iz]=this.globleZ;
		}
		
		public override  function updateTransforms(updateLocle:Boolean , updateChildren:Boolean):void
		{
			
			_targetVector[_ix]=this.globleX;
			_targetVector[_iy]=this.globleY;
			_targetVector[_iz]=this.globleZ;
		}
		
	}
}