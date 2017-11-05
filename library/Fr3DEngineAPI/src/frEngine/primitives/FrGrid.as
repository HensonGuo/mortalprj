package frEngine.primitives
{
	
	import baseEngine.basic.RenderList;
	
	import frEngine.primitives.base.LineBase;
	
	public class FrGrid extends LineBase 
	{
		public function FrGrid(_width:Number, _segment:int,$renderList:RenderList)
		{
			super("grid",false,$renderList);
			this.configure(_width, _segment);
		}
		
		public function configure(_arg1:Number, _arg2:int):void
		{
			drawInstance.clear();
			drawInstance.lineStyle(1, 0x757575,1,0);
			var _local3:int = -(_arg1);
			while (_local3 <= _arg1)
			{
				if (_local3 != 0)
				{
					drawInstance.moveTo(_local3, 0, -(_arg1),0);
					drawInstance.lineTo(_local3, 0, _arg1,0);
					drawInstance.moveTo(-(_arg1), 0, _local3,0);
					drawInstance.lineTo(_arg1, 0, _local3,0);
				};
				_local3 = (_local3 + _arg2);
			};
			drawInstance.lineStyle(1, 0x404040,1,1);
			drawInstance.moveTo(0, 0, -(_arg1),1);
			drawInstance.lineTo(0, 0, _arg1,1);
			drawInstance.moveTo(-(_arg1), 0, 0,1);
			drawInstance.lineTo(_arg1, 0, 0,1);
		}
		
	}
}

