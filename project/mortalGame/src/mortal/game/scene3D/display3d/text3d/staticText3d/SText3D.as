package mortal.game.scene3D.display3d.text3d.staticText3d
{
	import mortal.game.scene3D.display3d.text3d.Stext3DPlace;
	import mortal.game.scene3D.display3d.text3d.Text3DPlace;

	public class SText3D
	{
		private var _targetVector:Vector.<Number>;
		
		private var _ix2:int;
		private var _iy2:int;
		private var _iz2:int;
		private var _iw2:int;
		
		public var place:Stext3DPlace;
		
		public var textValue:String;
		private var _offsetX:int;
		private var _width:uint=0;
		private var _height:uint=0;
		private var _uvOffsetX:Number=0;
		private var _uvOffsetY:Number=0;
		private var _parentPlace:Stext3DPlace;
		public function SText3D($textValue:String)
		{
			textValue = $textValue;	
		}

		public function reInitPlace($place:Stext3DPlace,$parentPlace:Stext3DPlace):void
		{

			place=$place;
			_parentPlace=$parentPlace;
			_targetVector = place.targetVector.list;
			
			_ix2= place.placeId*4
			_iy2= _ix2+1;
			_iz2= _ix2+2;
			_iw2= _ix2+3;
			
			_targetVector[_ix2] = _uvOffsetY;
			_targetVector[_iy2] = _uvOffsetX;
			_targetVector[_iz2] = _parentPlace.placeId*1000+_width;
			_targetVector[_iw2] = _offsetX*1000+_height;

		}
		public function clear():void
		{
			if(place)
			{
				place.targetVector.clearSplace(place);
				_targetVector[_iw2] = -1000;
			}
			
		}

		/**
		 * 
		 * @param $scaleValue
		 * @param index
		 * @param hangShu:第几行
		 * @param lieShu:第几列
		 * 
		 */		
		public function setImgInfo($width:uint,$height:uint,$offsetX:int,$uvOffsetX:Number,$uvOffsetY:Number):void
		{
			_width=$width;
			_height=$height;
			_uvOffsetX=$uvOffsetX;
			_uvOffsetY=$uvOffsetY;
			_offsetX=$offsetX;
			_targetVector[_ix2] = _uvOffsetY;
			_targetVector[_iy2] = _uvOffsetX;
			_targetVector[_iz2] = _parentPlace.placeId*1000+_width;
			_targetVector[_iw2] = _offsetX*1000+_height;

		}

		


	}
}
