package mortal.game.scene3D.player.type
{
	public class AttachType
	{
		public static const NoAttach:int = 0;  //没有归属  默认
		public static const HasAttachNoSelf:int = 1; //有归属 但是不归属于自己 灰色
		public static const AttachSelf:int = 2; // 归属于自己 红色
		public static const AttachTeamMate:int = 3;//归属于队友
		
		public function AttachType()
		{
			
		}
	}
}