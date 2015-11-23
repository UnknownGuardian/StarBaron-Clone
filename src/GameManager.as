package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class GameManager extends Sprite
	{
		//all ports vector
		public static var allPorts:Vector.<Port> = new Vector.<Port>();
		
		//all ships vector
		public static var allShips:Vector.<Ship> = new Vector.<Ship>();
		
		//all selected ports
		public static var selectedPorts:Vector.<Port> = new Vector.<Port>();
		
		//layOver for mouse Events
		public static var layOver:LayOver = new LayOver();
		
		//stats
		public static var maxNumShips:int = 1000;
		
		public function GameManager() 
		{
			createLayOver();
			for (var i:int = 0; i < 20; i++)
			{
				createAllyPort();
				createEnemyPort();
			}
			addEventListener(Event.ENTER_FRAME, frame, false, 0, true);	
		}
		
		public function frame(e:Event):void
		{
			var i:int = 0
			for (i; i < GameManager.allShips.length; i++)
			{
				GameManager.allShips[i].frame();
			}
			for (i = 0; i < GameManager.allPorts.length; i++)
			{
				GameManager.allPorts[i].frame();
			}
			
			//update the ship counter
			layOver.numShips.text = "Ships: " + GameManager.getNumShips();
		}
		
		public function createLayOver():void
		{
			addChild(layOver);
		}
		
		public function createAllyPort():void
		{
			var p:Port = new Port(true);
			p.x = 50 + Math.random() * 300;
			p.y = 50 + Math.random() * 300;
			addChild(p);
		}
		public function createEnemyPort():void
		{
			var ep:Port = new Port(false);
			ep.x = 375 + Math.random() * 250;
			ep.y = 100 + Math.random() * 400;
			addChild(ep);
		}
		
		public static function getNumShips():int
		{
			return GameManager.allShips.length;
		}
		
		public static function getShipNumLimit():int
		{
			return GameManager.maxNumShips;
		}
		
		
	}

}