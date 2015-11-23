package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import net.profusiondev.SiteLock;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.addChild(new GameManager());
			
			SiteLock.registerStage(stage)
			SiteLock.allowSites(["fastswf.com"]);
			SiteLock.allowLocalPlay();
			SiteLock.checkURL(true);
		}
		
	}
	
}
