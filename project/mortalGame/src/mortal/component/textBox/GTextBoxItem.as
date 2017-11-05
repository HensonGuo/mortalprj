package mortal.component.textBox
{
	import Message.Db.Tables.TIllustrateCollect;
	
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.text.TextFormat;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.View;
	
	public class GTextBoxItem extends View
	{
		private var _data:*;
		private var _textfield:GTextFiled;
		private var _itemWidth:int;
		
		public function GTextBoxItem(width:int,height:int)
		{
			super();
			mouseChildren = false;
			useHandCursor = true;
			buttonMode = true;
			init(width,height);
		}
		
		public function set data(value:*):void
		{
			_data = value;
			if(value is TIllustrateCollect)
			{
				_textfield.text = (value as TIllustrateCollect).name;
			}
			else
			{
				if(value.name)
				{
					_textfield.text = value.name;
				}
			}
		}
		
		public function get data():*
		{
			return _data;
		}
		
		private function init(width:int,height:int):void
		{
			_itemWidth = width;
			UIFactory.bg(0,0,width,2,this,ImagesConst.SplitLine);
			_textfield = UIFactory.gTextField("",0,8,width,20,this);
		}
		
		public function set textformat(textformat:TextFormat):void
		{
			_textfield.setTextFormat(textformat);
		}
		
		private var _beSelected_skin:ScaleBitmap;
		public function addSelectedSkin():void
		{
			if(_beSelected_skin==null)
			{
				_beSelected_skin = GlobalClass.getScaleBitmap(ImagesConst.FightingStrgBg);
				_beSelected_skin.width = _itemWidth;
				_beSelected_skin.height = 23;
				_beSelected_skin.x = 0;
				_beSelected_skin.y = 6;
			}
			addChildAt(_beSelected_skin,0);
		}
		
		public function removeSelectedSkin():void
		{
			if(_beSelected_skin!=null && _beSelected_skin.parent)
			{
				removeChild(_beSelected_skin);
			}
		}
		
	}
}