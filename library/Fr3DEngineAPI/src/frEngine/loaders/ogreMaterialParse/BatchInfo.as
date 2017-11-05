package frEngine.loaders.ogreMaterialParse
{

	public class BatchInfo
	{
		public var imgW:int;
		public var imgH:int;
		public var centerX:int;
		public var centerY:int;
		public var useBatch:Boolean;
		public var scaleX:Number;
		public var sclaeY:Number;
		public var offX:Number;
		public var offY:Number;
		private var  _targetBatchMaterial:Type_BatchMaterial;
		public var batchType:String;
		private var ownerMaterilaName:String;
		public function BatchInfo($ownerMaterialName:String)
		{
			ownerMaterilaName=$ownerMaterialName;
		}
		public function set targetBatchMaterial(value:Type_BatchMaterial):void
		{
			_targetBatchMaterial=value;
			_targetBatchMaterial.registSubMaterial(ownerMaterilaName,imgW,imgH,centerX,centerY)
		}
		public function get targetBatchMaterial():Type_BatchMaterial
		{
			return _targetBatchMaterial;
		}
	}
}