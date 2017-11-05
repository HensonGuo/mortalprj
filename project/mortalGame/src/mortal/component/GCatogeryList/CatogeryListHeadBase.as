/**
 * 2014-2-14
 * @author chenriji
 **/
package mortal.component.GCatogeryList
{
	import com.mui.controls.GSprite;
	
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	
	public class CatogeryListHeadBase extends GSprite implements ICatogeryListHead
	{
		private var _dataProvider:DataProvider;
		private var _cellRender:Class;
		private var _index:int;
		private var _cellHeight:int;
		private var _isExpanding:Boolean;
		
		public function CatogeryListHeadBase()
		{
			super();
		}
		
		public function get isExpanding():Boolean
		{
			return _isExpanding;
		}

		public function set isExpanding(value:Boolean):void
		{
			_isExpanding = value;
		}

		public function get cellHeight():int
		{
			return _cellHeight;
		}

		public function set cellHeight(value:int):void
		{
			_cellHeight = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function get cellRender():Class
		{
			return _cellRender;
		}

		public function set cellRender(value:Class):void
		{
			_cellRender = value;
		}

		public function get dataProvider():DataProvider
		{
			return _dataProvider;
		}

		public function set dataProvider(value:DataProvider):void
		{
			_dataProvider = value;
		}
		
		public function expand():void
		{
			
		}
		
		public function unexpand():void
		{
			
		}
		
		public function updateData(obj:Object):void
		{
			
		}
		
		public override function setSize($width:Number, $height:Number):void
		{
			
		}
	}
}