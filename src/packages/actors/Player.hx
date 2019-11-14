package packages.actors;

/**
 * ...
 * @author Kaelan
 */
class Player extends Thing
{
	public function new(_id:Int) 
	{
		//id, ego, superego, and the
		super(_id);
		
		group = TypeGroup.PLAYER;
	}
}