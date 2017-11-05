/**
 * 2014-2-24
 * @author chenriji
 **/
package mortal.game.view.task.view.render
{
	import Message.DB.Tables.TNpc;
	
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gLinkText.GLinkText;
	import mortal.component.gLinkText.GLinkTextData;
	import mortal.game.model.NPCInfo;
	import mortal.game.resource.SceneConfig;
	import mortal.game.resource.tableConfig.NPCConfig;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.task.data.GLinkTextDataParser;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.data.TaskRule;
	
	public class TaskTrackBase extends GSprite
	{
		protected var _bodySprite:GSprite;
		protected var _taskInfo:TaskInfo;
		protected var _txts:Array;
		protected var _txtTitle:GTextFiled;
		protected var _dx:int = 0;
		
		public function TaskTrackBase()
		{
			super();
		}
		
		public function get taskInfo():TaskInfo
		{
			return _taskInfo;
		}

		public function set taskInfo(value:TaskInfo):void
		{
			_taskInfo = value;
			
			var npcId:int = _taskInfo.stask.getNpc;
			var data:GLinkTextData = GLinkTextDataParser.parseDataFromNpcId(npcId, value, 20161);
			var text:GLinkText = getText(0);
			text.isShowNum = false;
			text.y = 18;
			text.setLinkText(data, getExtendHtmlText());
			
			// 更新标题
			_txtTitle.htmlText = getTitleName();
		}
		
		protected function getExtendHtmlText():String
		{
			return "";
		}
		
		protected function getTaskStatusText():String
		{
			return _taskInfo.getStatusName();
		}
		
		protected function getTitleName():String
		{
			return "<font color='#FF73AB'>[" + TaskRule.getGroupShortName(_taskInfo.stask.group) + "]</font>" 
				+ _taskInfo.stask.name
				+ getTaskStatusText();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bodySprite = new GSprite();
			this.addChild(_bodySprite);
			_txtTitle = UIFactory.gTextField("", 0, 0, 220, 20, this);
			_txts = [];
		}
		
		/**
		 * 打开任务详细信息 
		 * 
		 */
		public function openInfo(isDispatchEvent:Boolean=false):void
		{
		}
		
		/**
		 * 关闭任务详细信息 
		 * 
		 */
		public function closeInfo(isDispatchEvent:Boolean=false):void
		{
			
		}
		
		protected function getText(index:int):GLinkText
		{
			if(_txts[index] == null)
			{
				var text:GLinkText = ObjectPool.getObject(GLinkText);
				text.widthConst = 200;
				_bodySprite.addChild(text);
				pushUIToDisposeVec(text);
				_txts[index] = text;
			}
			return _txts[index];
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_txtTitle.dispose(isReuse);
			_txtTitle = null;
			
			_bodySprite.dispose(isReuse);
			_bodySprite = null;
			
			_taskInfo = null;
			
			_txts = null;
		}
		
		override public function get height():Number
		{	
			var last:GLinkText = _txts[_txts.length - 1];
			return last.y + last.height;
		}
	}
}