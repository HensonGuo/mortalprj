/**
 * 2014-3-12
 * @author chenriji
 **/
package mortal.game.view.autoFight.render
{
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.view.autoFight.data.AFSkillData;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.skill.SkillHookType;
	import mortal.game.view.skill.panel.SkillItem;
	import mortal.mvc.core.Dispatcher;
	
	public class AFAssistSkillRender extends GCellRenderer
	{
		private var _item:SkillItem;
		private var _myData:AFSkillData;
		private var _txt:GTextFiled;
		private var _txtInput:GTextInput;
		
		public function AFAssistSkillRender()
		{
			super();
		}
		
		public override function set data(value:Object):void
		{
			_myData = value as AFSkillData;
			if(_myData.info == null || !_myData.info.learned)
			{
				this.mouseEnabled = false;
				DisplayUtil.removeMe(_txtInput);
				return;
			}
			this.mouseEnabled = true;
			if(_txtInput.parent == null)
			{
				this.addChild(_txtInput);
			}
			_item.skillInfo = _myData.info;
			
			if(_myData.isActive)
			{
				_item.filters = [];
			}
			else
			{
				_item.filters = [FilterConst.colorFilter];
			}
			_txt.text = _myData.titleName;
			if(_myData.info.tSkill.hookType == SkillHookType.buff)
			{
				DisplayUtil.removeMe(_txtInput);
			}
			else
			{
				_txtInput.text = _myData.value.toString();
				this.addChild(_txtInput);
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_item = ObjectPool.getObject(SkillItem);
			_item.y = 6;
			this.addChild(_item);
			_item.isDragAble = false;
			_item.isDropAble = false;
			_item.isThrowAble = false;
			_item.isShowFreezingEffect = false;
			_item.isShowLeftTimeEffect = false;
			_item.isShowToolTip = true;
			_item.setSize(42, 42);
			_item.setBg();
			
			// 标题
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.leading = 6;
			_txt = UIFactory.gTextField("", 45, _item.y, 70, 60, this, tf);
			_txt.multiline = true;
			_txt.wordWrap = true;
			
			_txtInput = UIFactory.gTextInput(_item.x + 45, _item.y + 17, 40, 20, this);
			_txtInput.maxChars = 3;
			_txtInput.restrict = "0-9";
			
			_txtInput.configEventListener(TextEvent.TEXT_INPUT, valueChangeHandler);
			this.configEventListener(MouseEvent.CLICK, selectedChangeHandler);
		}
		
		private function selectedChangeHandler(evt:MouseEvent):void
		{
			if(_myData.info == null)
			{
				return;
			}
			_myData.isActive = !_myData.isActive;
		}
		
		private function valueChangeHandler(evt:TextEvent):void
		{
			_myData.value = parseInt(_txtInput.text);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
		}
	}
}