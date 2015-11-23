package  
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Ship extends Sprite
	{
		//if ally missile
		public var isAlly:Boolean;
		
		//port that the ship is docked too
		public var dock:Port;
		
		//speeds numbers
		public var xSpeed:Number = 0;
		public var ySpeed:Number = 0;
		
		//destination vars
		public var destinationPort:Port;
		
		//orbiting dock vars
		public var location:Point;
		public var rotator:Matrix;
		
		[Embed(source='data/Ship.jpg')]public var img:Class
		public function Ship(_isAlly:Boolean = true,_dock:Port = null) 
		{			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			
			//prevent clicking on
			mouseEnabled = false;
			
			//set is ally, and change color 
			isAlly = _isAlly;
			changeColor();
			
			//set the dock it belongs to
			dock = _dock;
			
			//create a matrix and point that handle orbiting status.
			rotator = new Matrix();
			rotator.rotate(3 / 180 * Math.PI); //3 degrees
			location = new Point(10, 0); //10 radius
			
			//set rotation
			rotation = 90;
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var s:DisplayObject = addChild(new img());
			s.x = -s.width / 2;
			s.y = -s.height / 2;
			
			//add into ship vector
			GameManager.allShips.push(this);
			
			//called once to prevent placement issues
			frame();
		}
		
		
		public function frame():void
		{
			if (isDocked())
			{
				/* //Old Code that handled orbiting
				rotation+=3;
				var p:Point = MathUtil.getPointRadiusDistance(new Point(dock.x, dock.y), 10, (rotation - 90)*Math.PI/180);
				x = p.x;
				y = p.y;
				*/
				rotation ++;
				rotation ++;
				rotation ++;
				location = rotator.transformPoint(location);
				x = dock.x + location.x;
				y = dock.y + location.y;
			}
			else
			{
				x += xSpeed;
				y += ySpeed;
				if (Math.abs(destinationPort.x - x) < 5 && Math.abs(destinationPort.y - y) < 5)
				{
					//dock ship at new port
					dockShip();
				}
			}
		}
		
	
		public function changeColor():void
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
		public function changeTarget(target:Port):void
		{
			//not docked anymore
			dock = null;
			
			//change rotation + speeds
			rotation = Math.atan2(target.y - y, target.x - x) * 180 / Math.PI;
			xSpeed = Math.cos(rotation* Math.PI/180) * 5;
			ySpeed = Math.sin(rotation * Math.PI / 180) * 5;
			
			//set destination coords
			destinationPort = target;
		}
		
		public function isDocked():Boolean
		{
			return dock != null;
		}
		
		public function dockShip():void
		{
			//accept this this ship
			destinationPort.acceptIncommingShip(this);
			//change the dock to this dock
			dock = destinationPort;
			//no destination since its docked now
			destinationPort = null;

			
			//create a matrix and point that handle orbiting status.
			rotator = new Matrix();
			rotator.rotate(3 / 180 * Math.PI); //3 degrees
			location = new Point(10, 0); //10 radius
			
			//set rotation
			rotation = 90;
		}
			
		public function destroyShip():void 
		{
			GameManager.allShips.splice(GameManager.allShips.indexOf(this), 1);
			parent.removeChild(this);
		}
		
		
		
		
		
		//==================================
		//local functions dedicated to speed
		//==================================
		
		//Replacement for Math.abs()
		public function abs(num:Number):Number
		{
			return (x ^ (x >> 31)) - (x >> 31);
		}
	}

}