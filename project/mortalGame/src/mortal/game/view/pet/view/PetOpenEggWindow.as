/**
 * @heartspeak
 * 2014-2-28 
 */   	

package mortal.game.view.pet.view
{
	import Message.Game.SPet;
	import Message.Public.EPetState;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.MouseEvent;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.SmallWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.model.vo.pet.PetOutOrInVO;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.utils.PetUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class PetOpenEggWindow extends SmallWindow
	{
		protected var _pet:SPet;
		
		protected var _panelBg:GBitmap;
		protected var _nameBg:ScaleBitmap;
		protected var _levelText:GTextFiled;
		protected var _petNameText:GTextFiled;
		protected var _btnGet:GButton;
		protected var _btnRelease:GButton;
		protected var _skillBg:GBitmap;
		protected var _skillItemBg:GBitmap;
		protected var _petTypeImage:GBitmap;
		protected var _petSkillImage:GBitmap;
		protected var _petTalentImage:GBitmap;
		protected var _petTypeText:GTextFiled;
		protected var _petTalentText:GTextFiled;
		
		public function PetOpenEggWindow($layer:ILayer=null)
		{
			super($layer);
			setSize(261,301);
			title = "宠物开蛋";
			titleHeight = 28;
		}
		
		private static var _instance:PetOpenEggWindow;
		
		public static function get instance():PetOpenEggWindow
		{
			if(!_instance)
			{
				_instance = new PetOpenEggWindow();
			}
			return _instance;
		}
		
		override protected function configParams():void
		{
			super.configParams();
			paddingBottom = 94;
		}
		
		override protected function setWindowCenter():void
		{
			
		}
		
		override protected function addWindowCenter2():void
		{
			
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_panelBg = UIFactory.gBitmap("",14,32,this);
			_nameBg = ResourceConst.getScaleBitmap("PetNameBg",21,32,230,26,this);
			_levelText = UIFactory.gTextField("LV.1",63,35,40,20,this,GlobalStyle.textFormatAnjin);
			_petNameText = UIFactory.gTextField("宠物名字",112,35,95,20,this,GlobalStyle.textFormatAnjin);
			_btnGet = UIFactory.gButton("领养",77,185,50,22,this);
			_btnRelease = UIFactory.gButton("放生",143,185,50,22,this);
			_skillBg = UIFactory.gBitmap("",95,227,this);
			_skillItemBg = UIFactory.gBitmap("",107,238,this);
			_petTypeImage = UIFactory.gBitmap("",20,218,this);
			_petSkillImage = UIFactory.gBitmap("",103,218,this);
			_petTalentImage = UIFactory.gBitmap("",185,218,this);
			_petTypeText = UIFactory.gTextField("法攻",33,249,50,20,this,GlobalStyle.textFormatHuang);
			_petTalentText = UIFactory.gTextField("500/1000",187,249,60,20,this,GlobalStyle.textFormatChen);
			
			_btnGet.configEventListener(MouseEvent.CLICK,onClickBtnGet);
			_btnRelease.configEventListener(MouseEvent.CLICK,onClickBtnRelease);
			LoaderHelp.addResCallBack(ResFileConst.petOpenEggWindow,onResCompl);
			LoaderHelp.addResCallBack(ResFileConst.skillPanel,onResSkillBgCompl);
		}
		
		protected function onResCompl():void
		{
			if(!_disposed)
			{
				_panelBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petOpenEggBg);
				_petTypeImage.bitmapData = GlobalClass.getBitmapData(ImagesConst.petTypeText);
				_petSkillImage.bitmapData = GlobalClass.getBitmapData(ImagesConst.petSkillText);
				_petTalentImage.bitmapData = GlobalClass.getBitmapData(ImagesConst.petTalentText);
			}
		}
		
		protected function onResSkillBgCompl():void
		{
			if(!_disposed)
			{
				_skillBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.SkillPanel_Circle);
				_skillItemBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.SkillRuneBg);
			}
		}
		
		protected function onClickBtnGet(e:MouseEvent):void
		{
			this.hide();
		}
		
		
		protected function onClickBtnRelease(e:MouseEvent):void
		{
			if(_pet)
			{
				var petOutOrInVO:PetOutOrInVO = new PetOutOrInVO(_pet.publicPet.uid,EPetState._EPetStateRelease);
				Dispatcher.dispatchEvent( new DataEvent(EventName.PetOutOrIn,petOutOrInVO));
				this.hide();
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_panelBg.dispose(isReuse);
			_nameBg.dispose(isReuse);
			_levelText.dispose(isReuse);
			_petNameText.dispose(isReuse);
			_btnGet.dispose(isReuse);
			_btnRelease.dispose(isReuse);
			_skillBg.dispose(isReuse);
			_skillItemBg.dispose(isReuse);
			_petTypeImage.dispose(isReuse);
			_petSkillImage.dispose(isReuse);
			_petTalentImage.dispose(isReuse);
			_petTypeText.dispose(isReuse);
			_petTalentText.dispose(isReuse);
			
			_panelBg = null;
			_nameBg = null;
			_levelText = null;
			_petNameText = null;
			_btnGet = null;
			_skillBg = null;
			_skillItemBg = null;
			_btnRelease = null;
			_petTypeImage = null;
			_petSkillImage = null;
			_petTalentImage = null;
			_petTypeText = null;
			_petTalentText = null;
			
			_pet = null;
		}
		
		/**
		 * 更新宠物信息 
		 * @param pet
		 * 
		 */
		public function updatePet(pet:SPet):void
		{
			this.show();
			_pet = pet;
			_levelText.text = "LV." + pet.publicPet.level;
			_petNameText.text = pet.publicPet.name;
			_petTalentText.htmlText = HTMLUtil.addColor(pet.publicPet.talent + "/" + 1000,PetUtil.getTalentColor(pet.publicPet.talent).color);
		}
	}
}