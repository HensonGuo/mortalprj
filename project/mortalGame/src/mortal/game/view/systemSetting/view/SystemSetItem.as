/**
 * @heartspeak
 * 2014-4-28 
 */   	

package mortal.game.view.systemSetting.view
{
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GRadioButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextInput;
	
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	
	import flash.events.Event;
	
	import frEngine.loaders.md5sub.ObjectBone;
	
	import mortal.game.view.common.NumInput;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.systemSetting.data.SettingItem;
	
	public class SystemSetItem extends GSprite
	{
		//显示
		protected var _checkBox:GCheckBox;
		
		protected var _numInput:NumInput;
		
		protected var _radioButtonGroup:RadioButtonGroup;
		
		protected var _radioButtons:Vector.<GRadioButton>;
		
		//数据
		protected var __height:Number = 0;
		
		protected var _settingItem:SettingItem;
		
		public function SystemSetItem()
		{
			super();
		}
		
		/**
		 * 设置数据 
		 * @param settingItem
		 * 
		 */		
		public function set data(settingItem:SettingItem):void
		{
			disposeImpl();
			_settingItem = settingItem;
			switch(settingItem.valueType)
			{
				case SettingItem.BOOLEAN:
					createCheckBox();
					break;
				case SettingItem.INT:
					createCheckBoxAndInput();
					break;
				case SettingItem.SELECT:
					createCheckBoxAndRadioBox();
					break;
			}
		}
		
		/**
		 * 刷新界面 
		 * 
		 */		
		public function refreshDisplay():void
		{
			switch(_settingItem.valueType)
			{
				case SettingItem.BOOLEAN:
					_checkBox.selected = Boolean(_settingItem.displayValue);
					break;
				case SettingItem.INT:
					_checkBox.selected = Boolean(_settingItem.displayValue);
					if(_settingItem.displayValue <= 0)
					{
						_numInput.currentNum = int(_settingItem.extend.def);
					}
					else
					{
						_numInput.currentNum = _settingItem.displayValue;
					}
					break;
				case SettingItem.SELECT:
					_checkBox.selected = _settingItem.displayValue > 0;
					var ary:Array = _settingItem.extend as Array;
					var length:int = ary.length;
					for(var i:int = 0;i < length;i++)
					{
						var obj:Object = ary[i];
						var radioButton:GRadioButton = _radioButtons[i];
						if(i == 0 || radioButton.value == _settingItem.displayValue)
						{
							radioButton.selected = true;
						}
					}
					break;
			}
		}
		
		protected function createCheckBox():void
		{
			_checkBox = UIFactory.checkBox(_settingItem.desStr,0,0,180,28,this);
			_checkBox.selected = Boolean(_settingItem.displayValue);
			_checkBox.configEventListener(Event.CHANGE,onSelectCheckBox);
			
			__height = 28;
		}
		
		/**
		 * 选择checkBox 
		 * @param e
		 * 
		 */		
		private function onSelectCheckBox(e:Event):void
		{
			_settingItem.displayValue = _checkBox.selected?1:0;
		}
		
		/**
		 * 输入类型 
		 * 
		 */		
		protected function createCheckBoxAndInput():void
		{
			_checkBox = UIFactory.checkBox(_settingItem.desStr,0,0,180,28,this);
			_checkBox.selected = Boolean(_settingItem.displayValue);
			_checkBox.configEventListener(Event.CHANGE,onUpdateIntValue);
			_numInput = UIFactory.numInput(25,28,this);
			_numInput.minNum = int(_settingItem.extend.min);
			_numInput.maxNum = int(_settingItem.extend.max);
			_numInput.configEventListener(Event.CHANGE,onUpdateIntValue);
			if(_settingItem.displayValue <= 0)
			{
				_numInput.currentNum = int(_settingItem.extend.def);
			}
			else
			{
				_numInput.currentNum = _settingItem.displayValue;
			}
			__height = 55;
		}
		
		private function onUpdateIntValue(e:Event = null):void
		{
			updateIntDisplayValue();
		}
		
		private function updateIntDisplayValue():void
		{
			if(_checkBox.selected)
			{
				_settingItem.displayValue = _numInput.currentNum;
			}
			else
			{
				_settingItem.displayValue = 0;
			}
		}
		
		/**
		 * 选择 
		 * 
		 */		
		protected function createCheckBoxAndRadioBox():void
		{
			_radioButtons = new Vector.<GRadioButton>();
			_radioButtonGroup = new RadioButtonGroup("systemSet" + _settingItem.key);
			_checkBox = UIFactory.checkBox(_settingItem.desStr,0,0,180,28,this);
			_checkBox.selected = _settingItem.displayValue > 0;
			var ary:Array = _settingItem.extend as Array;
			var length:int = ary.length;
			for(var i:int = 0;i < length;i++)
			{
				var obj:Object = ary[i];
				var radioButton:GRadioButton = UIFactory.radioButton(obj.text,20,28 + 28 * i,180,28,this);
				radioButton.value = obj.value;
				radioButton.group = _radioButtonGroup;
				radioButton.selected = false;
				if(i == 0)
				{
					radioButton.selected = true;
				}
				_radioButtons.push(radioButton);
			}
			if(_settingItem.displayValue > 0)
			{
				_radioButtonGroup.selectedData = _settingItem.displayValue
			}
			else
			{
				_radioButtons[0].selected = true;
			}
			__height = 28 + length * 28;
			_checkBox.configEventListener(Event.CHANGE,onSelectCheckBox2);
			_radioButtonGroup.addEventListener(Event.CHANGE,onRadioButtonChage);
		}
		
		/**
		 * 选择checkBox 
		 * @param e
		 * 
		 */		
		protected function onSelectCheckBox2(e:Event):void
		{
			updateRadioDisplayValue();
		}
		
		/**
		 * radioButton选择变化 
		 * @param e
		 * 
		 */		
		protected function onRadioButtonChage(e:Event):void
		{
			updateRadioDisplayValue();
		}
		
		protected function updateRadioDisplayValue():void
		{
			if(_checkBox.selected)
			{
				_settingItem.displayValue = int(_radioButtonGroup.selectedData);
			}
			else
			{
				_settingItem.displayValue = 0;
			}
		}
		
		override public function get height():Number
		{
			return __height;
		}
		
		/**
		 * 回收 
		 * @param isReuse
		 * 
		 */
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_settingItem = null;
			if(_checkBox)
			{
				_checkBox.dispose(isReuse);
				_checkBox = null;
			}
			if(_numInput)
			{
				_numInput.dispose(isReuse);
				_numInput = null;
			}
			if(_radioButtonGroup)
			{
				if(_radioButtons)
				{
					var length:int = _radioButtons.length;
					for(var i:int = 0; i < _radioButtons.length;i++)
					{
						_radioButtonGroup.removeRadioButton(_radioButtons[i]);
						_radioButtons[i].dispose(isReuse);
					}
					_radioButtons = null;
				}
				_radioButtonGroup.removeEventListener(Event.CHANGE,onRadioButtonChage);
				_radioButtonGroup = null;
			}
		}
	}
}