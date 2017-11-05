package mortal.game.view.palyer
{
	import Message.DB.Tables.TExperience;
	import Message.Game.SRole;
	import Message.Public.ECareer;
	import Message.Public.SFightAttribute;
	
	import com.gengine.debug.Log;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.resource.ConfigCenter;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.configBase.ConfigConst;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.common.display.BitmapText;
	import mortal.game.view.common.display.NumberManager;

	public class AttributeInfoPart extends GSprite
	{
		//数据
		private var _attrNameArray:Array = [
			Language.getString(30124),Language.getString(30126),Language.getString(30125), //物理攻击,物理防御,法术防御
			Language.getString(30127),Language.getString(30128),Language.getString(30129),  //穿透闪避,命中
			Language.getString(30130),Language.getString(30131),Language.getString(30132),  //"暴击,韧性,档格
		    Language.getString(30133)];   //精准,免伤             ,Language.getString(30134)            
		
		private var _valArr:Array;
		private var _txtVec:Vector.<GTextFiled>;
		
		private var sFightAttribute:SFightAttribute;
		private var sRole:SRole = Cache.instance.role.roleInfo;
		
		//显示对象
		/**右边背景*/
		private var _attackVal:BitmapNumberText;     //攻击
		private var _physDefenseVal:BitmapNumberText;    //物防
		private var _magicDefenseVal:BitmapNumberText;    //法防
		private var _penetrationVal:BitmapNumberText;    //穿透
		private var _joukVal:BitmapNumberText;    //闪避
		private var _hitVal:BitmapNumberText;    //命中
		private var _critVal:BitmapNumberText;    //爆击
		private var _toughnessVal:BitmapNumberText;    //韧性
		private var _blockVal:BitmapNumberText;    //格挡
		private var _expertiseVal:BitmapNumberText;    //精准
		
		private var _comBat:BitmapNumberText;
		
		private var _attackTxt:GTextFiled;
		
		
		private var _shengmingBar:BaseProgressBar;
		private var _mofaBar:BaseProgressBar;
		private var _jinyanBar:BaseProgressBar;
		
		
		
		public function AttributeInfoPart()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(0,-2,168,97,this,ImagesConst.PanelBg));
			this.pushUIToDisposeVec(UIFactory.bg(0,98,168,72,this,ImagesConst.PanelBg));
			this.pushUIToDisposeVec(UIFactory.bg(0,173,168,235,this,ImagesConst.PanelBg));
			
			this.pushUIToDisposeVec(UIFactory.bg(10,5,150,20,this,ImagesConst.RolePowerBg));
			
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.RoleFightPower,25,9,this));
			
			var textFormat:GTextFormat = GlobalStyle.textFormatAnHuan;
			textFormat.size = 12;
			
			pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30120),5,100,65,25,this,textFormat));
			pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30121),5,123,65,25,this,textFormat));
			pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30122),5,147,65,25,this,textFormat));
			
			textFormat = GlobalStyle.textFormatPutong;
			textFormat.size = 10;
			_shengmingBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_shengmingBar.createDisposedChildren();
			_shengmingBar.setBg(ImagesConst.PetLifeBg,true,100,12);
			_shengmingBar.setProgress(ImagesConst.PetLife,true,1,1,98,16);
			_shengmingBar.setLabel(BaseProgressBar.ProgressBarTextNumber,15,-4,75,8,textFormat,"{0}");
			_shengmingBar.x = 60;
			_shengmingBar.y = 106;
			this.addChild(_shengmingBar);
			
			
			_mofaBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_mofaBar.createDisposedChildren();
			_mofaBar.setBg(ImagesConst.PetLifeBg,true,100,12);
			_mofaBar.setProgress(ImagesConst.PetLifespan,true,1,1,98,16);
			_mofaBar.setLabel(BaseProgressBar.ProgressBarTextNumber,15,-4,75,8,textFormat);
			_mofaBar.x = 60;
			_mofaBar.y = 129;
			this.addChild(_mofaBar);
			
			_jinyanBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_jinyanBar.createDisposedChildren();
			_jinyanBar.setBg(ImagesConst.PetLifeBg,true,100,12);
			_jinyanBar.setProgress(ImagesConst.PetExp,true,1,1,99,16);
			_jinyanBar.setLabel(BaseProgressBar.ProgressBarTextPercent,15,-4,75,8,textFormat);
			_jinyanBar.x = 60;
			_jinyanBar.y = 152;
			this.addChild(_jinyanBar);
			
