package mortal.game.view.guild.cellrender
{
	import Message.DB.Tables.TGuildLevelTarget;
	
	import com.mui.controls.GTextFiled;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;

	public class GuildPositionCellRenderer extends GuildCellRenderer
	{
		private var _txtGuildLevel:GTextFiled;
		private var _txtDeputyLeaderNum:GTextFiled;
		private var _txtPrestyerNum:GTextFiled;
		private var _txtEliteNum:GTextFiled;
		
		public function GuildPositionCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			_txtGuildLevel =  UIFactory.gTextField("1", 18, 3, 60, 20, this);
			_txtDeputyLeaderNum =  UIFactory.gTextField("1", 105, 3, 60, 20, this);
			_txtPrestyerNum =  UIFactory.gTextField("1", 178, 3, 60, 20, this);
			_txtEliteNum =  UIFactory.gTextField("1", 258, 3, 60, 20, this);
			UIFactory.bg(0,19.5,305,1,this,ImagesConst.SplitLine);
		}
		
		override public function set data(arg0:Object):void
		{
			var info:TGuildLevelTarget = arg0 as TGuildLevelTarget
			_txtGuildLevel.text = info.guildLevel.toString();
			_txtDeputyLeaderNum.text = info.deputyLeaderAmount.toString();
			_txtPrestyerNum.text = info.presbyterAmount.toString();
			_txtEliteNum.text = info.eliteAmount.toString();
		}
	}
}