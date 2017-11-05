/**
 * @heartspeak
 * 2014-2-26 
 */   	

package mortal.game.view.pet.view
{
	import Message.DB.Tables.TPetConfig;
	import Message.Game.SPet;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GImageBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.ITabBar2Cell;
	import com.mui.core.GlobalClass;
	
	import flash.events.MouseEvent;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.tableConfig.PetConfig;
	import mortal.game.utils.PetUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.NoSkinCellRenderer;
	import mortal.mvc.core.Dispatcher;
	
	public class PetListCellRenderer extends GSprite implements ITabBar2Cell
	{
		private var _selected:Boolean = false;
		private var _isResCompl:Boolean = false;
		private var _bg:GBitmap;
		private var _txtName:GTextFiled;
		private var _txtPetType:GTextFiled;
		private var _txtCombat:GTextFiled;
		private var _petHead:GImageBitmap;
		
		private var _pet:SPet;
		
		public function PetListCellRenderer()
		{
			super();
			this.mouseEnabled = true;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bg = UIFactory.bitmap("",0,0,this);
			_txtName = UIFactory.gTextField("",66,10,92,20,this,GlobalStyle.textFormatItemOrange);
			_txtPetType = UIFactory.gTextField("",66,30,92,20,this,GlobalStyle.textFormatPutong);
			_txtCombat = UIFactory.gTextField("",66,50,92,20,this,GlobalStyle.textFormatPutong);
			_petHead = UIFactory.gImageBitmap("",9,10,this);
			
			LoaderHelp.addResCallBack(ResFileConst.petNavBg,onResCompl);
			this.configEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if(e.ctrlKey && _pet)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChatShowPet,_pet));
			}
		}
		
		protected function onResCompl():void
		{
			_isResCompl = true;
			if(_bg)
			{
				if(_selected)
				{
					_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetNav_disabledSkin);
				}
				else
				{
					_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetNav_upSkin);
				}
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_selected = false;
			_isResCompl = false;
			
			_bg.dispose(isReuse);
			_txtName.dispose(isReuse);
			_txtCombat.dispose(isReuse);
			_txtPetType.dispose(isReuse);
			_petHead.dispose(isReuse);
			
			_bg = null;
			_txtName = null;
			_txtCombat = null;
			_txtPetType = null;
			_petHead = null;
			
			_pet = null;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(!_bg || !_isResCompl)
			{
				return;
			}
			if(value)
			{
				_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetNav_disabledSkin);
			}
			else
			{
				_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetNav_upSkin);
			}
		}
		
		public function set data(value:Object):void
		{
			var pet:SPet = value as SPet;
			_pet = pet;
			if(pet)
			{
				_txtName.htmlText = PetUtil.getNameHtmlText(pet);
				_txtPetType.text = "天阶·神兽";
				_txtCombat.text = "战斗力：" + pet.publicPet.combatCapabilities.toString();
				var tpetConfig:TPetConfig = PetConfig.instance.getInfoByCode(pet.publicPet.code);
				_petHead.imgUrl = tpetConfig.avatar + ".png";
			}
			else
			{
				_txtName.text = "";
				_txtPetType.text = "";
				_txtCombat.text = "";
				_petHead.bitmapData = null;
			}
		}
		
		public function over():void
		{
			if(_bg && _isResCompl)
			{
				_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetNav_overSkin);
			}
		}
		
		public function out():void
		{
			if(_bg && _isResCompl)
			{
				_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetNav_upSkin);
			}
		}
	}
}