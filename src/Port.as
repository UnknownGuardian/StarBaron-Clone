package  
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Port extends Sprite
	{
		//if belongs to ally
		public var isAlly:Boolean;
		
		//vector of ships docked here
		public var dockedShips:Vector.<Ship> = new Vector.<Ship>();
		
		//Ship spawn counter, randomized to reduce pressure on CPU by creating many ships in a single frame
		public var shipSpawnCounter:int = Math.random() * 30 - 15;
		
		[Embed(source = 'data/Port.jpg')]public var img:Class
		public function Port(_isAlly:Boolean = true) 
		{
			doubleClickEnabled = true;
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			
			isAlly = _isAlly;
			changeColor();
			addMouseListeners();
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var p:DisplayObject = addChild(new img());
			p.x = -p.width / 2;
			p.y = -p.height / 2;
			
			//add into port vector
			GameManager.allPorts.push(this);
		}
		
		
		public function frame():void
		{
			shipSpawnCounter++;
			if (shipSpawnCounter > 30 && GameManager.getNumShips() < GameManager.getShipNumLimit() )
			{
				shipSpawnCounter = 0;
				var s:Ship = new Ship(isAlly,this);
				parent.addChild(s);
				dockedShips.push(s);
			}
		}
		
		//changes the color of the Port
		private function changeColor():void
		{
			if (isAlly)
			{
				transform.colorTransform = new ColorTransform(1, 1.5, 1);
			}
			else
			{
				transform.colorTransform = new ColorTransform(1.5, 1, 1);
			}
		}
		
		//returns the number of ships
		public function getNumShips():int
		{
			return dockedShips.length;
		}
		
		//handles incomming ships
		public function acceptIncommingShip(ship:Ship):void
		{
			//if they are of the same type
			if (ship.isAlly == isAlly)
			{
				//add them
				dockedShips.push(ship);
			}
			else
			{
				//remove the last ship to account for attacked ship, splice returns array, access at slot 0
				var removedShip:Ship = dockedShips.splice(getNumShips() - 1, 1)[0];
				
				//if no ships left
				if (getNumShips() == 0)
				{
					//now belongs to other team
					changeSides();
				}
				
				ship.destroyShip();
				removedShip.destroyShip();
			}
		}
		
		//add listeners that look for click events
		private function addMouseListeners():void
		{
			addEventListener(MouseEvent.CLICK, sendHalfShipsToTarget, false, 10, true);
			addEventListener(MouseEvent.DOUBLE_CLICK, sendAllShipsToTarget, false, 10, true);
		}
		
		
		//change sides from enemy to ally or vice versa
		private function changeSides():void
		{
			isAlly = !isAlly;
			changeColor();
			
			/******
			 * Perhaps add to selectedPorts
			 */
		}
		
		
		//sends half the ships in the selected ports to this port
		private function sendHalfShipsToTarget(e:MouseEvent):void
		{
			trace("[GameManager] Sending half ships. Number: " + GameManager.selectedPorts.length);
			for (var i:int = 0; i < GameManager.selectedPorts.length; i++)
			{
				var dockedShips:Vector.<Ship> = GameManager.selectedPorts[i].dockedShips;
				var half:int = dockedShips.length / 2;
				for (var j:int = dockedShips.length - 1; j >= half; j--)
				{
					dockedShips[j].changeTarget(this);
				}
				//removes all indicies after half
				dockedShips.length = half;
			}
		}
		
		//sends all ships in the seleceted ports to this port
		private function sendAllShipsToTarget(e:MouseEvent):void
		{
			trace("[GameManager] Sending all ships. Number: " + GameManager.selectedPorts.length);
			for (var i:int = 0; i < GameManager.selectedPorts.length; i++)
			{
				var dockedShips:Vector.<Ship> = GameManager.selectedPorts[i].dockedShips;
				for (var j:int = dockedShips.length -1; j >= 0; j--)
				{
					dockedShips[j].changeTarget(this);
				}
				dockedShips.length = 0;
			}
		}
		
	}

}