//			_comBat = UICompomentPool.getUICompoment(BitmapText);
//			_comBat.createDisposedChildren();
//			_comBat.x = 40;
//			_comBat.y = 10;
//			_comBat.setFightNum(NumberManager.COLOR3,"99999",5);
//			addChild(_comBat);
			
			_comBat = UIFactory.bitmapNumberText(72,9, "FightInfoNum.png", 12, 15, -1, this);
			
			textFormat = GlobalStyle.textFormatAnHuan;
			textFormat.size = 12;
			_attackTxt = UIFactory.gTextField("",5,178,220,25,this,textFormat,true);
			
			createAttrTxt();
			
			_valArr = new Array();
			
			_attackVal = createAttrVal();
			_valArr.push(_attackVal);
			
			_physDefenseVal = createAttrVal();
			_valArr.push(_physDefenseVal);
			
			_magicDefenseVal = createAttrVal();
			_valArr.push(_magicDefenseVal);
			
			_penetrationVal = createAttrVal();
			_valArr.push(_penetrationVal);
			
			_joukVal = createAttrVal();
			_valArr.push(_joukVal);
			
			_hitVal = createAttrVal();
			_valArr.push(_hitVal);
			
			_critVal = createAttrVal();
			_valArr.push(_critVal);
			
			_toughnessVal = createAttrVal();
			_valArr.push(_toughnessVal);
			
			_blockVal = createAttrVal();
			_valArr.push(_blockVal);
			
			_expertiseVal = createAttrVal();
			_valArr.push(_expertiseVal);
			
			for(var i:int ; i < 10 ; i++)
			{
				this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.TargetBg2,(i%5)*30 + 13,int(i/5)*25 + 37,this));
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			for each(var n:BitmapNumberText in _valArr)
			{
				n.dispose(isReuse);
			}
			_valArr = [];
			
			_shengmingBar.dispose(isReuse);
			_mofaBar.dispose(isReuse);
			_jinyanBar.dispose(isReuse);
			_attackTxt.dispose(isReuse);
			_comBat.dispose(isReuse);
			
			_shengmingBar = null;
			_mofaBar = null;
			_jinyanBar = null;
			_comBat = null;
			
			_attackVal = null;
			_physDefenseVal = null;
			_magicDefenseVal = null;
			_penetrationVal = null;
			_joukVal = null;
			_hitVal = null;
			_critVal = null;
			_toughnessVal = null;
			_blockVal = null;
			_expertiseVal = null;
			
			_attackTxt = null;
			
			super.disposeImpl(isReuse);
		}
		
		
		
		/**
		 * 是否物理系职业 
		 * @param career
		 * @return 
		 * 
		 */
		private function isPhysicalCareer(career:int=-1):Boolean
		{
			if(career == -1)
			{
				career = Cache.instance.role.entityInfo.career;
			}
			switch(career)
			{
				case ECareer._ECareerArcher:
				case ECareer._ECareerWarrior:
					return true;
			}
			return false;
		}
		
		private function createAttrVal():BitmapNumberText
		{
			var i:int = _valArr.length;
			var baseX:int = 86;
			var baseY:int = 184;
			var horizontalGap:int = 23;
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			textFormat.size = 12;
			textFormat.align = TextFormatAlign.LEFT;
			var txt:BitmapNumberText = UIFactory.bitmapNumberText(baseX,baseY + horizontalGap*i, "RoleInfoNum.png", 8, 10, -1, this);
//			var txt:GTextFiled = UIFactory.gTextField("0",baseX,baseY + horizontalGap*i,65,25,this,textFormat,true);
			return txt;
		}
		
		/**
		 *创建属性文本域 
		 * 
		 */		
		private function createAttrTxt():void
		{
//			_txtVec = new Vector.<GTextFiled>();
			var len:int = 9;
			var baseX:int = 5;
			var baseY:int = 178;
			var horizontalGap:int = 23;
			var textFormat:GTextFormat = GlobalStyle.textFormatAnHuan;
			textFormat.size = 12;
			
			for(var i:int; i < len ; i++)
			{
				var txt:GTextFiled = UIFactory.gTextField(_attrNameArray[i+1],baseX,baseY + horizontalGap*(i + 1),65,25,this,textFormat,true);
//                var line:GBitmap = UIFactory.gBitmap(ImagesConst.RoleLine,baseX,baseY + horizontalGap*(i + 1) - 3,this);
				pushUIToDisposeVec(txt);
//				pushUIToDisposeVec(line);
			}
			
		}
		
		
		/**
		 * 更新全部数据 
		 * 
		 */		
		public function updateAllInfo(data:SFightAttribute):void
		{
			sFightAttribute = data;
			updateAttr();
			updateComBat();
			updateLife(sRole.life);
			updateMana(sRole.mana);
			updateExp(sRole.experience);
		}
		
		/**
		 * 更新生命 
		 * 
		 */		
		public function updateLife(value:int = 0):void
		{
			_shengmingBar.setValue(value,sFightAttribute.maxLife);
		}
		
		/**
		 *更新魔法 
		 * 
		 */		
		public function updateMana(value:int = 0):void
		{
			_mofaBar.setValue(value,sFightAttribute.maxMana);
		}
		
		
		/**
		 * 更新经验 
		 * 
		 */		
		public function updateExp(value:int = 0):void
		{
			var tExperience:TExperience = ConfigCenter.getConfigs(ConfigConst.expLevel, "level", sRole.level, true) as TExperience;
			_jinyanBar.setValue(value,tExperience.upgradeNeedExperience);
		}
		
		public function updateLevel():void
		{
			var tExperience:TExperience = ConfigCenter.getConfigs(ConfigConst.expLevel, "level", sRole.level, true) as TExperience;
			_jinyanBar.totalValue = tExperience.upgradeNeedExperience;
		}
		
		/**
		 *更新战斗属性 
		 * 
		 */		
		public function updateAttr():void
		{
			Log.debug("战斗属性更新");
			_attackVal.text = sFightAttribute.attack.toString();
			if(isPhysicalCareer())
			{
				
				_attackTxt.htmlText = Language.getString(30124);
			}
			else 
			{
				_attackTxt.htmlText = Language.getString(30123);
			}
			
			_physDefenseVal.text = sFightAttribute.physDefense.toString();
			_magicDefenseVal.text = sFightAttribute.magicDefense.toString();
			_penetrationVal.text = sFightAttribute.penetration.toString();
			_joukVal.text = sFightAttribute.jouk.toString();
			_hitVal.text = sFightAttribute.hit.toString();
			_critVal.text = sFightAttribute.crit.toString();
			_toughnessVal.text = sFightAttribute.toughness.toString();
			_blockVal.text = sFightAttribute.block.toString();
			_expertiseVal.text = sFightAttribute.expertise.toString();
		}
		
		public function updateComBat():void
		{
//			_comBat.setFightNum(NumberManager.COLOR3,Cache.instance.role.entityInfo.combat.toString(),5);
			_comBat.text = Cache.instance.role.entityInfo.combat.toString();
		}
		
		
	}
}