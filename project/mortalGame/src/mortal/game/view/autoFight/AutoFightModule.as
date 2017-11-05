/**
 * 2014-3-11
 * @author chenriji
 **/
package mortal.game.view.autoFight
{
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import mortal.component.window.BaseWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.autoFight.render.AFAssistSkillRender;
	import mortal.game.view.autoFight.render.AFMainSkillRender;
	import mortal.game.view.autoFight.render.SelectBossRender;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class AutoFightModule extends BaseWindow
	{
		private var _bg1:ScaleBitmap;
		private var _bg2:ScaleBitmap;
		private var _bg3:ScaleBitmap;
		private var _bg4:ScaleBitmap;
		private var _bg5:ScaleBitmap;
		
		private var _titleBg1:ScaleBitmap;
		private var _titleBg2:ScaleBitmap;
		private var _titleBg3:ScaleBitmap;
		
		private var _cbSelectBoss:GCheckBox;
		private var _cbTaskBoss:GCheckBox;
		private var _listBoss:GTileList;
		
		// 攻击技能
		private var _cbMainSkill:GCheckBox;
		private var _cbbPlan:GComboBox;
		private var _listMainSkill:GTileList;
		
		// 辅助技能
		private var _cbAssistSkill:GCheckBox;
		private var _listAssistSkill:GTileList;
		
		// 最下面的三个按钮
		private var _btnAutoFight:GButton;
		private var _btnDefault:GButton;
		private var _btnSave:GButton;
		
		/**
		 * 关闭窗口或者保存设置的时候， 会触发保存， 此标记为是否需要保存 
		 */		
		private var _needSave:Boolean = false;
		
		
		private var _cbbData:Array = [
			{"name":0, "label":Language.getString(20181)},
			{"name":1, "label":Language.getString(20182)}
		];
		
		public function AutoFightModule($layer:ILayer=null)
		{
			super($layer);
			this.setSize(690, 490);
			this.title = Language.getString(20193);
			this.titleHeight = 40;
		}
		
		public function updateBossList(data:DataProvider):void
		{
			_listBoss.dataProvider = data;
			_listBoss.drawNow();
		}
		
		public function getPlanIndex():int
		{
			return _cbbPlan.selectedIndex;
		}
		
		/**
		 * 保存CheckBox中的值 
		 * @return true表示有更改
		 * 
		 */		
		public function saveModuleDatas():Boolean
		{
			var res:Boolean = false;
			if(_cbSelectBoss.selected == ClientSetting.local.getIsDone(IsDoneType.SelectBoss))
			{
				res = true;
				ClientSetting.local.setIsDone(!_cbSelectBoss.selected, IsDoneType.SelectBoss);
			}
			
			if(_cbTaskBoss.selected == ClientSetting.local.getIsDone(IsDoneType.SelectTaskBoss))
			{
				res = true;
				ClientSetting.local.setIsDone(!_cbTaskBoss.selected, IsDoneType.SelectTaskBoss);
			}
			
			if(_cbMainSkill.selected == ClientSetting.local.getIsDone(IsDoneType.UseMainSkill))
			{
				res = true;
				ClientSetting.local.setIsDone(!_cbMainSkill.selected, IsDoneType.UseMainSkill);
			}
			
			if(_cbAssistSkill.selected == ClientSetting.local.getIsDone(IsDoneType.UseAssistSkill))
			{
				res = true;
				ClientSetting.local.setIsDone(!_cbAssistSkill.selected, IsDoneType.UseAssistSkill);
			}
			
			if(ClientSetting.local.getIsDone(IsDoneType.UseSecondSkillPlan) && _cbbPlan.selectedIndex == 0)
			{
				res = true;
				ClientSetting.local.setIsDone(false, IsDoneType.UseSecondSkillPlan);
			}
			else if(!ClientSetting.local.getIsDone(IsDoneType.UseSecondSkillPlan) && _cbbPlan.selectedIndex == 1)
			{
				res = true;
				ClientSetting.local.setIsDone(true, IsDoneType.UseSecondSkillPlan);
			}
			
			
			return res;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bg1 = UIFactory.bg(17, 46, 661, 90, this);
			_bg2 = UIFactory.bg(17, 138, 330, 137, this);
			_bg3 = UIFactory.bg(349, 138, 330, 137, this);
			_bg4 = UIFactory.bg(17, 275, 330, 174, this);
			_bg5 = UIFactory.bg(349, 275, 330, 174, this);
			
			_titleBg1 = UIFactory.bg(_bg1.x + 2, _bg1.y+2, _bg1.width-4, 24, this, ImagesConst.RegionTitleBg);
			_titleBg2 = UIFactory.bg(_bg2.x + 2, _bg2.y+2, _bg2.width-4, 24, this, ImagesConst.RegionTitleBg);
			_titleBg3 = UIFactory.bg(_bg3.x + 2, _bg3.y+2, _bg3.width-4, 24, this, ImagesConst.RegionTitleBg);
			
			_cbSelectBoss = createCheckBox(Language.getString(20171), 28, 47, 120, 28, this);
			_cbTaskBoss = createCheckBox(Language.getString(20172), 131, 47, 120, 28, this);
			_listBoss = UIFactory.tileList(28, 70, 648, 62, this);
			_listBoss.setStyle("cellRenderer", SelectBossRender);
//			_listBoss.columnCount = 5;
			_listBoss.columnWidth = 125;
			_listBoss.rowHeight = 23;
			_listBoss.direction = GBoxDirection.VERTICAL;
			
			////////// 攻击技能
			_cbMainSkill = createCheckBox(Language.getString(20173), _titleBg2.x+8, _titleBg2.y - 1, 120, 28, this);
			_cbbPlan = UIFactory.gComboBox(_titleBg2.x+211, _titleBg2.y + 2, 110, 20, new DataProvider(_cbbData), this);
			_listMainSkill = UIFactory.tileList(_bg2.x + 24, _bg2.y + 30, 310, 105, this);
			_listMainSkill.setStyle("cellRenderer", AFMainSkillRender);
			_listMainSkill.columnWidth = 60;
			_listMainSkill.rowHeight = 50;
			
			// 辅助技能
			_cbAssistSkill = createCheckBox(Language.getString(20174), _titleBg3.x+8, _titleBg3.y-1, 120, 28, this);
			_listAssistSkill = UIFactory.tileList(_bg3.x + 14, _bg3.y + 30, 310, 105, this);
			_listAssistSkill.setStyle("cellRenderer", AFAssistSkillRender);
			_listAssistSkill.columnWidth = 150;
			_listAssistSkill.rowHeight = 50;
			
			// 下面的三个按钮
			_btnAutoFight = UIFactory.gButton(Language.getString(20177), _bg1.x + 365, _bg1.y + 405, 80, 24, this);
			_btnDefault = UIFactory.gButton(Language.getString(20175), _bg1.x + 463, _bg1.y + 405, 80, 24, this);
			_btnSave = UIFactory.gButton(Language.getString(20176), _bg1.x + 561, _bg1.y + 405, 80, 24, this);
			
			
			
			/////////////////////////////////////////////////////////// 监听事件
			_cbbPlan.configEventListener(Event.CHANGE, fightPlanChangeHandler);
			_btnAutoFight.configEventListener(MouseEvent.CLICK, autoFightHandler);
			_btnDefault.configEventListener(MouseEvent.CLICK, defaultHandler);
			_btnSave.configEventListener(MouseEvent.CLICK, saveHandler);
//			updateSelected();
			
			// 92, 229
		}
		
		private function autoFightHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.AutoFight_Round));
		}
		
		private function defaultHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.AutoFight_LoadDefault));
		}
		
		private var _lastSaveTime:int;
		private function saveHandler(evt:MouseEvent):void
		{
			var now:int = getTimer();
			if(now - _lastSaveTime < 2000)
			{
				return;
			}
			_lastSaveTime = now;
			Dispatcher.dispatchEvent(new DataEvent(EventName.AutoFight_Save));
		}
		
		public function updateMainSkillList(data:DataProvider):void
		{
			_listMainSkill.dataProvider = data;
			_listMainSkill.drawNow();
		}
		
		public function updateAssistSkillList(data:DataProvider):void
		{
			_listAssistSkill.dataProvider = data;
			_listAssistSkill.drawNow();
		}
		
		private function fightPlanChangeHandler(evt:Event):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.AutoFight_PlanChange, _cbbPlan.selectedIndex));
		}
		
		protected function createCheckBox($label:String, $x:int, $y:int, $width:int, $height:int, $parent:DisplayObjectContainer):GCheckBox
		{
			var res:GCheckBox = UIFactory.checkBox($label, $x, $y, $width, $height, $parent);
			res.configEventListener(Event.CHANGE, selectedChangeHandler);
			pushUIToDisposeVec(res);
			return res;
		}
		
		protected override function addWindowCenter2():void
		{
			
		}
		
		public function updateSelected(isDefault:Boolean=false):void
		{
			if(!isDefault)
			{
				_cbSelectBoss.selected = !ClientSetting.local.getIsDone(IsDoneType.SelectBoss);
				_cbTaskBoss.selected = !ClientSetting.local.getIsDone(IsDoneType.SelectTaskBoss);
				_cbMainSkill.selected = !ClientSetting.local.getIsDone(IsDoneType.UseMainSkill);
				_cbAssistSkill.selected = !ClientSetting.local.getIsDone(IsDoneType.UseAssistSkill);
				if(ClientSetting.local.getIsDone(IsDoneType.UseSecondSkillPlan))
				{
					_cbbPlan.selectedIndex = 1;
				}
				else
				{
					_cbbPlan.selectedIndex = 0;
				}
			}
			else
			{
				_cbSelectBoss.selected = true;
				_cbTaskBoss.selected = true;
				_cbMainSkill.selected = true;
				_cbAssistSkill.selected = true;
				_cbbPlan.selectedIndex = 0;
			}
		}
		
		private function selectedChangeHandler(evt:Event):void
		{
			var target:GCheckBox = evt.target as GCheckBox;
			if(target == null)
			{
				return;
			}
			switch(target.label)
			{
				case Language.getString(20171):
					break;
				case Language.getString(20172):
					break;
			}
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_bg1.dispose(isReuse);
			_bg1 = null;
			_bg2.dispose(isReuse);
			_bg2 = null;
			_bg3.dispose(isReuse);
			_bg3 = null;
			_bg4.dispose(isReuse);
			_bg4 = null;
			_bg5.dispose(isReuse);
			_bg5 = null;
			_titleBg1.dispose(isReuse);
			_titleBg1 = null;
			_titleBg2.dispose(isReuse);
			_titleBg2 = null;
			_titleBg3.dispose(isReuse);
			_titleBg3 = null;
//			_cbSelectBoss.dispose(isReuse);
			_cbSelectBoss = null;
//			_cbTaskBoss.dispose(isReuse);
			_cbTaskBoss = null;
			_listBoss.dispose(isReuse);
			_listBoss = null;
//			_cbMainSkill.dispose(isReuse);
			_cbMainSkill = null;
//			_cbbPlan.dispose(isReuse);
			_cbbPlan = null;
			_listMainSkill.dispose(isReuse);
			_listMainSkill = null;
//			_cbAssistSkill.dispose(isReuse);
			_cbAssistSkill = null;
			_listAssistSkill.dispose(isReuse);
			_listAssistSkill = null;
			_btnAutoFight.dispose(isReuse);
			_btnAutoFight = null;
			_btnDefault.dispose(isReuse);
			_btnDefault = null;
			_btnSave.dispose(isReuse);
			_btnSave = null;
		}
	}
}