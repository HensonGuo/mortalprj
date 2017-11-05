package mortal.game.view.wizard.panel
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.geom.Point;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.tableConfig.WizardConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.wizard.data.WizardData;
	
	public class SoulPanel extends GSprite
	{
		private var _wizardData:WizardData;
		
		private var _soulNum:int;
		
		private var _lineSprite:GSprite;
		
		private var _bg:GBitmap;
		
		private var _soulLists:Vector.<GBitmap>;
		
		private var _soulPointList:Vector.<Point>;
		
		private var _isLoad:Boolean;
		
		public function SoulPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.gBitmap("",0,0,this);
			
			_lineSprite = UICompomentPool.getUICompoment(GSprite);
			UIFactory.setObjAttri(_lineSprite,0,0,-1,-1,this);
			
			LoaderHelp.addResCallBack(ResFileConst.wizard, showSkin);
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_lineSprite.graphics.clear();
			_lineSprite.dispose(isReuse);
			_lineSprite = null;
		}
		
		private function showSkin():void
		{
			_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.WizardBg);
			
			_soulLists = new Vector.<GBitmap>();
			var icon:GBitmap;
			for(var i:int ; i < 8 ; i++)
			{
				icon = UIFactory.gBitmap(ImagesConst.WizardUnActivaty, 160 + 40*i,150,this);
				_soulLists.push(icon);
				this.pushUIToDisposeVec(icon);
			}
			
			if(!_isLoad)
			{
				refreshInfo();
			}
			
			_isLoad = true;
		}
		
		public function setWizardInfo(data:WizardData):void
		{
			_wizardData = data;
			_soulNum = (WizardConfig.instance.wizardUpArr[_wizardData.soulId] as Array).length;
			
			refreshInfo();
		}
		
		public function refreshInfo():void
		{
			if(!_isLoad)
			{
				return;
			}
			
			_lineSprite.graphics.clear();
			var len:int = _soulLists.length;
			for(var i:int ; i < len ; i++)
			{
				if(i < _soulNum)
				{
					_soulLists[i].visible = true;
					if(!_wizardData.sSoul || _wizardData.sSoul.level == 0)   //还没有精灵
					{
						_soulLists[i].bitmapData = GlobalClass.getBitmapData(ImagesConst.WizardUnActivaty);
						_soulLists[i].x = 160 + 40*i;
						_soulLists[i].y = 150;
					}
					else if(i < _wizardData.sSoul.node)  //当前升级穴位前面的穴位
					{
						_soulLists[i].bitmapData = GlobalClass.getBitmapData(ImagesConst..WizardActivated);
						_soulLists[i].x = 160 + 40*i;
						_soulLists[i].y = 150;
					}
					else if(i == _wizardData.sSoul.node)  //当前升级的穴位
					{
						_soulLists[i].bitmapData = GlobalClass.getBitmapData(ImagesConst.WizardActivating);
						_soulLists[i].x = 160 + 40*i - 8;
						_soulLists[i].y = 150-8;
					}
					else  //当前升级穴位后面的穴位
					{
						if(_wizardData.sSoul.level <= 1)  //如果当前最高的等级小于1或者0,则当前升级穴位后面的穴位皆显示为空
						{
							_soulLists[i].bitmapData = GlobalClass.getBitmapData(ImagesConst.WizardUnActivaty);
							_soulLists[i].x = 160 + 40*i;
							_soulLists[i].y = 150;
						}
						else
						{
							_soulLists[i].bitmapData = GlobalClass.getBitmapData(ImagesConst.WizardActivated);
							_soulLists[i].x = 160 + 40*i;
							_soulLists[i].y = 150;
						}
					}
					
					if(i > 0)
					{
						_lineSprite.graphics.lineStyle(2,GlobalStyle.blueUint);
						_lineSprite.graphics.moveTo(_soulLists[i-1].x,_soulLists[i-1].y);
						_lineSprite.graphics.lineTo(_soulLists[i].x,_soulLists[i].y);
						_lineSprite.graphics.endFill();
					}
				}
				else
				{
					_soulLists[i].visible = false;
				}
			}
		}
	}
}